function obj = removeco(varargin)

% removeco  Removes the CO region from the spectra (2250-2450 cm^{-1}). 
%
% Syntax
%   removeco();
%   modified = removeco();
%
% Description
%   removeco() removes the CO region of the spectra delimited 2250 and 2450
%   wavenumbers. This version modifies the original object.
%
%   modified = removeco() first creates a clone of the object, then removes
%   the CO region of the spectra from the clone. The original object is not
%   modified.
%
% Copyright (c) 2017-2018, Alex Henderson.
% Licenced under the GNU General Public License (GPL) version 3.
%
% See also 
%   removerange ChiImage.

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
    
    this.removerange(2250,2450);
end

end % function removeco
