function [a,b] = forcedecreasing(a,b)
    
% forcedecreasing  Arranges two numbers into descending order.
%
% Syntax
%   [a,b] = forcedecreasing(a,b);
%   vec = forcedecreasing(vec);
%
% Description
%   [a,b] = forcedecreasing(a,b) ensures a is greater than b.
% 
%   vec = forcedecreasing(vec) ensures the first element of vec is greater
%   than the second element. vec is a two element vector.
%
% Copyright (c) 2014-2019, Alex Henderson.
% Licenced under the GNU General Public License (GPL) version 3.
%
% See also 
%   forceincreasing swap.

% Contact email: alex.henderson@manchester.ac.uk
% Licenced under the GNU General Public License (GPL) version 3
% http://www.gnu.org/copyleft/gpl.html
% Other licensing options are available, please contact Alex for details
% If you use this file in your work, please acknowledge the author(s) in
% your publications. 

% The latest version of this file is available on Bitbucket
% https://bitbucket.org/AlexHenderson/chitoolbox


    if isvector(a) && ~isscalar(a) && (length(a) ~= 2)
        err = MException(['CHI:',mfilename,':IOError'], ...
            'Can only work with pairs of scalars, or a 2-element vector.');
        throw(err);
    end
    
    if (length(a) == 2)
        [a(1),a(2)] = utilities.forcedecreasing(a(1),a(2));
    end

    if ~exist('b','var')
        return;
    end

    if (a < b)
        [a,b] = utilities.swap(a,b);
    end

end
