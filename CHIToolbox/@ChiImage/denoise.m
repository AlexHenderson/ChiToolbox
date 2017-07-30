function varargout = denoise(this,varargin)

% denoise  Principal components noise reduction. 
%
% Syntax
%   denoise();
%   denoise(pcs);
%   denoised = denoise(____);
%
% Description
%   denoise() uses principal components analysis to reduce the noise level
%   in the spectra. One third of the principal components are retained by
%   default. This version modifies the original object.
%
%   denoise(pcs) retains pcs principal components. This version modifies
%   the original object.
%
%   denoised = denoise(____) first creates a clone of the object, then
%   performs one of the denoise functions on the clone. The original object
%   is not modified.
%
% Copyright (c) 2017, Alex Henderson.
% Licenced under the GNU General Public License (GPL) version 3.
%
% See also 
%   ChiImage.

% Contact email: alex.henderson@manchester.ac.uk
% Licenced under the GNU General Public License (GPL) version 3
% http://www.gnu.org/copyleft/gpl.html
% Other licensing options are available, please contact Alex for details
% If you use this file in your work, please acknowledge the author(s) in
% your publications. 

% Version 1.0, July 2017
% The latest version of this file is available on Bitbucket
% https://bitbucket.org/AlexHenderson/chitoolbox


if (nargout > 0)
    % We are expecting to generate a modified clone of this object
    varargout{1} = clone(this);
    [varargout{1}.data,pcs] = utilities.pcnoisereduction(varargout{1}.data,varargin{:});
    varargout{1}.history.add(['noise reduction using ', num2str(pcs), ' pcs']);    
else
    % We are expecting to modified this object in situ
    [this.data,pcs] = utilities.pcnoisereduction(this.data,varargin{:});
    this.history.add(['noise reduction using ', num2str(pcs), ' pcs']);
end

end
