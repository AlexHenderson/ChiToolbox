function [ramanshift,data,height,width,filename,acqdate,x_label,y_label] = renishawWire(filename,plotContents)

%   Function: renishawWire
%   Usage: [ramanshift,data,height,width,filename,acqdate,x_label,y_label] = renishawWire();
%   Usage: [ramanshift,data,height,width,filename,acqdate,x_label,y_label] = renishawWire(filename);
%   Usage: [ramanshift,data,height,width,filename,acqdate,x_label,y_label] = renishawWire(filename,plotContents);
%
%   Extracts the data from a Renishaw .wdf file.
%   Currently only reads version 4 of WiRE. 
%   Optionally plots the contents of the file as either a single spectrum,
%   a series of spectra overlaid, or an image or spectrum of the total
%   signal.
%
%   input:
%   'filename' string containing the full path to the .wdf file (optional)
%   'plotContents' 1 or 0 where 1 means plot the contents and 0 (default)
%       means do not (optional). Only used when a filename is provided. 
% 
%   output:
%   'ramanshift' is a list of the Raman shifts related to the data
%   'data' is a 3D hypercube of the data in the file (height x width x ramanshifts)
%   'filename' is a string containing the full path to the .wdf file
%   'acqdate' is a string containing the date and time of acquisition
%   'x_label' is the name of the unit on the x axis (Raman shift in wavenumber)
%   'y_label' is the name of the unit on the y axis (intensity)
%
%                     *******Caution******* 
%   This code is a hack of the WiRE format and the location of the data
%   within the file may vary. Always check the output to make sure it is
%   sensible. If you have a file that doesn't work, please contact Alex. 
%
%   Copyright (c) 2014 - 2017, Alex Henderson 
%   Contact email: alex.henderson@manchester.ac.uk
%   Licenced under the GNU General Public License (GPL) version 3
%   http://www.gnu.org/copyleft/gpl.html
%   Other licensing options are available, please contact Alex for details
%   If you use this file in your work, please acknowledge the author(s) in
%   your publications. 
%
%   version 4.0 June 2017, Alex Henderson
%   The latest version of this file is available on Bitbucket
%   https://bitbucket.org/AlexHenderson/renishaw-file-formats

%   version 4.0 June 2017, Alex Henderson
%       Changed default plotting option to make not plotting the output 
%       the default. 
%   version 3.2 April 2017, Alex Henderson
%       Fix for reading files in Linux. Bizarre problem when reading many
%       bytes using *char. Worked fine on Windows, but adds additional
%       characters in Linux. Now using uint8. This data wasn't used anyway,
%       but...
%   version 3.1 April 2017, Alex Henderson
%       Small changes in help info and code prettification. Title on plots
%       is now only the filename, not the path. Output badged as Raman
%       shift. 
%   version 3.0 July 2016, Alex Henderson
%       Added option not to plot the data.  
%   version 2.0 October 2015, Alex Henderson
%       Modified to handle files that contain one or more spectra rather
%       than an image.
%   version 1.1 August 2015, Alex Henderson
%       Added an empty block identifier which appears to accept files
%       acquired on a different instrument (785 nm laser in addition to 532
%       nm). Note these two files have different numbers of blocks. 
%   version 1.0 December 2014, Alex Henderson
%       Initial release.

%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
% Get the filename if not supplied
if ~exist('filename', 'var')
    filename = getfilename('*.wdf', 'Renishaw Files (*.wdf)');
    if (isfloat(filename) && (filename == 0))
        return;
    end
    filename = filename{1};
end

%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
% Define some defaults
height = 1;
width = 1;

if ~exist('plotContents','var')
    plotContents = false;
end

%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
% Read the file contents
try
    fid = fopen(filename,'r','l');
    
    finished = false;
    while ~finished
        [blockName,blockSize] = getBlockID(fid);
%         disp([blockName, ' : ', num2str(blockSize)]);

        switch blockName
            case 'WDF1'
                [blockContents,blockSize] = readWDF1Block(fid);
            case 'DATA'
                data = readDATABlock(fid);
            case 'XLST'
                xlst = readXLSTBlock(fid);
%             case 'YLST'
%                 ylst = readYLSTBlock(fid);
            case 'WMAP'
                [width,height] = readWMAPBlock(fid);
            case 'WCHK'
                finished = true;
            case ''
                finished = true;
            otherwise
                status = fseek(fid,blockSize,'cof');
                if (status == -1)
                    finished = true;
                end
        end
    end
    
    [creationTimeStr,creationTime] = readCreationTime(fid);
    acqdate = creationTimeStr;

    if exist('fid', 'var')
        fclose(fid);
        clear fid;
    end
    
    data = reshape(data,length(xlst),[]);
    data = data';
    data = reshape(data,height*width,[]);
    data = fliplr(data);
    data = reshape(data,height,width,[]);
    xlst = flipud(xlst); 
    ramanshift = xlst;
    
    x_label = 'Raman shift (cm^{-1})';
    y_label = 'intensity';
    
    if ((height == 1) && (width == 1))
        % We have one or more spectra rather than an image
        data = squeeze(data);
        if iscolumn(data)
            data = data';
        end
        
        % Check to see if we have a single spectrum or a profile
        if (length(data) ~= length(ramanshift))
            data = reshape(data,[],length(ramanshift));
        end               
        
        if plotContents
            plotSpectralData(ramanshift,data,x_label,y_label,filename);
        end
    else
        if plotContents
            plotImageData(data,filename);
        end
    end
    
catch exception
    if exist('fid','var')
        fclose(fid);
        clear fid;
    end
    error(exception.message);
end

end

%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
function [blockName, blockSize] = getBlockID(fid)
    position = ftell(fid);
    blockName = fread(fid,4,'*char')';
    unknown = fread(fid,1,'int32');
    blockSize = fread(fid,1,'int32');
    status = fseek(fid,position,'bof');    
end

%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
function [blockContents,blockSize] = readWDF1Block(fid)
    position = ftell(fid);
    blockName = fread(fid,4,'char')';
    unknown = fread(fid,1,'int32');
    blockSize = fread(fid,1,'int32');
    dataStart = ftell(fid);
    dataEnd = position + blockSize;
    dataSize = dataEnd - dataStart;
    blockContents = fread(fid,dataSize,'*uint8');
end

%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
function data = readDATABlock(fid)
    position = ftell(fid);
    blockName = fread(fid,4,'*char')';
    unknown1 = fread(fid,1,'int32');
    blockSize = fread(fid,1,'int32');
    unknown2 = fread(fid,1,'int32');
    dataStart = ftell(fid);
    dataEnd = position + blockSize;
    dataSize = dataEnd - dataStart;
    numPts = dataSize / 4;
    data = fread(fid,numPts,'float');
end

%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
function data = readXLSTBlock(fid)
    position = ftell(fid);
    blockName = fread(fid,4,'*char')';
    unknown1 = fread(fid,1,'int32');
    blockSize = fread(fid,1,'int32');
    unknown2 = fread(fid,1,'int32');
    unknown3 = fread(fid,1,'int32');
    unknown4 = fread(fid,1,'int32');
    dataStart = ftell(fid);
    dataEnd = position + blockSize;
    dataSize = dataEnd - dataStart;
    numPts = dataSize / 4;
    data = fread(fid,numPts,'float');
end

%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
function data = readYLSTBlock(fid)
    position = ftell(fid);
    blockName = fread(fid,4,'*char')';
    unknown1 = fread(fid,1,'int32');
    blockSize = fread(fid,1,'int32');
    unknown2 = fread(fid,1,'int32');
    unknown3 = fread(fid,1,'int32');
    unknown4 = fread(fid,1,'int32');
    dataStart = ftell(fid);
    dataEnd = position + blockSize;
    dataSize = dataEnd - dataStart;
    numPts = dataSize / 4;
    data = fread(fid,numPts,'float');
end

%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
function [width,height] = readWMAPBlock(fid)
    position = ftell(fid);
    blockName = fread(fid,4,'*char')';
    unknown01 = fread(fid,1,'int32');
    blockSize = fread(fid,1,'int32');
    unknown02 = fread(fid,1,'int32');
    unknown03 = fread(fid,1,'int32');
    unknown04 = fread(fid,1,'int32');
    unknown05 = fread(fid,1,'float'); 
    unknown06 = fread(fid,1,'float');
    unknown07 = fread(fid,1,'float');
    unknown08 = fread(fid,1,'float');
    unknown09 = fread(fid,1,'float');
    unknown10 = fread(fid,1,'float');
    height = fread(fid,1,'int32');
    width = fread(fid,1,'int32');
    unknown11 = fread(fid,1,'int32');
    unknown12 = fread(fid,1,'int32');

    % unknown05 and 06, if floats, could be image size in micron. 
    % If int, could be position of map in stage coordinates
end

%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
function [creationTimeStr,creationTime] = readCreationTime(fid)
    position = ftell(fid);
    status = fseek(fid,0,'bof');
    if (status == -1) 
        message = ferror(fid,'clear'); 
        error(message); 
    end

    fileAsStr = fread(fid,inf,'*char')';

    [start_idx] = regexp(fileAsStr,'CreationTime');
    start_idx = start_idx + 20; % move to start of date string
    end_idx = start_idx + 18; % determine end of date string
    fileAsStr = fileAsStr(start_idx:end_idx);

    expr = '(\d\d)/(\d\d)/(\d\d\d\d) (\d\d):(\d\d):(\d\d)';
    [start_idx,end_idx,extents,matches,tokens,names,splits] = regexp(fileAsStr,expr);
    
    creationTimeStr = '';
    creationTime = 0;
    if ~isempty(tokens)
        day = str2double(tokens{1,1}{1});
        month = str2double(tokens{1,1}{2});
        year = str2double(tokens{1,1}{3});
        hours = str2double(tokens{1,1}{4});
        minutes = str2double(tokens{1,1}{5});
        seconds = str2double(tokens{1,1}{6});

        creationTime = datenum(year,month,day,hours,minutes,seconds);
        creationTimeStr = datestr(creationTime);
    end
    
    % Go back where we were
    status = fseek(fid, position, 'bof');
end

%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
function plotImageData(data,filename)
    window_title = filename;
    figure('Name',window_title,'NumberTitle','off');
    imagesc(sum(data,3));
    axis image; 
    axis off;
    [pathstr, name, ext] = fileparts(filename); 
    title(name,'interpreter','none');
end

%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
function plotSpectralData(ramanshift,data,x_label,y_label,filename)
    window_title = filename;
    figure('Name',window_title,'NumberTitle','off');
    plot(ramanshift,data);
    utilities.tightxaxis;
    xlabel(x_label);
    ylabel(y_label);
    [pathstr, name, ext] = fileparts(filename); 
    title(name,'interpreter','none');
end

%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
function filename = getfilename(filter,filtername)

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
                '*.*',  'All Files (*.*)'};

% example...            
%filetypes = {   '*.mat',  'MAT Files (*.mat)'; ...
%                '*.*',    'All Files (*.*)'};

setappdata(0,'UseNativeSystemDialogs',false);

[filenames,pathname] = uigetfile(filetypes,'Select file...','MultiSelect','off');

if (isfloat(filenames) && (filenames == 0))
    disp('Error: No filename selected');
    filename = 0;
    return;
end

if iscell(filenames)
    % change from a row of filenames to a column of filenames
    % if only one file is selected we have a single string (not a cell
    % array)
    filenames = filenames';
else
    % convert the filename to a cell array (with one entry)
    filenames = cellstr(filenames);
end

for i = 1:size(filenames,1)
    filenames{i,1} = [pathname,filenames{i,1}];
end

filename = filenames;

end
%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

% Some information...

% blockName : blockSize
% WDF1 : 512
% DATA : 2425504
% XLST : 4080
% YLST : 28
% WXDA : 4426
% WXCS : 7475
% WXIS : 3189
% ORGN : 24060
% WXDM : 108244
% TEXT : 109
% WHTL : 62956
% WMAP : 64
% WXDB : 4800
% MAP  : 2591
% ZLDC : 325
% WCHK : 388

    % WHTL is an embedded JPEG
