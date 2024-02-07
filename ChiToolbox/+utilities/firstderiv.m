function [deriv,xvals,windowLength,endPoints] = firstderiv(xvals,data,windowLength,varargin)

% firstderiv  Calculates the first derivative of the data
%
% Syntax
%   [deriv,xvals,windowLength,endPoints] = firstderiv(xvals,data,windowLength);
%   [deriv,xvals,windowLength,endPoints] = firstderiv(xvals,data,windowLength,endPoints);
%
% Description
%   [deriv,xvals,windowLength,endPoints] =
%   firstderiv(xvals,data,windowLength) calculates the first derivative
%   of data using the Savitzky-Golay method with a smoothing window of
%   windowLength. windowLength must be an odd number. (windowLength-1)/2
%   points at each end of the output are approximated by default (endPoints
%   = 'same').
% 
%   [deriv,xvals,windowLength,endPoints] =
%   firstderiv(xvals,data,windowLength,endPoints) if endPoints is 'valid'
%   deriv only contains the valid portion of the data; (windowLength-1)/2
%   points at each end of the output are deleted. The xvals output is also
%   cropped in the same manner. endPoints can be either 'same' (default) or
%   'valid'.
% 
%   This function calculates a first derivative while performing a
%   Savitzky-Golay smooth at the same time. data is typically smoothed to
%   prevent noise in the data from swamping the result. The windowLength
%   value determines the degree of smoothing - a bigger value means more
%   smoothing.
%   Note that smoothing means you lose points from either end of the data.
%   In this function the 'lost' points are approximated such that the
%   output has the same dimensions as the input. Care must therefore be
%   taken not to over-interpret the ends of the data range. For example; if
%   you have a 7 point smooth you will lose (or have approximated) 3 points
%   from either end of the data.
%
% Copyright (c) 2018, Alex Henderson.
% Licenced under the GNU General Public License (GPL) version 3.
%
% See also 
%   sgolay smooth secondderiv.

% Contact email: alex.henderson@manchester.ac.uk
% Licenced under the GNU General Public License (GPL) version 3
% http://www.gnu.org/copyleft/gpl.html
% Other licensing options are available, please contact Alex for details
% If you use this file in your work, please acknowledge the author(s) in
% your publications. 

% Version 2.0, March 2018
% The latest version of this file is available at:
% https://github.com/AlexHenderson/ChiToolbox

%   (c) Alex Henderson Dec 2007
%   Modified in 2018 to use Andrew Horchler's sgolayfilt function and
%   convolution


valid = false;
endPoints = 'same';
if ~isempty(varargin)
    argposition = find(cellfun(@(x) strcmpi(x, 'valid') , varargin));
    if argposition
        valid = true;
        endPoints = 'valid';
    end
end

N = 4;                          % Order of polynomial fit
F = windowLength;               % Window length
G = horchler.sgolayfilt(N,F);   % Calculate S-G coefficients

dx = (xvals(end)-xvals(1)) / (length(xvals)-1);

if valid
    dropPoints = (windowLength-1)/2;
    xvals = xvals(dropPoints+1 : (end-dropPoints));
    deriv = zeros(size(data,1),length(xvals));
else
    deriv = zeros(size(data));
end

for i = 1:size(data,1)
    if valid
        deriv(i,:) = (1 / dx) * conv(data(i,:), G(:,2).', endPoints);
    else
        deriv(i,:) = (1 / dx) * conv(data(i,:), G(:,2).', endPoints);
    end
end
