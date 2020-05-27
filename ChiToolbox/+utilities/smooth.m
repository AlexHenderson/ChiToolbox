function [result,xvals,windowLength,endPoints] = smooth(xvals,data,windowLength,varargin)

% smooth  Smooths the data using the Savitzky-Golay method
%
% Syntax
%   [smoothed,xvals,windowLength,endPoints] = smooth(xvals,data,windowLength);
%   [smoothed,xvals,windowLength,endPoints] = smooth(xvals,data,windowLength,endPoints);
%
% Description
%   [smoothed,xvals,windowLength,endPoints] =
%   smooth(xvals,data,windowLength) calculates a smoothed version of the
%   data using the Savitzky-Golay method with a smoothing window of
%   windowLength. windowLength must be an odd number. (windowLength-1)/2
%   points at each end of the output are approximated by default (endPoints
%   = 'same').
% 
%   [smoothed,xvals,windowLength,endPoints] =
%   smooth(xvals,data,windowLength,endPoints) if endPoints is 'valid'
%   smoothed only contains the valid portion of the data;
%   (windowLength-1)/2 points at each end of the output are deleted. The
%   xvals output is also cropped in the same manner. endPoints can be
%   either 'same' (default) or 'valid'.
% 
%   This function calculates a smoothed version of the data using the
%   Savitzky-Golay method. data is typically smoothed to prevent noise in
%   the data from swamping the result. The windowLength value determines
%   the degree of smoothing - a bigger value means more smoothing.
%   Note that smoothing means you lose points from either end of the data.
%   In this function the 'lost' points are approximated such that the
%   output has the same dimensions as the input. Care must therefore be
%   taken not to over-interpret the ends of the data range. For example; if
%   you have a 7 point smooth you will lose (or have approximated) 3 points
%   from either end of the data.
%   Uses Andrew Horchler's sgolayfilt function to compute the filter
%
% Copyright (c) 2020, Alex Henderson.
% Licenced under the GNU General Public License (GPL) version 3.
%
% See also 
%   sgolay firstderiv secondderiv.

% Contact email: alex.henderson@manchester.ac.uk
% Licenced under the GNU General Public License (GPL) version 3
% http://www.gnu.org/copyleft/gpl.html
% Other licensing options are available, please contact Alex for details
% If you use this file in your work, please acknowledge the author(s) in
% your publications. 

% Version 1.0, May 2020
% The latest version of this file is available on Bitbucket
% https://bitbucket.org/AlexHenderson/chitoolbox


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

if valid
    dropPoints = (windowLength-1)/2;
    xvals = xvals(dropPoints+1 : (end-dropPoints));
    result = zeros(size(data,1),length(xvals));
else
    result = zeros(size(data));
end

for i = 1:size(data,1)
    if valid
        result(i,:) = conv(data(i,:), G(:,1).', endPoints);
    else
        result(i,:) = conv(data(i,:), G(:,1).', endPoints);
    end
end
