function filenames = getfilenames(filter, filtername)

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

[filenames, pathname] = uigetfile(filetypes, 'Select file(s)...', 'MultiSelect', 'on');

if (isfloat(filenames) && (filenames == 0))
    err = MException(['CHI:',mfilename,':IOError'], ...
        'No filename(s) selected.');
    throw(err);
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

end % function getfilename
%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
