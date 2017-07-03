function plotscores(this,pc_x,pc_y,fontsize,fontweight)

% PLOT_PCSCORES Plots principal component scores of your choice
% usage:
%     plotscores(this,pc_x,pc_y);
%     plotscores(this,pc_x,pc_y);
%     plotscores(this,pc_x,pc_y,fontsize);
%     plotscores(this,pc_x,pc_y,fontsize,fontweight);
%
% where:
%   pc_x - the number of the principal component to plot on the x axis
%   pc_y - the number of the principal component to plot on the y axis
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

if ~isempty(this.classmembership)
    gscatter(this.scores(:,pc_x), this.scores(:,pc_y), this.classmembership.labels, colours, '.');
else
    scatter(this.scores(:,pc_x), this.scores(:,pc_y), '.');
end    

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


xlabel(['score on PC ', num2str(pc_x), ' (', num2str(this.explained(pc_x),decplaces), '%)']);
ylabel(['score on PC ', num2str(pc_y), ' (', num2str(this.explained(pc_y),decplaces), '%)']);
title(['Scores on principal components ', num2str(pc_x), ' and ', num2str(pc_y)]);

if ~isempty(this.classmembership)
    if ismatlab()
      legend('Location','Best');
    else
      legend();
    end      
end    

% Draw lines indicating zero x and y
hold on;
limits = axis;
xmin = limits(1,1);
xmax = limits(1,2);
ymin = limits(1,3);
ymax = limits(1,4);

plot([0,0], [0,ymax], axiscolour);
plot([0,0], [0,ymin], axiscolour);
plot([0,xmax], [0,0], axiscolour);
plot([0,xmin], [0,0], axiscolour);
axis tight
hold off;

end

