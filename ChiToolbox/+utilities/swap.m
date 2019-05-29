function [a,b] = swap(a,b)

% swap  Swaps two values.
%
% Syntax
%   [a,b] = swap(a,b);
%   vec = swap(vec);
%
% Description
%   [a,b] = swap(a,b) swaps a and b.
% 
%   vec = swap(vec) swaps the first and second elements of vec. vec is a
%   two element vector.
%
% Copyright (c) 2014-2019, Alex Henderson.
% Licenced under the GNU General Public License (GPL) version 3.
%
% See also 
%   forceincreasing forcedecreasing force2col force2row.

% Contact email: alex.henderson@manchester.ac.uk
% Licenced under the GNU General Public License (GPL) version 3
% http://www.gnu.org/copyleft/gpl.html
% Other licensing options are available, please contact Alex for details
% If you use this file in your work, please acknowledge the author(s) in
% your publications. 

% The latest version of this file is available on Bitbucket
% https://bitbucket.org/AlexHenderson/chitoolbox

%   For a trick with integers see here:
%   http://blogs.mathworks.com/loren/2006/10/25/cute-tricks-in-matlab-adapted-from-other-languages/#3


    if isvector(a) && ~isscalar(a) && (length(a) ~= 2)
        err = MException(['CHI:',mfilename,':IOError'], ...
            'Can only work with pairs of scalars, or a 2-element vector.');
        throw(err);
    end
        
    if (length(a) == 2)
        [a(1),a(2)] = utilities.swap(a(1),a(2));
    end

    if ~exist('b','var')
        return;
    end
    
    temp = a;
    a = b;
    b = temp;

end
