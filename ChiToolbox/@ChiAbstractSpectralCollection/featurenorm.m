function obj = featurenorm(varargin)

% featurenorm  Normalise to a spectral feature
% 
% Syntax
%   featurenorm();
%   featurenorm(featureHigh);
%   featurenorm(featureHigh,featureLow);
%   featurenorm(____,highMethod);
%   featurenorm(____,highMethod,lowMethod);
%   normalised = featurenorm(____);
%
% Description
%   featurenorm() scales each spectrum so that the maximum of each spectrum
%   becomes 1 and the minimum of each spectrum becomes 0. The values
%   between are scaled linearly.
%
%   featurenorm(featureHigh) uses the scalar value, or two element vector
%   featureHigh to determine the maximum value. highMethod is set to 'max',
%   therefore the maximum value in the spectral range determined by
%   featureHigh is normalised to 1. The minimum of each spectrum is set to
%   0. The values between are scaled linearly.
%
%   featurenorm(featureHigh,featureLow) uses the scalar value, or two
%   element vector, featureLow to determine the minimum value. lowMethod is
%   set to 'median', therefore the maximum value in the spectral range
%   determined by featureHigh is normalised to 1. The minimum of each
%   spectrum is set to the median of the fetureLow range. The values
%   between are scaled linearly.
% 
%   featurenorm(____,highMethod) uses highMethod to determine the method of
%   determining the high point in the spectra. highMethod can be 'max',
%   'median' or 'min'. Therefore if featureHigh is a range of xvalues the
%   max, median or min value in this range (for each spectrum) is set to 1.
%   The minimum of each spectrum, or spectral range in featureLow, is set
%   to 0. The values between are scaled linearly.
%
%   featurenorm(____,highMethod,lowMethod) uses lowMethod to determine the
%   method of determining the low point in the spectra. lowMethod can be
%   'max', 'median' or 'min'. Therefore if featureLow is a range of xvalues
%   the max, median or min value in this range (for each spectrum) is set
%   to 0. The maximum of each spectrum, or spectral range in featureHigh,
%   is set to 1 using the appropriate highMethod. The values between are
%   scaled linearly.
% 
%   normalised = featurenorm(____) first creates a clone of the object,
%   then performs the normalisation of the clone. The original object is
%   not modified.
% 
% Notes
%   If neither featureHigh nor featureLow are provided, the spectra are
%   scaled such that the absolute maximum becomes 1 and the absolute
%   minimum becomes 0.
%   If no highMethod is provided, the maximum of the featureHigh range is
%   used.
%   If no lowMethod or featureLow are provided, the spectral minumum is
%   used. However, if a featureLow is provided, the median of that range is
%   used.
%   The reasoning behind the default selection of max for the featureHigh
%   and median for the featureLow is that we often wish to find the maximum
%   intensity of a peak in a spectrum. however the minimum is often a noise
%   region where the median intensity of a spectral range is more
%   appropriate.
% 
% Copyright (c) 2015-2019, Alex Henderson.
% Licenced under the GNU General Public License (GPL) version 3.
%
% See also 
%   max, median, min, vectornorm, sumnorm

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
    
    this.data = utilities.featurenorm(this,varargin{2:end});
    this.history.add('feature normalised');
end

end
