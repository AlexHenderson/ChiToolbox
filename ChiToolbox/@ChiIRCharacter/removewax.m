function varargout = removewax(this,varargin)

% removewax  Removes the paraffin signature from the spectrum. 
%
% Syntax
%   removewax();
%   modified = removewax();
%
% Description
%   removewax() removes the signature relating to paraffin wax in
%   the spectrum, specifically 1340-1490, 2300-2400 and 2700-3000
%   wavenumbers. This version modifies the original object.
%
%   modified = removewax() first creates a clone of the object, then removes
%   the wax signature from the spectrum from the clone. The original object is not
%   modified.
%
% Copyright (c) 2018, Alex Henderson.
% Licenced under the GNU General Public License (GPL) version 3.
%
% See also 
%   removeco2 removediamond removerange ChiSpectrum.

% Contact email: alex.henderson@manchester.ac.uk
% Licenced under the GNU General Public License (GPL) version 3
% http://www.gnu.org/copyleft/gpl.html
% Other licensing options are available, please contact Alex for details
% If you use this file in your work, please acknowledge the author(s) in
% your publications. 

% Version 1.0, June 2018
% The latest version of this file is available at:
% https://github.com/AlexHenderson/ChiToolbox


if nargout
    varargout{:} = removerange(this,[1340,1490, 2300,2400, 2700,3000]);

else
    removerange(this,[1340,1490, 2300,2400, 2700,3000]);
end

end % function removewax

