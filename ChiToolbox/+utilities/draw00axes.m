function draw00axes(axis)

% draw00axes  Draw lines indicating x=0 and y=0 on a chart
%
% Syntax
%   draw00axes(axis);
%
% Description
%   draw00axes(axis) takes the axis limits of a chart and plots x=0 and y=0
%   on that chart
% 
% Copyright (c) 2018, Alex Henderson.
% Licenced under the GNU General Public License (GPL) version 3.
%
% See also 
%   drawx0axis, drawy0axis, plot, scatter, utilities.gscatter.

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
xmin = limits(1,1);
xmax = limits(1,2);
ymin = limits(1,3);
ymax = limits(1,4);
h = plot([0,0], [0,ymax], axiscolour);
set(get(get(h,'Annotation'),'LegendInformation'),'IconDisplayStyle','off');
set(h,'HitTest','off'); % Prevent datatips on this line
h = plot([0,0], [0,ymin], axiscolour);
set(get(get(h,'Annotation'),'LegendInformation'),'IconDisplayStyle','off');
set(h,'HitTest','off'); % Prevent datatips on this line
h = plot([0,xmax], [0,0], axiscolour);
set(get(get(h,'Annotation'),'LegendInformation'),'IconDisplayStyle','off');
set(h,'HitTest','off'); % Prevent datatips on this line
h = plot([0,xmin], [0,0], axiscolour);
set(get(get(h,'Annotation'),'LegendInformation'),'IconDisplayStyle','off');
set(h,'HitTest','off'); % Prevent datatips on this line
hold off;    
