function plotcvscores(this,cv_x,cv_y,fontsize,fontweight)

% PLOTCVCSCORES Plots canonical variate scores of your choice
% usage:
%     plotcvscores(this,cv_x,cv_y);
%     plotcvscores(this,cv_x,cv_y);
%     plotcvscores(this,cv_x,cv_y,fontsize);
%     plotcvscores(this,cv_x,cv_y,fontsize,fontweight);
%
% where:
%   cv_x - the number of the canonical variate component to plot on the x axis
%   cv_y - the number of the canonical variate component to plot on the y axis
%   fontsize - (optional) set to change the font size
%   fontweight - (optional) set to change the font weight ('normal'
%   (default) | 'bold')
%
%   If classmembership is available, the scores will be plotted in colours
%   relating to their group
%
%   Copyright (c) 2015-2017, Alex Henderson 
%   Contact email: alex.henderson@manchester.ac.uk
%   Licenced under the GNU General Public License (GPL) version 3
%   http://www.gnu.org/copyleft/gpl.html
%   Other licensing options are available, please contact Alex for details
%   If you use this file in your work, please acknowledge the author(s) in
%   your publications. 
%
%   version 2.0 July 2017

%   version 2.0 July 2017 Alex Henderson
%   Converted to a class function
%   version 1.2 August 2016 Alex Henderson
%   Added 'axis tight' to force the axis bars to touch the window frame
%   version 1.1 April 2016
%   Added fontsize and fontweight options
%   version 1.0 June 2015 Alex Henderson
%   initial release

colours = 'bgrcmky';
axiscolour = 'k';
decplaces = 3;

% window_title = ['Scores on principal components ', num2str(pc_x), ' and ', num2str(pc_y)];
% figure_handle = figure('Name',window_title,'NumberTitle','off');

gscatter(this.cvscores(:,cv_x), this.cvscores(:,cv_y), this.PCAOutcome.classmembership.labels, colours, '.');

if (exist('fontsize','var') && ~isempty(fontsize))
    if (ismatlab())
      set(gca,'FontSize',fontsize)
    else
        % Not sure if Octave does this, so assume 'yes'
      set(gca,'FontSize',fontsize)
    end      
end    

if (exist('fontweight','var') && ~isempty(fontweight))
    if (ismatlab())
      set(gca,'FontWeight',fontweight)
    else
        % Not sure if Octave does this, so assume 'yes'
      set(gca,'FontWeight',fontweight)
    end      
end    

xlabel(['score on CV ', num2str(cv_x), ' (', num2str(this.cvexplained(cv_x),decplaces), '%)']);
ylabel(['score on CV ', num2str(cv_y), ' (', num2str(this.cvexplained(cv_y),decplaces), '%)']);
title(['Scores on canonical variates ', num2str(cv_x), ' and ', num2str(cv_y), ' (',num2str(this.pcs), ' pcs)']);

if ismatlab()
  legend('Location','Best');
else
  legend();
end      

% Draw lines indicating zero x and y
hold on;
limits = axis;
xmin = limits(1,1);
xmax = limits(1,2);
ymin = limits(1,3);
ymax = limits(1,4);

h = plot([0,0], [0,ymax], axiscolour);
set(get(get(h,'Annotation'),'LegendInformation'),'IconDisplayStyle','off');
h = plot([0,0], [0,ymin], axiscolour);
set(get(get(h,'Annotation'),'LegendInformation'),'IconDisplayStyle','off');
h = plot([0,xmax], [0,0], axiscolour);
set(get(get(h,'Annotation'),'LegendInformation'),'IconDisplayStyle','off');
h = plot([0,xmin], [0,0], axiscolour);
set(get(get(h,'Annotation'),'LegendInformation'),'IconDisplayStyle','off');
axis tight
hold off;

end

