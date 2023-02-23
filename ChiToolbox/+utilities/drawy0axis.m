function drawy0axis(axis)

% drawy0axis  Draw line indicating y=0 on a chart
%
% Syntax
%   drawy0axis(axis);
%
% Description
%   drawy0axis(axis) takes the axis limits of a chart and plots y=0 on that
%   chart
% 
% Copyright (c) 2018-2023, Alex Henderson.
% Licenced under the GNU General Public License (GPL) version 3.
%
% See also 
%   drawx0axis, draw00axes, yline, plot, scatter, utilities.gscatter.

% Contact email: alex.henderson@manchester.ac.uk
% Licenced under the GNU General Public License (GPL) version 3
% http://www.gnu.org/copyleft/gpl.html
% Other licensing options are available, please contact Alex for details
% If you use this file in your work, please acknowledge the author(s) in
% your publications. 

% The latest version of this file is available on Bitbucket
% https://bitbucket.org/AlexHenderson/chitoolbox


% Version check to see if xline/yline is available

if verLessThan('matlab', '9.5') %R2018b

    axiscolour = 'k';

    hold on;
    limits = axis;
    xmin = limits(1,1);
    xmax = limits(1,2);
    h = plot([xmin,xmax], [0,0], axiscolour);
    set(get(get(h,'Annotation'),'LegendInformation'),'IconDisplayStyle','off');
    set(h,'HitTest','off'); % Prevent datatips on this line
    hold off;    

else
    
    y = yline(0);
    
    set(get(get(y,'Annotation'),'LegendInformation'),'IconDisplayStyle','off');
    
end
