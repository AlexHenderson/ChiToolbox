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

% this.PCAOutcome.plotscores(this,pc_x,pc_y,fontsize,fontweight);

this.PCAOutcome.plotscores(pc_x,pc_y);

end

