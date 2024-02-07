function output = escapestring(input)

% escapestring  Replaces single slash (\) with double slash (\\)
% 
% Syntax
%   output = escapestring(input) replaces all occurrences of a single
%   backslash in input with a double backslash. 
%   
% Copyright (c) 2019, Alex Henderson.
% Licenced under the GNU General Public License (GPL) version 3.

% Contact email: alex.henderson@manchester.ac.uk
% Licenced under the GNU General Public License (GPL) version 3
% http://www.gnu.org/copyleft/gpl.html
% Other licensing options are available, please contact Alex for details
% If you use this file in your work, please acknowledge the author(s) in
% your publications. 

% Version 1.0, February 2019
% The latest version of this file is available at:
% https://github.com/AlexHenderson/ChiToolbox


    output = strrep(input,'\','\\');

end
