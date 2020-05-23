function plotscoresconf(this,pcx,pcy,varargin)

% plotscoresconf  Plots principal component scores with confidence ellipses. 
%
% Syntax
%   plotscoresconf(pcx,pcy);
%   plotscoresconf(pcx,pcy,percentconf);
%   plotscoresconf(____,'nofig');
%
% Description
%   plotscoresconf(pcx,pcy) creates a 2-D scatter plot of principal component
%   scores. pcx is the principal component number to plot on the x-axis,
%   while pcy is the principal component number to plot on the y-axis.
%   Ellipses are drawn for all classes at 95% conficence. A new figure
%   window is created.
%
%   plotscoresconf(pcx,pcy,percentconf) Principal component scores are plotted
%   with ellipses at percentconf. A new figure window is created.
%
%   plotscoresconf(____,'nofig') plots the scores in the currently active
%   figure window, or creates a new figure if none is available.
%
%   Other parameters can be applied to customise the plot. See the MATLAB
%   scatter, or utilities.gscatter, functions for more details. 
%
% Notes
%   See: 
%   https://stats.stackexchange.com/questions/217374/real-meaning-of-confidence-ellipse
%   for a discussion of confidence ellipses. 
% 
% Copyright (c) 2017-2019, Alex Henderson.
% Licenced under the GNU General Public License (GPL) version 3.
%
% See also 
%   scatter utilities.gscatter plotscores plotloadings
%   plotexplainedvariance plotcumexplainedvariance ChiSpectralPCAOutcome
%   ChiSpectralCollection.

% Contact email: alex.henderson@manchester.ac.uk
% Licenced under the GNU General Public License (GPL) version 3
% http://www.gnu.org/copyleft/gpl.html
% Other licensing options are available, please contact Alex for details
% If you use this file in your work, please acknowledge the author(s) in
% your publications. 

% The latest version of this file is available on Bitbucket
% https://bitbucket.org/AlexHenderson/chitoolbox


titlestub = 'Scores on principal components ';
windowtitlestub = titlestub;
axislabelstub = 'score on PC ';
errorcode = 'CHI:ChiSpectralPCAOutcome';
errormessagestub = 'Requested principal component is out of range. Max PCs = ';

if isempty(this.classmembership)
    err = MException([errorcode,':InputError'], ...
        'This collection has no classmembership. Confidence ellipses cannot be drawn.');
    throw(err);
end

if ((pcx > this.numpcs) || (pcx < 1))
    err = MException([errorcode,':OutOfRange'], ...
        [errormessagestub, num2str(this.numpcs), '.']);
    throw(err);
end
if ((pcy > this.numpcs) || (pcy < 1))
    err = MException([errorcode,':OutOfRange'], ...
        [errormessagestub, num2str(this.numpcs), '.']);
    throw(err);
end

argposition = find(cellfun(@(x) strcmpi(x, 'nofig') , varargin));
if argposition
    % Remove the parameter from the argument list
    varargin(argposition) = [];
else
    % No 'nofig' found so create a new figure
    windowtitle = [windowtitlestub, num2str(pcy), ' and ' num2str(pcx)];
    figure('Name',windowtitle,'NumberTitle','off');
end    

% Percentage confidence
if (~isempty(varargin) && isnumeric(varargin{1}))
    percentconf = varargin{1};
    varargin(1) = []; 
else
    percentconf = 95;
end

% Defaults
axiscolour = 'k';
decplaces = 3;
colours = get(gca,'colororder');

% Check the format of colours
numcolours = size(colours,1);
if (this.classmembership.numuniquelabels > numcolours)
    utilities.warningnobacktrace('There are more groups than colours, the colours will be recycled');
    while (this.classmembership.numuniquelabels > size(colours,1))
        colours = vertcat(colours,colours); %#ok<AGROW>
    end
end

% utilities.gscatter(this.scores(:,pcx), this.scores(:,pcy), this.classmembership.labels, 'colours', colours, 'nofig');
utilities.gscatter(this.scores(:,pcx), this.scores(:,pcy), this.classmembership.labels, 'colours', colours, 'nofig', varargin{:});

%% Draw the confidence ellipses
if ~exist('error_ellipse', 'file')
    utilities.warningnobacktrace('Function ''error_ellipse'' required to draw confidence ellipses. See https://uk.mathworks.com/matlabcentral/fileexchange/4705-error-ellipse');
else
    
    % Draw confidence ellipses at the requested level
    hold on;
    for i = 1:this.classmembership.numuniquelabels
        thisgroupX = this.scores(this.classmembership.labelids == i, pcx);
        thisgroupY = this.scores(this.classmembership.labelids == i, pcy);
        groupmeanX = mean(thisgroupX);
        groupmeanY = mean(thisgroupY);
        groupcov = cov(thisgroupX, thisgroupY);
        h = error_ellipse('C',groupcov,'mu',[groupmeanX,groupmeanY],'conf',percentconf/100);
        h.Color = colours(i,:);
        set(get(get(h,'Annotation'),'LegendInformation'),'IconDisplayStyle','off');
        
    end
%     newtitle = [thetitle, ' (', num2str(percentconf), '% conf)'];
%     title(newtitle);
    
    axis tight
    hold off;
    
end

%% Labels and titles
xlabel([axislabelstub, num2str(pcx), ' (', num2str(this.explained(pcx),decplaces), '%)']);
ylabel([axislabelstub, num2str(pcy), ' (', num2str(this.explained(pcy),decplaces), '%)']);
title([titlestub, num2str(pcx), ' and ', num2str(pcy), ' (', num2str(percentconf), '% conf)']);


%% Legend
% if ~isempty(this.classmembership)
%     if ismatlab()
%       legend('Location','Best');
%     else
%       legend();
%     end      
% end    

%% Draw lines indicating zero x and y
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
plotinfo.xpointlabel = ['PC ', num2str(pcx)];
plotinfo.ypointlabel = ['PC ', num2str(pcy)];
plotinfo.xdata = this.scores(:,pcx);
plotinfo.ydata = this.scores(:,pcy);

if ~isempty(this.classmembership)
    plotinfo.pointmembershiplabels = this.classmembership.labels;
end

figurehandle = gcf;
cursor = datacursormode(figurehandle);
set(cursor,'UpdateFcn',{@utilities.datacursor_scores_6sf,this,plotinfo});

end

