function obj = rot90(varargin)

% rot90  Rotates the data anticlockwise.
%
% Syntax
%   rot90();
%   rot90(k);
%   obj = rot90(____);
%
% Description
%   rot90() rotates the data by 90 degrees anticlockwise.
% 
%   rot90(k) rotates the data by k*90 degrees anticlockwise.
% 
%   obj = rot90(____) clones the object and rotates the clone. The original
%   object is not modified.
%
% Copyright (c) 2019, Alex Henderson.
% Licenced under the GNU General Public License (GPL) version 3.
%
% See also 
%   rot90.

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
    command = [mfilename, '(obj,varargin{2:end});']; 
    eval(command);  
else
    k = 1;
    if (nargin > 1)
        k = varargin{2};
    end
    
    this.data = reshape(this.data,this.ypixels,this.xpixels,[]);
    this.data = rot90(this.data,k);
    [this.ypixels,this.xpixels,dummy] = size(this.data); %#ok<ASGLU>
    this.data = reshape(this.data,this.ypixels*this.xpixels,[]);
end

end % function
