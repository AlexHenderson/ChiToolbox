function drawx0axis(axis)

% drawx0axis  Draw line indicating x=0 on a chart
%
% Syntax
%   drawx0axis(axis);
%
% Description
%   drawx0axis(axis) takes the axis limits of a chart and plots x=0 on that
%   chart
% 
% Copyright (c) 2018, Alex Henderson.
% Licenced under the GNU General Public License (GPL) version 3.
%
% See also 
%   drawy0axis, draw00axes, plot scatter, gscatter.

% Contact email: alex.henderson@manchester.ac.uk
% Licenced under the GNU General Public License (GPL) version 3
% http://www.gnu.org/copyleft/gpl.html
% Other licensing options are available, please contact Alex for details
% If you use this file in your work, please acknowledge the author(s) in
% your publications. 

% The latest version of this file is available on Bitbucket
% https://bitbucket.org/AlexHenderson/chitoolbox


axiscolour = 'k';

hold on;
limits = axis;
ymax = limits(1,3);
ymin = limits(1,4);
h = plot([0,0],[ymin,ymax], axiscolour);
set(get(get(h,'Annotation'),'LegendInformation'),'IconDisplayStyle','off');
hold off;    