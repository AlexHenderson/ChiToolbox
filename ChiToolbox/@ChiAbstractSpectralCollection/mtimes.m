function obj = mtimes(varargin)

% mtimes  Multiplies the data by a scalar value.
%
% Syntax
%   mtimes(val);
%   obj = mtimes(val);
%
% Description
%   mtimes(val) multiplies the data by val.
% 
%   obj = mtimes(val) clones the object before multiplying the data by val. 
% 
% Notes
%   Performs element-wise division of the data by the scalar value. 
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
        'Multiplication factor missing.');
    throw(err);
end

if ~isnumeric(varargin{2})
    err = MException(['CHI:', mfilename, ':InputError'], ...
        'Multiplication factor must be a numeric scalar value.');
    throw(err);
end

if ~isscalar(varargin{2})
    err = MException(['CHI:', mfilename, ':InputError'], ...
        'Multiplication factor must be a scalar value.');
    throw(err);
end

this = varargin{1};
val = varargin{2};

if nargout
    obj = this.clone();
    command = [mfilename, '(obj,varargin{2:end});'];
    eval(command);  
else
    this.data = this.data .* val;
    message = ['Multiplied data by ', num2str(val)];
    this.history.add(message);
end

end
