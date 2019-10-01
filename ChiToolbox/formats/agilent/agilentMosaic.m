function [wavenumbers, data, height, width, filename, acqdate] = agilentMosaic(filename, keepme)

% Function: agilentMosaic
% Usage: 
%   [wavenumbers, data, height, width, filename, acqdate] = agilentMosaic();
%   [wavenumbers, data, height, width, filename, acqdate] = agilentMosaic(filename);
%   [wavenumbers, data, height, width, filename, acqdate] = agilentMosaic(filename, keepme);
%
% Purpose:
%   Extracts the spectra from an Agilent (formerly Varian) .dmt/.dmd
%   file combination. 
%
%  input:
%   'filename' string containing the full path to the .dmt file (optional)
%   'keepme' vector of wavenumber values in pairs indicating the limits of regions to retain (optional)
% 
%  output:
%   'wavenumbers' is a list of the wavenumbers related to the data
%   'data' is a 3D cube of the data in the file ((fpaSize x X) x (fpaSize x Y) x wavenumbers)
%   'height' is height in pixels of the entire mosaic
%   'width' is width in pixels of the entire mosaic
%   'filename' is a string containing the full path to the .dmt file
%   'acqdate' is a string containing the date and time of acquisition
%
%                     *******Caution******* 
%   This code is a hack of the Agilent format and the location of the data
%   within the file may vary. Always check the output to make sure it is
%   sensible. If you have a file that doesn't work, please contact Alex.
%
%   Copyright (c) 2011 - 2019, Alex Henderson 
%   Contact email: alex.henderson@manchester.ac.uk
%   Licenced under the GNU General Public License (GPL) version 3
%   http://www.gnu.org/copyleft/gpl.html
%   Other licensing options are available, please contact Alex for details
%   If you use this file in your work, please acknowledge the author(s) in
%   your publications. 
%
%       version 8.0, September 2019
%   The latest version of this file is available on Bitbucket
%   https://bitbucket.org/AlexHenderson/agilent-file-formats

%       version 8.0, September 2019 Alex Henderson. Changed input to
%       request .dmt file rather than .dms file since the dms file was
%       never used anyway.
%       version 7.0, June 2017 Alex Henderson. Changed order of height and
%       width outputs
%       version 6.2, June 2017 Alex Henderson. Removed automatic plotting
%       feature. Code is simply commented out
%       version 6.1, June 2017 Alex Henderson. Modified fopen to be
%       compatible with Octave
%       version 6.0, March 2017 Alex Henderson. Calculate fpa size from data
%       rather than hardcoding as 128x128 pixels
%       version 5.0, May 2016 Alex Henderson, Renamed to agilentMosaic. No
%       change to operational code. 
%       version 4.1, March 2015 Alex Henderson, Small change to fix
%       filename case sensitivity issues on Linux. No other functional
%       changes. 
%       version 4.0, January 2014 Alex Henderson, Moved the data allocation
%       outside the file read loop. Also moved the wavenumber truncation
%       for keepme scenarios outside the file read loop.
%       version 3.0, November 2013 Alex Henderson, Added 'keepme' to allow
%       the data to have spectral regions removed during import
%       version 2.0, August 2012 Alex Henderson, replaced loop through
%       matrix with permute and flipdim
%       version 1.3, December 2011 Alex Henderson, added GPL licence and
%       incorporated the getfilename function
%       version 1.2, November 2011 Alex Henderson, the dmt filename is all
%       lowercase while the other filenames are of mixed case. Now we ask
%       for the .dms filename instead and build a lowercase .dmt filename
%       from that. This was only a problem in Linux. 
%       version 1.1, October 2011 Alex Henderson, the dms file only matches
%       the image if the number of tiles is small. Now we read each tile
%       separately. 
%       version 1.0, October 2011 Alex Henderson, initial release, based on
%       readvarian v2

%% ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
% Get the filename if not supplied
%
if (exist('filename', 'var') == 0)
    filename=getfilename('*.dmt', 'Agilent Mosaic Files (*.dmt)');

    if (isfloat(filename) && (filename==0))
        return;
    end
    
    filename=filename{1};
end

%% ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
% Extract the wavenumbers and date from the dmt file
%
[pathstr, name, ext] = fileparts(filename);  %#ok<ASGLU>

% The Agilent software stores all files with mixed case filenames except the
% dmt file which is all lowercase. 
name = lower(name);

dmtfilename = fullfile(pathstr,[name '.dmt']);

[fid, message] = fopen(dmtfilename, 'r', 'l');
if(fid == -1) 
    disp(['reading dmt file: ', dmtfilename]);
    error(message); 
end

% wavenumbers
    status = fseek(fid, 2228, 'bof');
    if(status == -1), message = ferror(fid, 'clear'); error(message); end
    startwavenumber = double(fread(fid, 1, 'int32'));
    
    status = fseek(fid, 2236, 'bof');
    if(status == -1), message = ferror(fid, 'clear'); error(message); end
    numberofpoints = double(fread(fid, 1, 'int32'));
    
    status = fseek(fid, 2216, 'bof');
    if(status == -1), message = ferror(fid, 'clear'); error(message); end
    wavenumberstep = fread(fid, 1, 'double');
    
    startwavenumber = 466;
    numberofpoints = 1505;
    wavenumberstep = 1.98;
    
    
    
    
    % some validation
        if(startwavenumber < 0)
            error('Start wavenumber is negative. Cannot read this file.');
        end
        
%         if(numberofpoints ~= vals)
%             error('Number of data points does not match between .dms and .dmt files. Cannot read this file.');
%         end            
    
    wavenumbers = 1:(numberofpoints+startwavenumber-1);
    wavenumbers = wavenumbers * wavenumberstep;
    wavenumbers = wavenumbers(startwavenumber:end);

% date
    % Longest date is: Wednesday, September 30, 2011 00:00:00
    status = fseek(fid, 0, 'bof');
    if(status == -1), message = ferror(fid, 'clear'); error(message); end

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
          month='01'; %#ok<*NASGU>
       case 'February'
          month='02'; 
       case 'March'
          month='03';
       case 'April'
          month='04';
       case 'May'
          month='05';
       case 'June'
          month='06';
       case 'July'
          month='07';
       case 'August'
          month='08';
       case 'September'
          month='09';
       case 'October'
          month='10';
       case 'November'
          month='11';
       case 'December'
          month='12';
       otherwise
          month='99';
    end

    acqdate = [day, ' ', monthword, ' ', year, ', ', hours, ':', minutes,':',seconds];
    
fclose(fid);

%% ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
% Determine the mosaic dimensions
%
[pathstr, name, ext] = fileparts(filename);  %#ok<ASGLU>
tiles_in_x_dir = xtiles(fullfile(pathstr,name));
tiles_in_y_dir = ytiles(fullfile(pathstr,name));

tilefilename = fullfile(pathstr,[name,'_0000_0000.dmd']);
tile = dir(tilefilename);
bytes = tile.bytes;
bytes = bytes / 4;
bytes = bytes - 255;
bytes = bytes / length(wavenumbers);
fpaSize = sqrt(bytes);  % fpaSize likely to be 64 or 128 pixels square

%% ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
% Handle sections we want to keep, if specified
%
if exist('keepme', 'var')

   if(isempty(keepme))
       error('keepme limits list is empty');
   end
   
   keepme=columnvector(keepme);

   if(rem(length(keepme),2) ~= 0)
       error('keepme limits list is not an even number');
   end

   keepme=sort(keepme);           
   keepme=reshape(keepme,2,[]);
   keepme=keepme';
   numberofsections=size(keepme,1);
end

%% ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
% Allocate memory for output
% 
limits=[];
if (exist('keepme', 'var'))
    keptwavenumbers=[];
    for section=1:numberofsections
        limits=indicesfromvalues(keepme(section,:), wavenumbers);
        keptwavenumbers=cat(2,keptwavenumbers,wavenumbers(limits(1):limits(2)));
    end
    wavenumbers=keptwavenumbers;
end

data=zeros(fpaSize*tiles_in_y_dir, fpaSize*tiles_in_x_dir, length(wavenumbers));

%% ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
% Read each .dmd file
%
[pathstr, name, ext] = fileparts(filename);  %#ok<ASGLU>

for y = 1:tiles_in_y_dir
    for x = 1:tiles_in_x_dir

        current_extn = sprintf('_%04d_%04d.dmd', x-1, y-1);
        tempfilename = fullfile(pathstr,[name, current_extn]);
        [fid, message] = fopen(tempfilename, 'r', 'l');
        if(fid == -1) 
            disp(['reading dmd file: ', tempfilename]);
            error(message); 
        end

        status = fseek(fid,255*4,'bof');
        if (status == -1)
            error(['Cannot read ', tempfilename]);
        end
        tempdata = fread(fid, inf, '*float32');
        fclose(fid);
        
        tempdata = reshape(tempdata,fpaSize,fpaSize,[]);

        % remove spectral ranges during file read stage
        if (exist('keepme', 'var'))
            keptdata=[];
            for section=1:numberofsections
                keptdata=cat(3,keptdata,tempdata(:,:,limits(1):limits(2)));
            end
            tempdata=keptdata;
        end
        
        % rotate the image to match the spectrometer's output
        tempdata=permute(tempdata,[2,1,3]);
        tempdata=flipdim(tempdata,1); %#ok<DFLIPDIM>
        
        % insert this tile into the image
        data((1+((y-1)*fpaSize)) : (y*fpaSize), (1+((x-1)*fpaSize)) : (x*fpaSize), :) = tempdata;
    end
end
clear tempdata;

data=double(data);
[height, width, datapoints]=size(data); %#ok<ASGLU>

%% ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
% % Plot the data
% %
% window_title = filename;
% figure('Name',window_title,'NumberTitle','off');
% imagesc(sum(data,3));axis image;axis off;
% [pathstr, name, ext] = fileparts(filename); 
% titlefilename = fullfile(pathstr,name);
% title(titlefilename, 'interpreter', 'none');

end % of main function

%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
%~~~~~~~~~~~~~~~~~~~  End main function  ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

%% ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
function tiles_in_x_dir = xtiles(basefilename)

% count tiles in x dimension

tiles_in_x_dir = 1;
finished = false;
counter = 0;
while (~finished)
    current_extn = sprintf('_%04d_0000.dmd', counter);
    tempfilename = [basefilename, current_extn];
    if exist(tempfilename,'file')
        counter = counter + 1;
    else
        tiles_in_x_dir = counter;
        finished = true;
    end        
end

end

%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
function tiles_in_y_dir = ytiles(basefilename)

% count tiles in y dimension

tiles_in_y_dir = 1;
finished = false;
counter = 0;
while (~finished)
    current_extn = sprintf('_0000_%04d.dmd', counter);
    tempfilename = [basefilename, current_extn];
    if exist(tempfilename,'file')
        counter = counter + 1;
    else
        tiles_in_y_dir = counter;
        finished = true;
    end        
end

end
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

function [column, rotated]=columnvector(vector)

% function: columnvector
% version 2.0  
%
% usage: [column, rotated]=columnvector(vector);
%
% 'column' is the vector expressed as a column vector
% 'rotated' is 1 if the vector was rotated and 0 if it was already a column
% vector
%
% Forces conversion of vector to be a column vector
%
% Alex Henderson, May 2010 -> Aug 2012

% version 1, May 2010, initial release
% version 2, Aug 2012, introduced the flag for rotation

if length(size(vector)) ~= 2
    error('this isn''t a vector');
end

[r,c]=size(vector);
if min(r, c) ~= 1
    error('this isn''t a vector');
end

if r < c
    column=vector';
    rotated=1;
else
    column=vector;
    rotated=0;
end
end % of function columnvector

%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
function [indices]=indicesfromvalues(values, valuearray)

% Function indicesfromvalues
% Determines the index into the array (valuearray) of each value.
%
% usage: [indices]=indicesfromvalues(values, valuearray);
%
% Alex Henderson June 2010

indices=zeros(size(values));

for index=1:length(values)
    [indices(index)]=indexfromvalue(values(index), valuearray);
end
end % of function indicesfromvalues

%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
function [index]=indexfromvalue(value, values)

% Function indexfromvalue
% Determines the index into the array (values) that the value appears at.
% Output is the index of the value next greater than the value required.
%
% usage: [index]=indexfromvalue(value, values);
%
% Alex Henderson June 2010

for index=1:length(values)
    if (values(index) > value)
        return;
    end
end
end % of function indexfromvalue

%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~


