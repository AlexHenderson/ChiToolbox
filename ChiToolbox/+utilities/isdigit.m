function result = isdigit(x)

% ISDIGIT Reports whether or not a single char represents a digit
% Version 1.0
%
% Usage: 
%   output = ismatlab(x);
%
% Returns:  'output' True if x is a digit (0-9). False otherwise. 
%
%   Copyright (c) 2024, Alex Henderson 
%   Contact email: alex.henderson@manchester.ac.uk
%   Licenced under the GNU General Public License (GPL) version 3
%   http://www.gnu.org/copyleft/gpl.html
%   Other licensing options are available, please contact Alex for details
%   If you use this file in your work, please acknowledge the author(s) in
%   your publications. 

% Version 1.0  Alex Henderson, June 2024
%   Initial release


if ~ischar(x)
    error('Input must be a single character');
end

result = false;

if (uint8(x) >=  uint8('0')) && (uint8(x) <=  uint8('9'))
    result = true;
end

end % function: isdigit
