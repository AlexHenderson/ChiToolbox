function ChiDocs()

% ChiDocs  Opens the html documentation
%
% Syntax
%   ChiDocs();
%
% Description
%   ChiDocs() opens the documentation for the ChiToolBox in a web browser.
%   The documentation can be found in the doc subfolder of the ChiToolbox.
%   Open the doc/index.html file in a web browser.
% 
% Copyright (c) 2019, Alex Henderson.
% Licenced under the GNU General Public License (GPL) version 3.
%
% See also 
%   ChiBuildDocs doc help

% Contact email: alex.henderson@manchester.ac.uk
% Licenced under the GNU General Public License (GPL) version 3
% http://www.gnu.org/copyleft/gpl.html
% Other licensing options are available, please contact Alex for details
% If you use this file in your work, please acknowledge the author(s) in
% your publications. 

% The latest version of this file is available at:
% https://github.com/AlexHenderson/ChiToolbox


% Determine where we are on the disc
thisfile = mfilename('fullpath');
filepath = fileparts(thisfile);
docindexlocation = fullfile(filepath,'doc','index.html');

if ~exist(docindexlocation, 'file')
    err = MException(['CHI:',mfilename,':RuntimeError'], ...
        'Cannot find the documentation. Try running ChiBuildDocs.');
    throw(err);
end    

% Open the documentation in the MATLAB web browser
web(['file:///', filepath, '/doc/index.html']);

end
