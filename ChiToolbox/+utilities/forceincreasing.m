function [a,b] = forceincreasing(a,b)
    
% forceincreasing  Arranges two numbers into ascending order.
%
% Syntax
%   [a,b] = forceincreasing(a,b);
%   vec = forceincreasing(vec);
%
% Description
%   [a,b] = forceincreasing(a,b) ensures b is greater than a.
% 
%   vec = forceincreasing(vec) ensures the second element of vec is greater
%   than the first element. vec is a two element vector.
%
% Copyright (c) 2014-2019, Alex Henderson.
% Licenced under the GNU General Public License (GPL) version 3.
%
% See also 
%   forcedecreasing  force2col force2row swap.

% Contact email: alex.henderson@manchester.ac.uk
% Licenced under the GNU General Public License (GPL) version 3
% http://www.gnu.org/copyleft/gpl.html
% Other licensing options are available, please contact Alex for details
% If you use this file in your work, please acknowledge the author(s) in
% your publications. 

% The latest version of this file is available at:
% https://github.com/AlexHenderson/ChiToolbox


    if isvector(a) && ~isscalar(a) && (length(a) ~= 2)
        err = MException(['CHI:',mfilename,':IOError'], ...
            'Can only work with pairs of scalars, or a 2-element vector.');
        throw(err);
    end
    
    if (length(a) == 2)
        [a(1),a(2)] = utilities.forceincreasing(a(1),a(2));
    end

    if ~exist('b','var')
        return;
    end

    if (a > b)
        [a,b] = utilities.swap(a,b);
    end

end
