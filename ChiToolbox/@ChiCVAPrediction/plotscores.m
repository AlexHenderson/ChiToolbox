function plotscores(this,cvx,cvy,varargin)

% plotscores  Plots canonical variate scores overlaid with projected data
%
% Syntax
%   plotscores(cvx,cvy);
%   plotscores(cvx,cvy,'nofig');
%
% Description
%   plotscores(cvx,cvy) creates a 2-D scatter plot of canonical variate
%   scores. Predicted scores from the previously unseen data are overlaid
%   using a different marker (default = '*'). 
%   If the predicted data had a classmembership, the predicted markers are
%   shown in their 'true' colour. If the predicted data had no
%   classmembership the markers are classified as 'undefined label' and
%   shown in black.
%   cvx is the canonical variate number to plot on the x-axis, while cvy is
%   the canonical variate number to plot on the y-axis. A new figure window
%   is created.
%
%   plotscores(cvx,cvy,'nofig') plots the scores in the currently active
%   figure window, or creates a new figure if none is available.
%
%   Other parameters can be applied to customise the plot. See the MATLAB
%   scatter, or utilities.gscatter, functions for more details. 
%
% Notes
%   If the unseen data has no class variable, the projection will be
%   plotted using 'undefined label' and plotted in black. 
%
% Copyright (c) 2020, Alex Henderson.
% Licenced under the GNU General Public License (GPL) version 3.
%
% See also 
%   scatter utilities.gscatter ChiCVAModel ChiSpectralCollection.

% Contact email: alex.henderson@manchester.ac.uk
% Licenced under the GNU General Public License (GPL) version 3
% http://www.gnu.org/copyleft/gpl.html
% Other licensing options are available, please contact Alex for details
% If you use this file in your work, please acknowledge the author(s) in
% your publications. 

% The latest version of this file is available on Bitbucket
% https://bitbucket.org/AlexHenderson/Chitoolbox

titlestub = 'Scores on canonical variates ';
windowtitlestub = titlestub;
axislabelstub = 'score on CV ';

% Some defaults
marker = '.';
pmarker = '*';
sizedata = 6;
sizedatadefined = false;

if ((cvx > this.model.numcvs) || (cvx < 1))
    err = MException(['CHI:',mfilename,':OutOfRange'], ...
        ['Requested canonical variate is out of range. Max CVs = ', num2str(this.model.numcvs), '.']);
    throw(err);
end
if ((cvy > this.model.numcvs) || (cvy < 1))
    err = MException(['CHI:',mfilename,':OutOfRange'], ...
        ['Requested canonical variate is out of range. Max CVs = ', num2str(this.model.numcvs), '.']);
    throw(err);
end

argposition = find(cellfun(@(x) strcmpi(x, 'nofig') , varargin));
if argposition
    % Remove the parameter from the argument list
    varargin(argposition) = [];
else
    % No 'nofig' found so create a new figure
    windowtitle = [windowtitlestub, num2str(cvx), ' and ' num2str(cvy)];
    figure('Name',windowtitle,'NumberTitle','off');
end    

% sizedata
argposition = find(cellfun(@(x) strcmpi(x, 'sizedata'), varargin));
if argposition
    sizedata = varargin{argposition+1};
    sizedatadefined = true;
    varargin(argposition+1) = [];
    varargin(argposition) = [];
end

% projected data marker
% Do this before looking for the marker since we can't search for two
% different string
argposition = find(cellfun(@(x) strcmpi(x, 'pmarker'), varargin));
if argposition
    pmarker = varargin{argposition +1};
    varargin(argposition+1) = [];
    varargin(argposition) = [];
end

% marker
argposition = find(cellfun(@(x) ischar(x) , varargin));
if argposition
    marker = varargin{argposition};
    varargin(argposition) = [];
end

% If the chosen marker is a dot and the size has not been defined, make the
% dot a bit bigger. 
if (strcmp(marker, '.') && ~sizedatadefined)
    sizedata = 15;
end

colours = get(gca,'colororder');
axiscolour = 'k';
decplaces = 3;

projectedcolours = colours;
projectedlabels = this.truelabel;

if isempty(this.truelabel)
    projectedcolours = 'k';
    projectedlabels = cell(size(this.projectedscores,1),1);
    projectedlabels(:) = {'undefined label'};    
end

if ~isempty(this.model.pca.classmembership)
    utilities.gscatter(this.model.scores(:,cvx), this.model.scores(:,cvy), this.model.pca.classmembership.labels, 'colours', colours, 'sizedata', sizedata, marker, 'nofig', varargin{:});
    hold on;
    utilities.gscatter(this.projectedscores(:,cvx), this.projectedscores(:,cvy), projectedlabels, 'colours', projectedcolours, 'sizedata', sizedata, pmarker, 'nofig', varargin{:});
    hold off;
else
    scatter(this.model.scores(:,cvx), this.model.scores(:,cvy), sizedata .* sizedata, marker, varargin{:});
    hold on;
    scatter(this.projectedscores(:,cvx), this.projectedscores(:,cvy), sizedata .* sizedata, pmarker, varargin{:});
    hold off;
end    

xlabel([axislabelstub, num2str(cvx), ' (', num2str(this.model.explained(cvx),decplaces), '%)']);
ylabel([axislabelstub, num2str(cvy), ' (', num2str(this.model.explained(cvy),decplaces), '%)']);
title([titlestub, num2str(cvx), ' and ', num2str(cvy)]);

% Draw lines indicating zero x and y
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
axis tight
hold off;

%% Manage data cursor information
plotinfo = struct;
plotinfo.xpointlabel = ['CV ', num2str(cvx)];
plotinfo.ypointlabel = ['CV ', num2str(cvy)];
plotinfo.xdata = this.model.scores(:,cvx);
plotinfo.ydata = this.model.scores(:,cvy);

if ~isempty(this.model.pca.classmembership)
    plotinfo.pointmembershiplabels = this.model.pca.classmembership.labels;
end

figurehandle = gcf;
cursor = datacursormode(figurehandle);
set(cursor,'UpdateFcn',{@utilities.datacursor_scores_6sf,this,plotinfo});
    
end
