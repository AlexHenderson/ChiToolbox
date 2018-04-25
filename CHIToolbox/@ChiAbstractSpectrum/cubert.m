function obj = cubert(varargin)

% cubert  Takes the cube root of the data.
%
% Syntax
%   cubert();
%   obj = cubert();
%
% Description
%   cubert() takes the cube root of the data.
% 
%   obj = cubert() clones the object before taking the cube root. 
%
% Copyright (c) 2018, Alex Henderson.
% Licenced under the GNU General Public License (GPL) version 3.
%
% See also 
%   sqrt quadrt nthroot.

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
    
    level = 3;
    this.data = nthroot(this.data,level);
    message = 'Cube root taken';
    this.history.add(message);
end

end
