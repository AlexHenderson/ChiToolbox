function obj = negate(varargin)

% negate  Negates the data.
%
% Syntax
%   negate();
%   obj = negate();
%
% Description
%   negate() negates the data
% 
%   obj = negate() clones the object before negating it. 
%
% Copyright (c) 2019, Alex Henderson.
% Licenced under the GNU General Public License (GPL) version 3.
%
% See also 
%   plus minus times divideby sqrt cubert quadrt nthroot power

% Contact email: alex.henderson@manchester.ac.uk
% Licenced under the GNU General Public License (GPL) version 3
% http://www.gnu.org/copyleft/gpl.html
% Other licensing options are available, please contact Alex for details
% If you use this file in your work, please acknowledge the author(s) in
% your publications. 

% The latest version of this file is available on Bitbucket
% https://bitbucket.org/AlexHenderson/chitoolbox


this = varargin{1};

if nargout
    obj = this.clone();
    obj.data = -obj.data;
    message = 'Negated the data';
    obj.history.add(message);
else
    this.data = -this.data;
    message = 'Negated the data';
    this.history.add(message);
end

end
