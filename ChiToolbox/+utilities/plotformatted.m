function varargout = plotformatted(varargin)

% plotformatted  Generates a line plot with some aesthetic choices
%
% Syntax
%   plotformatted();
%   handle = plotformatted();
%
% Description
%   plotformatted() creates a 2-D line plot with tick marks pointing out of
%   the axis. The top and right axes are removed. 
%
%   handle = plotformatted(____) returns a handle to the plot contents.
%
% Notes
%   This function is to co-locate the formatting of line plots. 
% 
% Copyright (c) 2023, Alex Henderson.
% Licenced under the GNU General Public License (GPL) version 3.
%
% See also 
%   plot utilities.stemformatted axis.TickDir axis.Box.

% Contact email: alex.henderson@manchester.ac.uk
% Licenced under the GNU General Public License (GPL) version 3
% http://www.gnu.org/copyleft/gpl.html
% Other licensing options are available, please contact Alex for details
% If you use this file in your work, please acknowledge the author(s) in
% your publications. 

% The latest version of this file is available at:
% https://github.com/AlexHenderson/ChiToolbox


h = plot(varargin{:});
ax = h.Parent;
ax.TickDir = 'out';
ax.Box = 'off';

if nargout
    varargout{1} = h;
end
