function varargout = removediamond(this,varargin)

% removediamond  Removes the diamond absorption region from the spectrum. 
%
% Syntax
%   removediamond();
%   modified = removediamond();
%
% Description
%   removediamond() removes the diamond region of the spectrum delimited by
%   1830 and 2750 wavenumbers. This version modifies the original object.
%
%   modified = removediamond() first creates a clone of the object, then
%   removes the diamond region of the spectrum from the clone. The original
%   object is not modified.
% 
% Notes
%   Spectal features due to diamond can occur in ATR-IR analysis using a
%   diamond crystal. See http://beta.lexusindia.in/gb-ada.html 
%   The spectral region removed here assumes the features to be relatively
%   weak. The actual absorption range is 1332 to 4000 cm-1. 
% 
% Copyright (c) 2017, Alex Henderson.
% Licenced under the GNU General Public License (GPL) version 3.
%
% See also 
%   removeco removewax removerange ChiSpectrum.

% Contact email: alex.henderson@manchester.ac.uk
% Licenced under the GNU General Public License (GPL) version 3
% http://www.gnu.org/copyleft/gpl.html
% Other licensing options are available, please contact Alex for details
% If you use this file in your work, please acknowledge the author(s) in
% your publications. 

% Version 1.0, September 2018
% The latest version of this file is available on Bitbucket
% https://bitbucket.org/AlexHenderson/chitoolbox


if nargout
    varargout{:} = removerange(this,1830,2750);
else
    removerange(this,1830,2750);
end

end % function removediamond
