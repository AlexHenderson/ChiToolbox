function obj = mrdivide(varargin)

% mrdivide  Divides the data by a scalar value. NOT MATRIX DIVISION
%
% Syntax
%   mrdivide(val);
%   obj = mrdivide(val);
%
% Description
%   mrdivide(val) divides the data by val. NOT MATRIX DIVISION
% 
%   obj = mrdivide(val) clones the object before dividing the data by val.
%   NOT MATRIX DIVISION
% 
% Notes
%   Performs element-wise division of the data by the scalar value. NOT
%   MATRIX DIVISION
%
% Copyright (c) 2019, Alex Henderson.
% Licenced under the GNU General Public License (GPL) version 3.
%
% See also 
%   plus minus times divideby negate sqrt cubert quadrt nthroot power

% Contact email: alex.henderson@manchester.ac.uk
% Licenced under the GNU General Public License (GPL) version 3
% http://www.gnu.org/copyleft/gpl.html
% Other licensing options are available, please contact Alex for details
% If you use this file in your work, please acknowledge the author(s) in
% your publications. 

% The latest version of this file is available on Bitbucket
% https://bitbucket.org/AlexHenderson/chitoolbox


if (nargin ~= 2)
    err = MException(['CHI:', mfilename, ':InputError'], ...
        'Division factor missing.');
    throw(err);
end

if ~isnumeric(varargin{2})
    err = MException(['CHI:', mfilename, ':InputError'], ...
        'Division factor must be a numeric scalar value.');
    throw(err);
end

if ~isscalar(varargin{2})
    err = MException(['CHI:', mfilename, ':InputError'], ...
        'Division factor must be a scalar value.');
    throw(err);
end

this = varargin{1};
val = varargin{2};

if nargout
    obj = this.clone();
    command = [mfilename, '(obj,varargin{2:end});'];
    eval(command);  
else
    this.data = this.data ./ val;
    message = ['Divided data ', num2str(val)];
    this.history.add(message);
end

end
