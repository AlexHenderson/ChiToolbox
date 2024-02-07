function output = area(varargin)

% area  The area above a zero intensity baseline
%
% Syntax
%   values = area(lowx, highx);
%
% Description
%   values = area(lowx, highx) calculates the area under each spectrum
%   between the limits provided in lowx and highx in x-axis units. No
%   baseline is removed.
%
% Copyright (c) 2017-2019, Alex Henderson.
% Licenced under the GNU General Public License (GPL) version 3.
%
% See also 
%   peakarea peakareaidx areaidx

% Contact email: alex.henderson@manchester.ac.uk
% Licenced under the GNU General Public License (GPL) version 3
% http://www.gnu.org/copyleft/gpl.html
% Other licensing options are available, please contact Alex for details
% If you use this file in your work, please acknowledge the author(s) in
% your publications. 

% The latest version of this file is available at:
% https://github.com/AlexHenderson/ChiToolbox


output = area@ChiMSCharacter(varargin{:});

end % function area
