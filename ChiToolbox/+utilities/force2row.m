function vec = force2row(vec)

% force2row  Ensures a vector is a row vector.
%
% Syntax
%   vec = force2row(vec);
%
% Description
%   vec = force2row(vec) ensures vec is a row vector.
%
% Copyright (c) 2014-2019, Alex Henderson.
% Licenced under the GNU General Public License (GPL) version 3.
%
% See also 
%   force2col forceincreasing forcedecreasing swap.

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

[rows,cols] = size(vec);

if (rows > cols)
    vec = vec';
end

end

