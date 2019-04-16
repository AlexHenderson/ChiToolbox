function [wavenumbers, data, height, width, filename, acqdate] = agilentImage(filename, showImage)

%   Function: agilentImage
%   Usage: [wavenumbers, data, height, width, filename, acqdate] = agilentImage();
%   Usage: [wavenumbers, data, height, width, filename, acqdate] = agilentImage(filename);
%
%   Extracts the spectra from an Agilent (formerly Varian) single tile FPA
%   image.
%
%   input:
%   'filename' string containing the full path to the .seq file (optional)
% 
%   output:
%   'wavenumbers' is a list of the wavenumbers related to the data
%   'data' is a 3D cube of the data in the file (height x width x wavenumbers)
%   'height' is the height of the image in pixels (columns)
%   'width' is the width of the image in pixels (rows)
%   'filename' is a string containing the full path to the .bsp file
%   'acqdate' is a string containing the date and time of acquisition
%
%                     *******Caution******* 
%   This code is a hack of the Agilent format and the location of the data
%   within the file may vary. Always check the output to make sure it is
%   sensible. If you have a file that doesn't work, please contact Alex. 
%
%   Copyright (c) 2011 - 2017, Alex Henderson 
%   Contact email: alex.henderson@manchester.ac.uk
%   Licenced under the GNU General Public License (GPL) version 3
%   http://www.gnu.org/copyleft/gpl.html
%   Other licensing options are available, please contact Alex for details
%   If you use this file in your work, please acknowledge the author(s) in
%   your publications. 
%
%   version 6.0, June 2017
%   The latest version of this file is available on Bitbucket
%   https://bitbucket.org/AlexHenderson/agilent-file-formats
%
%   version 6.0, June 2017 Alex Henderson. Changed order or width and
%       height outputs
%   version 5.1, June 2017 Alex Henderson. Removed automatic plotting
%       feature. Code is simply commented out
%   version 5.0, June 2017 Alex Henderson. Calculate fpa size from data
%       rather than hardcoding as 128x128 pixels.
%       Changed fopen to be compatible with Octave. 
%   version 4.0, June 2017, Added width and height as outputs and changed
%       function name
%   version 3.0, August 2012, replaced loop through matrix with permute and
%       flipdim
%   version 2.1, December 2011, added GPL licence and incorporated
%       the getfilename function
%   version 2.0, June 2011, made date stamp more reliable using regex
%   version 1.0, May 2011, initial release

%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
% get the filename if not supplied

if (exist('filename', 'var') == 0)
    filename=getfilename('*.seq', 'Agilent Image Files (*.seq)');

    if (isfloat(filename) && (filename==0))
        return;
    end
    
    filename=filename{1};
end

%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
% extract the wavenumbers and date from the bsp file

[pathstr, name] = fileparts(filename); 
bspfilename = fullfile(pathstr,[name '.bsp']);

[fid, message] = fopen(bspfilename, 'r', 'l');
if(fid == -1) 
    disp(['reading bsp file: ', bspfilename]);
    error(message); 
end;

% wavenumbers
    status = fseek(fid, 2228, 'bof');
    if(status == -1), message = ferror(fid, 'clear'); error(message); end;
    startwavenumber = double(fread(fid, 1, 'int32'));
    
    status = fseek(fid, 2236, 'bof');
    if(status == -1), message = ferror(fid, 'clear'); error(message); end;
    numberofpoints = double(fread(fid, 1, 'int32'));
    
    status = fseek(fid, 2216, 'bof');
    if(status == -1), message = ferror(fid, 'clear'); error(message); end;
    wavenumberstep = fread(fid, 1, 'double');
    
    % some validation
        if(startwavenumber < 0)
            error('Start wavenumber is negative. Cannot read this file.');
        end
        
%         if(numberofpoints ~= vals)
%             error('Number of data points does not match between .dat and .bsp files. Cannot read this file.');
%         end            
    
    wavenumbers = 1:(numberofpoints+startwavenumber-1);
    wavenumbers = wavenumbers * wavenumberstep;
    wavenumbers = wavenumbers(startwavenumber:end);

% date
    % Longest date is: Wednesday, September 30, 2011 00:00:00
    status = fseek(fid, 0, 'bof');
    if(status == -1), message = ferror(fid, 'clear'); error(message); end;

    str = fread(fid, inf, '*char')';
    expr = 'Time Stamp.{44}\w+, (\w+) (\d\d), (\d\d\d\d) (\d\d):(\d\d):(\d\d)';

    [start_idx, end_idx, extents, matches, tokens, names, splits] = regexp(str, expr); %#ok<ASGLU>

    monthword=tokens{1,1}{1};
    day=tokens{1,1}{2};
    year=tokens{1,1}{3};
    hours=tokens{1,1}{4};
    minutes=tokens{1,1}{5};
    seconds=tokens{1,1}{6};
    
    switch monthword
       case 'January'
          month='01'; %#ok<NASGU>
       case 'February'
          month='02'; %#ok<NASGU>
       case 'March'
          month='03'; %#ok<NASGU>
       case 'April'
          month='04'; %#ok<NASGU>
       case 'May'
          month='05'; %#ok<NASGU>
       case 'June'
          month='06'; %#ok<NASGU>
       case 'July'
          month='07'; %#ok<NASGU>
       case 'August'
          month='08'; %#ok<NASGU>
       case 'September'
          month='09'; %#ok<NASGU>
       case 'October'
          month='10'; %#ok<NASGU>
       case 'November'
          month='11'; %#ok<NASGU>
       case 'December'
          month='12'; %#ok<NASGU>
       otherwise
          month='99'; %#ok<NASGU>
    end;

    acqdate = [day, ' ', monthword, ' ', year, ', ', hours, ':', minutes,':',seconds];
    
fclose(fid);

%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
% read the .dat file
[pathstr, name] = fileparts(filename); 
datfilename = fullfile(pathstr,[name '.dat']);

[fid, message] = fopen(datfilename, 'r', 'l');
if(fid == -1) 
    disp(['reading dat file: ', datfilename]);
    error(message); 
end;

data = double(fread(fid, inf, '*float32'));
fclose(fid);

%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
% Determine the FPA size
tile = dir(datfilename);
bytes = tile.bytes;
bytes = bytes / 4;
bytes = bytes - 255;
bytes = bytes / length(wavenumbers);
fpaSize = sqrt(bytes);  % fpaSize likely to be 64 or 128 pixels square

%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
% pull out the relevant parts and reshape to a cube
data=data(256:end);
data=reshape(data,fpaSize,fpaSize,[]);
[height,width,vals]=size(data); %#ok<ASGLU>

%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
% rotate the image to match the spectrometer's output
data=permute(data,[2,1,3]);
data=flipdim(data,1); %#ok<DFLIPDIM>

%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
% % plot the data
% window_title = datfilename;
% figure('Name',window_title,'NumberTitle','off');
% imagesc(sum(data,3));axis image;axis off;
% [pathstr, name] = fileparts(filename); 
% datfilename = fullfile(pathstr,name);
% title(datfilename, 'interpreter', 'none');

end % function agilentImage

%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
function filename=getfilename(filter, filtername)

%   Function: getfilename
%   Usage: [filename] = getfilename(filter, filtername);
%
%   Collects a single filename from the user.
%   For multiple filenames use getfilenames.m
%
%   'filter' and 'filtername' are strings of the form...
%       filter = '*.mat'
%       filtername = 'MAT Files (*.mat)'
%   'filename' is a char array containing the name of the file including
%   the path
%
%   (c) May 2011, Alex Henderson
%

% Mostly based on getfilenames and tweaked to only accept a single filename

filetypes = {   filter, filtername; ...
                '*.*',    'All Files (*.*)'};

% example...            
%filetypes = {   '*.mat',  'MAT Files (*.mat)'; ...
%                '*.*',    'All Files (*.*)'};

setappdata(0,'UseNativeSystemDialogs',false);

[filenames, pathname] = uigetfile(filetypes, 'Select file...', 'MultiSelect', 'off');

if (isfloat(filenames) && (filenames==0))
    disp('Error: No filename selected');
    filename=0;
    return;
end

if(iscell(filenames))
    % change from a row of filenames to a column of filenames
    % if only one file is selected we have a single string (not a cell
    % array)
    filenames = filenames';
else
    % convert the filename to a cell array (with one entry)
    filenames=cellstr(filenames);
end

for i=1:size(filenames,1)
    filenames{i,1}=[pathname,filenames{i,1}];
end
filename=filenames;

end
%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
