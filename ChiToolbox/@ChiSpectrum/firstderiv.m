function obj = firstderiv(this,varargin)

% firstderiv  Calculates the first derivative of the data
%
% Syntax
%   firstderiv(windowLength);
%   firstderiv(endPoints);
%
% Description
%   firstderiv(windowLength) calculates the first derivative of data
%   using the Savitzky-Golay method with a smoothing window of
%   windowLength. windowLength must be an odd number. (windowLength-1)/2
%   points at each end of the output are approximated by default (endPoints
%   = 'same').
% 
%   firstderiv(windowLength,endPoints) if endPoints is 'valid' the result
%   only contains the valid portion of the data; (windowLength-1)/2 points
%   at each end of the output are deleted. endPoints can be either 'same'
%   (default) or 'valid'.
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
%   sgolay secondderiv.

% Contact email: alex.henderson@manchester.ac.uk
% Licenced under the GNU General Public License (GPL) version 3
% http://www.gnu.org/copyleft/gpl.html
% Other licensing options are available, please contact Alex for details
% If you use this file in your work, please acknowledge the author(s) in
% your publications. 

% Version 2.0, March 2018
% The latest version of this file is available on Bitbucket
% https://bitbucket.org/AlexHenderson/chitoolbox

%   (c) Alex Henderson Dec 2007
%   Modified in 2018 to use Andrew Horchler's sgolayfilt function and
%   convolution

if nargout
    obj = this.clone();
    obj.firstderiv(varargin{:});
else
    % We are expecting to modified this object in situ
    [this.data,this.xvals,windowLength,endPoints] = utilities.firstderiv(this.xvals,this.data,varargin{:});
    
    this.ylabelname = ['d(', this.ylabelname, ') / d(', this.xlabelname, ')'];

    if isempty(this.ylabelunit)
        this.ylabelunit = ['1/',this.xlabelunit];
    else
        this.ylabelunit = [this.ylabelunit, '/', this.xlabelunit];
    end

    message = 'first derivative';
    message = [message, ': window length = ', num2str(windowLength)];
    message = [message, ', end points = ', endPoints];
    this.history.add(message);
end
    
end
