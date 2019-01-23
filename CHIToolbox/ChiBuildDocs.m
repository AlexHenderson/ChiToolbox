function ChiBuildDocs()

% ChiBuildDocs  Generates html documentation
%
% Syntax
%   ChiBuildDocs();
%
% Description
%   ChiBuildDocs() generates documentation for the ChiToolBox as a
%   collection of webpages.
%   The documentation can be found in the doc subfolder of the ChiToolbox.
%   Open the doc/index.html file in a web browser.
% 
% Notes
%   The steps taken are
%       1. A folder called temp_doc is removed is present
%       2. The current working folder is changed to the root of the
%          ChiToolbox
%       3. Documentation is created in the temp_doc folder
%       4. The current working folder is changed back to the initial folder
%       5. The doc folder is removed if present
%       6. The temp_doc folder is renamed to doc
%
% Copyright (c) 2019, Alex Henderson.
% Licenced under the GNU General Public License (GPL) version 3.
%
% See also 
%   doc help

% Contact email: alex.henderson@manchester.ac.uk
% Licenced under the GNU General Public License (GPL) version 3
% http://www.gnu.org/copyleft/gpl.html
% Other licensing options are available, please contact Alex for details
% If you use this file in your work, please acknowledge the author(s) in
% your publications. 

% The latest version of this file is available on Bitbucket
% https://bitbucket.org/AlexHenderson/chitoolbox


% Determine where we are on the disc
thisfile = mfilename('fullpath');
filepath = fileparts(thisfile);
initialpath = pwd();

try

% Using a collection if paths means the current folder does not get
% included. Therefore just going with m2html default. 
    
% % Get a list of folders to trawl through for help information
% directoryInfo = dir(filepath);
% folders = directoryInfo(arrayfun(@(x) x.isdir == 1, directoryInfo));
% foldernames = {folders.name}';
% 
% % Remove unwanted folders
% foldernames = {foldernames{~(cellfun(@(obj) strcmpi(obj, '.'), foldernames))}}';
% foldernames = {foldernames{~(cellfun(@(obj) strcmpi(obj, '..'), foldernames))}}';
% foldernames = {foldernames{~(cellfun(@(obj) strcmpi(obj, 'external'), foldernames))}}';
% foldernames = {foldernames{~(cellfun(@(obj) strcmpi(obj, 'doc'), foldernames))}}';
% foldernames = {foldernames{~(cellfun(@(obj) strcmpi(obj, 'temp_doc'), foldernames))}}';

% Define some locations
doclocation = fullfile(filepath,'/doc');
tempdoclocation = fullfile(filepath,'/temp_doc');

% If there is a temp_doc folder, remove it
if exist(tempdoclocation, 'dir')
    [status,msg,msgID] = rmdir(tempdoclocation, 's'); %#ok<ASGLU>
    if ~status
        err = MException(['CHI:',mfilename,':RuntimeError'], ...
            'Previous temp_doc folder cannot be deleted. Is a file open?');
        throw(err);
    end
end

% Reassure the user
disp('Patience. This can take a few minutes.');

initialpath = cd(filepath);

% Generate documentation in the temp_doc folder
% m2html('mfiles','.', ...
m2html('mfiles','.', ...
    'htmldir','temp_doc', ...
    'recursive','on', ...
    'template','3frames', ...
    'index','menu', ...
    'globalHypertextLinks','on', ...
    'verbose','off' ...
    );    

cd(initialpath);

% If all goes to plan, delete the current doc folder and rename the
% temp_doc folder to doc. 

% Remove current (now old) doc folder and rename temp_doc to doc
if exist(doclocation, 'dir')
    [status,msg,msgID] = rmdir(doclocation, 's'); %#ok<ASGLU>
    if ~status
        err = MException(['CHI:',mfilename,':RuntimeError'], ...
            'Previous doc folder cannot be deleted. Is a file open?');
        throw(err);
    end
end

if exist(tempdoclocation, 'dir')
    [status,msg,msgID] = movefile(tempdoclocation, doclocation); %#ok<ASGLU>
    if ~status
        err = MException(['CHI:',mfilename,':RuntimeError'], ...
            'Cannot rename temp_doc folder to doc. Is a file open?');
        throw(err);
    end
end

% Inform the user of the documentation's location
disp('Done. Documentation can be found at:');
disp(['<a href = "file:///', filepath, '/doc/index.html">file:///', filepath, '/doc/index.html></a>']);

catch e
   cd(initialpath); 
   rethrow(e);   
end

end
