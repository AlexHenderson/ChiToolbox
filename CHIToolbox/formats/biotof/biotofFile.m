function [mass, data, height, width, filenames] = biotofFile(filenames)

%   Function: biotofFile
%   Usage: [mass, data, height, width, filenames] = biotofFile();
%   Usage: [mass, data, height, width, filenames] = biotofFile(filenames);
%
%   Extracts the data from a Biotof image or collection of spectral files.
%
%   input:
%   'filename' string containing the full path to either a .xyt file (for
%   an image) or a .dat file (spectrum) (optional)
% 
%   output:
%   'mass' is a list of the m/z values related to the data
%   'data' is a 3D cube of the data in the file (height x width x mass)
%   'height' is the height of the image in pixels (columns) or 1 for
%       spectra
%   'width' is the width of the image in pixels (rows) or 1 for spectra
%   'filename' is a string containing the full path to the opened file
%   'acqdate' is a string containing the date and time of acquisition
%
%   Copyright (c) 2018, Alex Henderson 
%   Contact email: alex.henderson@manchester.ac.uk
%   Licenced under the GNU General Public License (GPL) version 3
%   http://www.gnu.org/copyleft/gpl.html
%   Other licensing options are available, please contact Alex for details
%   If you use this file in your work, please acknowledge the author(s) in
%   your publications. 
%
%   version 1.0, February 2018

%       version 1.0, February 2018 Alex Henderson. 


if (~exist('filenames', 'var'))
    filenames = getfilename(vertcat(...
            {'*.dat;*.xyt',  'Biotof Readable Files (*.dat,*.xyt)'}, ...
            {'*.dat',  'Biotof Spectral Files (*.dat)'}, ...
            {'*.xyt',  'Biotof Image Files (*.xyt)'}));

    if (isfloat(filenames) && (filenames == 0))
        return;
    end
    
end

% if iscell(filenames)
%     filename = filenames{1};
% else
%     filename = filenames;
% end
[pathstr,name,ext] = fileparts(filenames{1}); %#ok<ASGLU>

switch lower(ext)
    case '.xyt'
        [data, mass] = xyt(filenames{1}); 
        height = 256;
        width = 256;
    case '.dat'
        [mass,data] = biotofspectra(filenames);
        height = 1;
        width = 1;
    otherwise
        error(['problem reading Biotof file: ', filenames{1}]);
end
        
end % function biotofFile

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

[filenames, pathname] = uigetfile(filetypes, 'Select file...', 'MultiSelect', 'on');

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
