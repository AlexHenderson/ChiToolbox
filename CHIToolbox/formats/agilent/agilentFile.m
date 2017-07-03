function [wavenumbers, data, height, width, filename, acqdate] = agilentFile(filename)

%   Function: agilentFile
%   Usage: [wavenumbers, data, height, width, filename, acqdate] = agilentFile();
%   Usage: [wavenumbers, data, height, width, filename, acqdate] = agilentFile(filename);
%
%   Extracts the spectra from either an Agilent single tile FPA image, or a
%   mosaic of tiles.
%
%   input:
%   'filename' string containing the full path to either a .seq file (for a
%       single tile) or a .dms file (mosaic) (optional)
% 
%   output:
%   'wavenumbers' is a list of the wavenumbers related to the data
%   'data' is a 3D cube of the data in the file (height x width x wavenumbers)
%   'height' is the height of the image in pixels (columns)
%   'width' is the width of the image in pixels (rows)
%   'filename' is a string containing the full path to the opened file
%   'acqdate' is a string containing the date and time of acquisition
%
%                     *******Caution******* 
%   This code is a hack of the Agilent format and the location of the data
%   within the file may vary. Always check the output to make sure it is
%   sensible. If you have a file that doesn't work, please contact Alex. 
%
%   Copyright (c) 2017, Alex Henderson 
%   Contact email: alex.henderson@manchester.ac.uk
%   Licenced under the GNU General Public License (GPL) version 3
%   http://www.gnu.org/copyleft/gpl.html
%   Other licensing options are available, please contact Alex for details
%   If you use this file in your work, please acknowledge the author(s) in
%   your publications. 
%
%   version 1.2, June 2017

%       version 1.2, June 2017 Alex Henderson. Changed order of height and
%       width outputs
%       version 1.1, June 2017 Alex Henderson. Removed automatic plotting
%       feature. 
%       version 1.0, June 2017 Alex Henderson. 


if (~exist('filename', 'var'))
    filename = getfilename(vertcat(...
            {'*.dms;*.seq',  'Agilent Readable Files (*.dms,*.seq)'}, ...
            {'*.dms',  'Agilent Image Mosaic Files (*.dms)'}, ...
            {'*.seq',  'Agilent Image Single Tile Files (*.seq)'}));

    if (isfloat(filename) && (filename == 0))
        return;
    end
    
    filename = filename{1};
end

[pathstr,name,ext] = fileparts(filename); %#ok<ASGLU>

switch(ext)
    case {'.dms', '.dmt'}
        [wavenumbers, data, height, width, filename, acqdate] = agilentMosaic(filename);
    case {'.seq', '.bsp'}
        [wavenumbers, data, height, width, filename, acqdate] = agilentImage(filename);
    otherwise
        error(['problem reading Agilent file: ', filename]);
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
