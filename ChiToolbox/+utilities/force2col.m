function [vec,rotated] = force2col(vec)

% force2col  Ensures a vector is a column vector.
%
% Syntax
%   [vec,rotated] = force2col(vec);
%
% Description
%   [vec,rotated] = force2col(vec) ensures vec is a column vector.
%
% Copyright (c) 2014-2019, Alex Henderson.
% Licenced under the GNU General Public License (GPL) version 3.
%
% See also 
%   force2row forceincreasing forcedecreasing swap.

% Contact email: alex.henderson@manchester.ac.uk
% Licenced under the GNU General Public License (GPL) version 3
% http://www.gnu.org/copyleft/gpl.html
% Other licensing options are available, please contact Alex for details
% If you use this file in your work, please acknowledge the author(s) in
% your publications. 

% The latest version of this file is available on Bitbucket
% https://bitbucket.org/AlexHenderson/chitoolbox


if ~isvector(vec)
    % input is not a vector
    err = MException(['CHI:',mfilename,':WrongDataType'], ...
        'Input is not a vector');
    throw(err);
end

rotated = false;
[rows,cols] = size(vec);

if (cols > rows)
    vec = vec';
    rotated = true;
end

end
