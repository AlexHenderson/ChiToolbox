function obj = secondderiv(varargin)

% secondderiv  Calculates the second derivative of the data
%
% Syntax
%   secondderiv(windowLength);
%   secondderiv(windowLength,endPoints);
%   deriv = secondderiv(____);
%
% Description
%   secondderiv(windowLength) calculates the second derivative of data
%   using the Savitzky-Golay method with a smoothing window of
%   windowLength. windowLength must be an odd number. (windowLength-1)/2
%   points at each end of the output are approximated by default (endPoints
%   = 'same').
% 
%   secondderiv(windowLength,endPoints) if endPoints is 'valid' the result
%   only contains the valid portion of the data; (windowLength-1)/2 points
%   at each end of the output are deleted. endPoints can be either 'same'
%   (default) or 'valid'.
% 
%   deriv = secondderiv(____) clones the data then performs a second
%   derivative on the clone. The original data is not modified.
% 
%   This function calculates a second derivative while performing a
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
%   Uses Andrew Horchler's sgolayfilt function to compute the filter
%
% Copyright (c) 2007-2018, Alex Henderson.
% Licenced under the GNU General Public License (GPL) version 3.
%
% See also 
%   sgolay smooth firstderiv.

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
    % Not a great approach, but quite generic. 
    % Prevents errors if the function name changes. 
    command = [mfilename, '(obj,varargin{2:end});']; 
    eval(command);  
else
    % We are expecting to modify this object in situ

    [this.data,this.xvals,windowLength,endPoints] = utilities.secondderiv(this.xvals,this.data,varargin{2:end});
    
    this.ylabelname = ['d^2(', this.ylabelname, ') / d(', this.xlabelname, ')^2'];

    if isempty(this.ylabelunit)
        this.ylabelunit = ['1/(', this.xlabelunit, ')^2'];
    else
        this.ylabelunit = [this.ylabelunit, '/(', this.xlabelunit, ')^2'];
    end

    message = 'second derivative (Savitzky-Golay)';
    message = [message, ': window length = ', num2str(windowLength)];
    message = [message, ', end points = ', endPoints];
    this.history.add(message);
end
    
end
