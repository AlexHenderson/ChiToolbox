function scaled_data = featurenorm(chiobj,varargin)

% featurenorm  Normalise to a spectral feature
% 
% Syntax
%   scaled_data = featurenorm(chiobject);
%   scaled_data = featurenorm(____,featureHigh);
%   scaled_data = featurenorm(____,featureHigh,featureLow);
%   scaled_data = featurenorm(____,highMethod);
%   scaled_data = featurenorm(____,highMethod,lowMethod);
%
% Description
%   scaled_data = featurenorm(chiobject) scales each spectrum in chiobject
%   so that the maximum of each spectrum becomes 1 and the minimum of each
%   spectrum becomes 0. The values between are scaled linearly. 
%
%   scaled_data = featurenorm(____,featureHigh) uses the scalar value, or
%   two element vector, featureHigh to determine the maximum value.
%   highMethod is set to 'max', therefore the maximum value in the spectral
%   range determined by featureHigh is normalised to 1. The minimum of each
%   spectrum is set to 0. The values between are scaled linearly.
%
%   scaled_data = featurenorm(____,featureHigh,featureLow) uses the scalar
%   value, or two element vector, featureLow to determine the minimum
%   value. lowMethod is set to 'median', therefore the maximum value in the
%   spectral range determined by featureHigh is normalised to 1. The
%   minimum of each spectrum is set to the median of the fetureLow range.
%   The values between are scaled linearly.
% 
%   scaled_data = featurenorm(____,highMethod) uses highMethod to determine
%   the method of determining the high point in the spectra. highMethod can
%   be 'max', 'median' or 'min'. Therefore if featureHigh is a range of
%   xvalues the max, median or min value in this range (for each spectrum)
%   is set to 1. The minimum of each spectrum, or spectral range in
%   featureLow, is set to 0. The values between are scaled linearly.
%
%   scaled_data = featurenorm(____,highMethod,lowMethod) uses lowMethod to
%   determine the method of determining the low point in the spectra.
%   lowMethod can be 'max', 'median' or 'min'. Therefore if featureLow is a
%   range of xvalues the max, median or min value in this range (for each
%   spectrum) is set to 0. The maximum of each spectrum, or spectral range
%   in featureHigh, is set to 1 using the appropriate highMethod. The
%   values between are scaled linearly.
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

% The latest version of this file is available at:
% https://github.com/AlexHenderson/ChiToolbox


%% Get some initial parameters
numdatapoints = chiobj.numchannels;
data = chiobj.data;

highMethod = 'max';
lowMethod = 'median';

% Check for methods
argposition = find(cellfun(@(x) ischar(x), varargin));
switch length(argposition)
    case 0
        % No methods provided so use defaults
    case 1
        highMethod = varargin{argposition};
        varargin(argposition) = [];
    case 2
        highMethod = varargin{argposition(1)};
        lowMethod = varargin{argposition(2)};
        varargin(argposition(2)) = [];
        varargin(argposition(1)) = [];
    otherwise
        err = MException(['CHI:',mfilename,':IOError'], ...
            'Only highMethod and lowMethod are allowed.');
        throw(err);
end

% Now the strings are removed and we can work on the feature positions
switch length(varargin)
    case 0
        % No spectral regions provided so default to max and min of each
        % spectrum
    case 1
        featureHigh = varargin{1};
    case 2
        featureHigh = varargin{1};
        featureLow = varargin{2};
    otherwise
        err = MException(['CHI:',mfilename,':IOError'], ...
            'Only featureHigh and featureLow regions are allowed.');
        throw(err);
end

%% Deal with the featureHigh parameter
if exist('featureHigh','var')
    featureHigh = utilities.forceincreasing(featureHigh);
    switch numel(featureHigh)
        case 1
            % Determine the index value of the required feature
            featureHighIdx = chiobj.indexat(featureHigh);

            % Intensity of each spectrum at that feature index value
            featureHighValues = data(:,featureHighIdx);

        case 2
            % Determine the index values of the required feature range
            idx1 = chiobj.indexat(featureHigh(1));
            idx2 = chiobj.indexat(featureHigh(2));

            % Get appropriate intensity of each spectrum in the feature index range
            switch lower(highMethod)
                case 'max'
                    featureHighValues = max(data(:,idx1:idx2),[],2);
                case 'median'
                    featureHighValues = median(data(:,idx1:idx2),2);
                case 'min'
                    featureHighValues = min(data(:,idx1:idx2),[],2);
                otherwise
                    err = MException(['CHI:',mfilename,':IOError'], ...
                        'Only ''max'', ''min'' or ''median'' are allowed.');
                    throw(err);
            end

        otherwise
            err = MException(['CHI:',mfilename,':IOError'], ...
                'Parameter ''featureHigh'' should be either a single value, or a vector of two values.');
            throw(err);
    end
else
    % Default to the maximum intensity value in each spectrum
    featureHighValues = max(data,[],2);
end

%% Deal with the featureLow parameter
if exist('featureLow','var')
    featureLow = utilities.forceincreasing(featureLow);
    switch numel(featureLow)
        case 1
            % Determine the index value of the required feature
            featureLowIdx = chiobj.indexat(featureLow);

            % Intensity of each spectrum at that feature index value
            featureLowValues = data(:,featureLowIdx);

        case 2
            % Determine the index values of the required feature range
            idx1 = chiobj.indexat(featureLow(1));
            idx2 = chiobj.indexat(featureLow(2));

            % Get appropriate intensity of each spectrum in the feature index range
            switch lower(lowMethod)
                case 'max'
                    featureLowValues = max(data(:,idx1:idx2),[],2);
                case 'median'
                    featureLowValues = median(data(:,idx1:idx2),2);
                case 'min'
                    featureLowValues = min(data(:,idx1:idx2),[],2);
                otherwise
                    err = MException(['CHI:',mfilename,':IOError'], ...
                        'Only ''max'', ''min'' or ''median'' are allowed.');
                    throw(err);
            end

        otherwise
            err = MException(['CHI:',mfilename,':IOError'], ...
                'Parameter ''featureLow'' should be either a single value, or a vector of two values.');
            throw(err);
    end
else
    % Default to the minimum intensity value in each spectrum
    featureLowValues = min(data,[],2);
end

%% Normalise
% Adjust the intensity of each spectrum (row) such that the featureHigh
% intensity will be 1 and the featureLow intensity will be 0. All other
% spectral points are scaled accordingly.

featureHighValues = repmat(featureHighValues,1,numdatapoints);
featureLowValues = repmat(featureLowValues,1,numdatapoints);

scaled_data = (data - featureLowValues) ./ (featureHighValues - featureLowValues);
