function [xvals,data,height,width,filename,acqdate,x_label,y_label] = thermoFile(filename)

%   Function: thermoFile
%   Usage: [xvals,data,height,width,filename,acqdate,x_label,y_label] = thermoFile();
%   Usage: [xvals,data,height,width,filename,acqdate,x_label,y_label] = thermoFile(filename);
%
%   Extracts the spectra from a Thermo Scientific file.
%
%   input:
%   'filename' string containing the full path to either a .spc file (optional)
% 
%   output:
%   'xvals' is a list of the x-axis values related to the data
%   'data' is a 3D cube of the data in the file (height x width x wavenumbers)
%   'width' is the width of the image in pixels (rows)
%   'height' is the height of the image in pixels (columns)
%   'width' is the width of the image in pixels (rows)
%   'filename' is a string containing the full path to the opened file
%   'acqdate' is a string containing the date and time of acquisition
%   'x_label' is the name of the unit on the x axis (eg wavenumber)
%   'y_label' is the name of the unit on the y axis (eg intensity)
%
%   Copyright (c) 2017, Alex Henderson 
%   Contact email: alex.henderson@manchester.ac.uk
%   Licenced under the GNU General Public License (GPL) version 3
%   http://www.gnu.org/copyleft/gpl.html
%   Other licensing options are available, please contact Alex for details
%   If you use this file in your work, please acknowledge the author(s) in
%   your publications. 
%
%   version 1.0, June 2017

%       version 1.0, June 2017 Alex Henderson. 

if (~exist('filename', 'var'))
    filename = getfilename(vertcat(...
            {'*.spc',  'Thermo Scientific GRAMS Files (*.spc)'}));

    if (isfloat(filename) && (filename == 0))
        return;
    end
    
    filename = filename{1};
end

[pathstr,name,ext] = fileparts(filename); %#ok<ASGLU>

switch(lower(ext))
    case {'.spc'}
        [xvals,data,height,width,filename,acqdate,x_label,y_label] = thermoSpc(filename, false);
    otherwise
        error(['problem reading Thermo file: ', filename]);
end

end % function agilentFile

%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
function filename = getfilename(filter, filtername)

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
%   version 2 (c) June 2017, Alex Henderson

%   version 2 (c) June 2017, Alex Henderson
%    Added multiple filter handling
%   version 1 (c) May 2011, Alex Henderson
%

% Mostly based on getfilenames and tweaked to only accept a single filename

if iscell(filter)
    filetypes = vertcat(filter, ...
                {'*.*',  'All Files (*.*)'});
else
    filetypes = {filter, filtername; ...
                 '*.*',  'All Files (*.*)'};
end
    
% example...            
%filetypes = {   '*.mat',  'MAT Files (*.mat)'; ...
%                '*.*',    'All Files (*.*)'};

setappdata(0,'UseNativeSystemDialogs',false);

[filenames, pathname] = uigetfile(filetypes, 'Select file...', 'MultiSelect', 'off');

if (isfloat(filenames) && (filenames == 0))
    disp('Error: No filename selected');
    filename = 0;
    return;
end

if iscell(filenames)
    % Change from a row of filenames to a column of filenames. 
    % If only one file is selected we have a single string (not a cell
    % array)
    filenames = filenames';
else
    % Convert the filename to a cell array (with one entry)
    filenames = cellstr(filenames);
end

for i = 1:size(filenames,1)
    filenames{i,1} = [pathname, filenames{i,1}];
end
filename = filenames;

end % function getfilename
%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
