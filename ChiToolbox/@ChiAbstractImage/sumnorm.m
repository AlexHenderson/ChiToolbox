function obj = sumnorm(varargin)

% sumnorm  Sum normalisation of the data. 
%
% Syntax
%   sumnorm();
%   normalised = sumnorm();
%
% Description
%   sumnorm() modifies the data such that the sum of the each spectrum is
%   unity (1). This version modifies the original object.
%
%   normalised = sumnorm() first creates a clone of the object, then
%   performs the normalisation of the clone. The original object is not
%   modified.
%
% Copyright (c) 2017, Alex Henderson.
% Licenced under the GNU General Public License (GPL) version 3.
%
% See also 
%   vectornorm, featurenorm

% Contact email: alex.henderson@manchester.ac.uk
% Licenced under the GNU General Public License (GPL) version 3
% http://www.gnu.org/copyleft/gpl.html
% Other licensing options are available, please contact Alex for details
% If you use this file in your work, please acknowledge the author(s) in
% your publications. 

% Version 1.0, September 2018
% The latest version of this file is available at:
% https://github.com/AlexHenderson/ChiToolbox


this = varargin{1};

if nargout
    obj = this.clone();
    % Not a great approach, but quite generic. 
    % Prevents errors if the function name changes. 
    command = [mfilename, '(obj,varargin{2:end});'];
    eval(command);  
else
    % We are expecting to modify this object in situ
    
    this.data = utilities.sumnorm(this.data);
    this.history.add('sum normalised');
end

end
