function filename = savefilename(filter, filtername)

%   Function: savefilename
%   Usage: filename = savefilename(filter, filtername);
%
%   Collects a single filename from the user.
%
%   'filter' and 'filtername' are strings of the form...
%       filter = '*.mat'
%       filtername = 'MAT Files (*.mat)'
%   'filename' is a char array containing the name of the file including
%   the path

% Example
%     filename = utilities.savefilename(vertcat(...
%             {'*.png',           'PNG Image Files (*.png)'}, ...
%             {'*.jpg;*.jpeg',    'JPEG Image Files (*.jpeg)'}, ...
%             {'*.bmp',           'Bitmap Image Files (*.bmp)'}, ...
%             {'*.tif;*.tiff',    'TIFF Image Files (*.tiff)'} ...
%         ));
%
% Copyright (c) 2018, Alex Henderson.
% Licenced under the GNU General Public License (GPL) version 3.

% Contact email: alex.henderson@manchester.ac.uk
% Licenced under the GNU General Public License (GPL) version 3
% http://www.gnu.org/copyleft/gpl.html
% Other licensing options are available, please contact Alex for details
% If you use this file in your work, please acknowledge the author(s) in
% your publications. 

% The latest version of this file is available at:
% https://github.com/AlexHenderson/ChiToolbox


if iscell(filter)
    filetypes = vertcat(filter, ...
                {'*.*',  'All Files (*.*)'});
else
    filetypes = {filter, filtername; ...
                 '*.*',  'All Files (*.*)'};
end
    
setappdata(0,'UseNativeSystemDialogs',false);

[filename, pathname] = uiputfile(filetypes, 'Select file...');

if (isfloat(filename) && (filename == 0))
    disp('Error: No filename selected');
    filename = 0;
    return;
end

filename = fullfile(pathname,filename);

end % function savefilename
%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
