function obj = smooth(this,varargin)

% smooth  Smooths the data using the Savitzky-Golay method
%
% Syntax
%   smooth(windowLength);
%   smooth(windowLength,endPoints);
%   smoothed = smooth(____);
%
% Description
%   smooth(windowLength) calculates a smoothed version of the data using
%   the Savitzky-Golay method with a smoothing window of windowLength.
%   windowLength must be an odd number. (windowLength-1)/2 points at each
%   end of the output are approximated by default (endPoints = 'same').
% 
%   smooth(windowLength,endPoints) if endPoints is 'valid' the result only
%   contains the valid portion of the data; (windowLength-1)/2 points at
%   each end of the output are deleted. The xvals output is also cropped in
%   the same manner. endPoints can be either 'same' (default) or 'valid'.
% 
%   smoothed = smooth(____) clones the data then performs a smooth on the
%   clone. The original data is not modified. 
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
% The latest version of this file is available at:
% https://github.com/AlexHenderson/ChiToolbox


if nargout
    obj = this.clone();
    obj.smooth(varargin{:});
else
    % We are expecting to modified this object in situ
    [this.data,this.xvals,windowLength,endPoints] = utilities.smooth(this.xvals,this.data,varargin{:});
    
    this.ylabelname = [this.ylabelname, ' (smoothed)'];

    message = 'smoothed (Savitzky-Golay)';
    message = [message, ': window length = ', num2str(windowLength)];
    message = [message, ', end points = ', endPoints];
    this.history.add(message);
end
    
end
