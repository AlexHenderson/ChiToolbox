function obj = power(varargin)

% topower  Raises the data to the given power
%
% Syntax
%   power(level);
%   obj = power(level);
%
% Description
%   power(level) raises the data to the given power. 
% 
%   obj = power(level) clones the object before raising the power. 
%
% Copyright (c) 2018, Alex Henderson.
% Licenced under the GNU General Public License (GPL) version 3.
%
% See also 
%   power.

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
    % Not a great approach, but quite generic. 
    % Prevents errors if the function name changes. 
    command = [mfilename, '(obj,varargin{2:end});'];
    eval(command);  
else
    % We are expecting to modify this object in situ
    
    level = varargin{2};
    this.data = power(this.data,level);
    message = ['Raise to power ', num2str(level)];
    this.history.add(message);
end

end
