function varargout = shadederrorbarformatted(varargin)

% shadederrorbarformatted  Generates a line plot with some aesthetic choices
%
% Syntax
%   shadederrorbarformatted();
%   handle = shadederrorbarformatted();
%
% Description
%   shadederrorbarformatted() creates a shadedErrorBar plot with tick marks
%   pointing out of the axis. The top and right axes are removed.
%
%   handle = shadederrorbarformatted(____) returns a handle to the plot
%   contents.
%
% Notes
%   This function is to co-locate the formatting of shadedErrorBar plots. 
% 
% Copyright (c) 2023, Alex Henderson.
% Licenced under the GNU General Public License (GPL) version 3.
%
% See also 
%   shadedErrorBar utilities.stemformatted axis.TickDir axis.Box.

% Contact email: alex.henderson@manchester.ac.uk
% Licenced under the GNU General Public License (GPL) version 3
% http://www.gnu.org/copyleft/gpl.html
% Other licensing options are available, please contact Alex for details
% If you use this file in your work, please acknowledge the author(s) in
% your publications. 

% The latest version of this file is available at:
% https://github.com/AlexHenderson/ChiToolbox


h = shadedErrorBar(varargin{:});
ax = h.Parent;
ax.TickDir = 'out';
ax.Box = 'off';

if nargout
    varargout{1} = h;
end
