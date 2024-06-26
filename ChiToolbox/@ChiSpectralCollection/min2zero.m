function obj = min2zero(varargin)
    
% min2zero  Shift the data such that the minimum becomes zero
% 
% Syntax
%   min2zero();
%   obj = min2zero();
%
% Description
%   min2zero() shift the data in intensity such that the minimum becomes
%   zero.
% 
%   obj = min2zero() clones the object before shifting the minimum of the
%   clone.
% 
% Copyright (c) 2019, Alex Henderson.
% Licenced under the GNU General Public License (GPL) version 3.
%
% See also 
%   max, median, min, plus, minus, vectornorm, sumnorm, featurenorm

% Contact email: alex.henderson@manchester.ac.uk
% Licenced under the GNU General Public License (GPL) version 3
% http://www.gnu.org/copyleft/gpl.html
% Other licensing options are available, please contact Alex for details
% If you use this file in your work, please acknowledge the author(s) in
% your publications. 

% The latest version of this file is available at:
% https://github.com/AlexHenderson/ChiToolbox


this = varargin{1};

if nargout
    obj = this.clone();
    command = [mfilename, '(obj,varargin{2:end});'];
    eval(command);  
else
    this.data = utilities.min2zero(this.data);
    message = 'Minimum set to zero in each spectrum';
    this.history.add(message);
end

end % function
