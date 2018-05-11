function filename = savefilename(filter, filtername)

%   Function: savefilename
%   Usage: [filename] = savefilename(filter, filtername);
%
%   Collects a single filename from the user.
%   For multiple filenames use savefilenames.m
%
%   'filter' and 'filtername' are strings of the form...
%       filter = '*.mat'
%       filtername = 'MAT Files (*.mat)'
%   'filename' is a char array containing the name of the file including
%   the path
%
%   version 1 (c) May 2018, Alex Henderson

%   version 1 (c) May 2018, Alex Henderson
%

if iscell(filter)
    filetypes = vertcat(filter, ...
                {'*.*',  'All Files (*.*)'});
else
    filetypes = {filter, filtername; ...
                 '*.*',  'All Files (*.*)'};
end
    
% example...            
%filetypes = {   '*.png',  'PNG Files (*.png)'; ...
%                '*.*',    'All Files (*.*)'};

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
