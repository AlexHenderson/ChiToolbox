function output = asvector(this)

% asvector  The mask as a column vector.
%
% Syntax
%   output = asvector();
%
% Description
%   output = asvector() returns the mask as a column vector.
% 
% Copyright (c) 2019, Alex Henderson.
% Licenced under the GNU General Public License (GPL) version 3.
%
% See also 
%   asimage ashypercube.

% Contact email: alex.henderson@manchester.ac.uk
% Licenced under the GNU General Public License (GPL) version 3
% http://www.gnu.org/copyleft/gpl.html
% Other licensing options are available, please contact Alex for details
% If you use this file in your work, please acknowledge the author(s) in
% your publications. 

% The latest version of this file is available on Bitbucket
% https://bitbucket.org/AlexHenderson/chitoolbox


% We can always supply the mask as a vector

    output = this.mask;
    
end
