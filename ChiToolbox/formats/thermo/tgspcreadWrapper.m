function [xvals,data,height,width,filename,acqdate,x_label,y_label] = tgspcreadWrapper(filename,plotContents)
%   Function: tgspcreadWrapper Wrapper for MATLAB's tgspcread .spc reading function
%   Usage: [xvals,data,height,width,filename,acqdate,x_label,y_label] = tgspcreadWrapper();
%   Usage: [xvals,data,height,width,filename,acqdate,x_label,y_label] = tgspcreadWrapper(filename);
%   Usage: [xvals,data,height,width,filename,acqdate,x_label,y_label] = tgspcreadWrapper(filename,plotContents);
%
%   Extracts the data from a Thermo Scientific GRAMS .spc file.
%   Optionally plots the contents of the file as either a single spectrum,
%   a series of spectra overlaid, or an image or spectrum of the total
%   signal.
%
%   input:
%   'filename' string containing the full path to the .spc file (optional)
%   'plotContents' 1 or 0 where 1 means plot the contents and 0 (default)
%       means do not (optional). Only used when a filename is provided. 
% 
%   output:
%   'xvals' is a list of the wavenumbers related to the data
%   'data' is a 3D hypercube of the data in the file (height x width x wavenumbers)
%   'filename' is a string containing the full path to the .spc file
%   'acqdate' is a string containing the date and time of acquisition
%   'x_label' is the name of the unit on the x axis (wavenumber)
%   'y_label' is the name of the unit on the y axis (intensity)
%
%   Copyright (c) 2017-2023, Alex Henderson 
%   Contact email: alex.henderson@manchester.ac.uk
%   Licenced under the GNU General Public License (GPL) version 3
%   http://www.gnu.org/copyleft/gpl.html
%   Other licensing options are available, please contact Alex for details
%   If you use this file in your work, please acknowledge the author(s) in
%   your publications. 
%
%   version 1.0 June 2017, Alex Henderson
%   The latest version of this file is available at:
%   https://bitbucket.org/AlexHenderson/renishaw-file-formats

%   version 1.0 June 2017, Alex Henderson
%       Initial release.


%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
% Check we can do this...
if ~exist('tgspcread.m','file')
    err = MException('CHI:tgspcreadWrapper:IOError', ...
        'Cannot find tgspcread function');
    throw(err);
end

%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
% Get the filename if not supplied
if ~exist('filename', 'var')
    filename = getfilename('*.spc', 'Thermo Scientific GRAMS Files (*.spc)');
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
    SPCStruct = tgspcread(filename,'VERBOSE',false);

    if iscell(SPCStruct.Y)
        % Multiple spectra
        err = MException('CHI:tgspcreadWrapper:IOError', ...
            'Cannot handle multiple spectra files at the moment');
        throw(err);
    else
        xvals = double(SPCStruct.X);
        data = double(SPCStruct.Y);
        height = 1;
        width = 1;
        acqdate = [];
        x_label = SPCStruct.Header.XLabel;
        y_label = SPCStruct.Header.YLabel;

        if strcmp(x_label, 'Wavenumber (cm-1)')
            x_label = 'wavenumber (cm^{-1})';
        end

        if strcmp(y_label, 'Transmission (ALL HIGHER MUST HAVE VALLEYS!)')
            y_label = 'transmittance (%)';
        end
        if strcmp(y_label, 'Absorbance)')
            y_label = 'absorbance';
        end
    end
            
    if ((height == 1) && (width == 1))
        % We have one or more spectra rather than an image
        data = squeeze(data);
        if iscolumn(data)
            data = data';
        end
        
        % Check to see if we have a single spectrum or a profile
        if (length(data) ~= length(xvals))
            data = reshape(data,[],length(xvals));
        end               
        
        if plotContents
            plotSpectralData(xvals,data,x_label,y_label,filename);
        end
    else
        if plotContents
            plotImageData(data,filename);
        end
    end
    
catch exception
    switch exception.identifier
        case 'MATLAB:license:checkouterror'
            rethrow(exception)
        otherwise
            error(exception.message);
    end
end

end

%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
function plotImageData(data,filename)
    window_title = filename;
    figure('Name',window_title,'NumberTitle','off');
    imagesc(sum(data,3));
    axis image; 
    axis off;
    [pathstr, name, ext] = fileparts(filename);  %#ok<ASGLU>
    title(name,'interpreter','none');
end

%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
function plotSpectralData(xvals,data,x_label,y_label,filename)
    window_title = filename;
    figure('Name',window_title,'NumberTitle','off');
    utilities.plotformatted(xvals,data);
    utilities.tightxaxis;
    xlabel(x_label);
    ylabel(y_label);
    [pathstr, name, ext] = fileparts(filename);  %#ok<ASGLU>
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
