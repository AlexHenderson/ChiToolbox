function varargout = boxplotformatted(varargin)

% boxplotformatted  Generates a box plot with some aesthetic choices
%
% Syntax
%   boxplotformatted();
%   handle = boxplotformatted();
%
% Description
%   boxplotformatted() creates a box plot with tick marks pointing out of
%   the axis. The top and right axes are removed. 
%
%   handle = boxplotformatted(____) returns a handle to the plot contents.
%
% Notes
%   This function is to co-locate the formatting of line plots. 
% 
% Copyright (c) 2023, Alex Henderson.
% Licenced under the GNU General Public License (GPL) version 3.
%
% See also 
%   boxplot utilities.stemformatted axis.TickDir axis.Box.

% Contact email: alex.henderson@manchester.ac.uk
% Licenced under the GNU General Public License (GPL) version 3
% http://www.gnu.org/copyleft/gpl.html
% Other licensing options are available, please contact Alex for details
% If you use this file in your work, please acknowledge the author(s) in
% your publications. 

% The latest version of this file is available at:
% https://github.com/AlexHenderson/ChiToolbox


boxplot(varargin{:}, 'jitter',0.2, 'notch','on', 'orientation','vertical');
ax = gca;
ax.TickDir = 'out';
ax.Box = 'off';

utilities.drawy0axis();

if nargout
    varargout{1} = ax;
end
