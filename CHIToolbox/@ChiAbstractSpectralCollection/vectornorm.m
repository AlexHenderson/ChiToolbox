function obj = vectornorm(varargin)

% vectornorm  Vector normalisation of the data. 
%
% Syntax
%   vectornorm();
%   normalised = vectornorm();
%
% Description
%   vectornorm() expresses each spectrum as a unit length vector. This
%   version modifies the original object.
%
%   normalised = vectornorm() first creates a clone of the object, then
%   performs the normalisation of the clone. The original object is not
%   modified.
%
% Copyright (c) 2017, Alex Henderson.
% Licenced under the GNU General Public License (GPL) version 3.
%
% See also 
%   sumnorm.

% Contact email: alex.henderson@manchester.ac.uk
% Licenced under the GNU General Public License (GPL) version 3
% http://www.gnu.org/copyleft/gpl.html
% Other licensing options are available, please contact Alex for details
% If you use this file in your work, please acknowledge the author(s) in
% your publications. 

% Version 1.1, September 2018
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
    
    this.data = utilities.vectornorm(this.data);
    this.history.add('vector normalised');
end

end
