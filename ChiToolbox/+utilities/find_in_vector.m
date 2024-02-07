function [idx,closest] = find_in_vector(vector,value)

% find_in_vector  Locates the closest index position of a value in a vector
%
% Syntax
%   [idx,closest] = find_in_vector(vector,value);
%
% Description
%   [idx,closest] = find_in_vector(vector,value) searches through vector
%   for the closest match to value. Return the closest match and its index
%   position, idx. If value is a vector, then both idx and closest will
%   also be vectors of the same length
%
% Example 1
%     vector = [1:10] + 7;
%     value = 10.2;
%     [idx,closest] = utilities.find_in_vector(vector,value)
%     idx =
%          3
%     closest =
%         10
% 
% Example 2
%     vector = [1:10] + 7;
%     value = [10.2, 13.8];
%     [idx,closest] = utilities.find_in_vector(vector,value)
%     idx =
%          3     7
%     closest =
%         10    14
% 
% Copyright (c) 2018, Alex Henderson.
% Licenced under the GNU General Public License (GPL) version 3.
%
% See also 
%   find.

% Contact email: alex.henderson@manchester.ac.uk
% Licenced under the GNU General Public License (GPL) version 3
% http://www.gnu.org/copyleft/gpl.html
% Other licensing options are available, please contact Alex for details
% If you use this file in your work, please acknowledge the author(s) in
% your publications. 

% Version 1.0, April 2018
% The latest version of this file is available at:
% https://github.com/AlexHenderson/ChiToolbox


if (numel(value) > 1)
    idx = zeros(size(value));
    closest = zeros(size(value));
    for i = 1:length(value)
        [unused, idx(i)] = min(abs(vector-value(i))); %#ok<ASGLU>
        closest(i) = vector(idx(i));
    end
else
    [unused,idx] = min(abs(vector-value)); %#ok<ASGLU>
    closest = vector(idx);
end

end
