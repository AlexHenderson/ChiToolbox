function plotscores(this,cvx,cvy,varargin)

% plotscores  Plots canonical variate scores of your choice. 
%
% Syntax
%   plotscores(cvx,cvy);
%   plotscores(cvx,cvy,'nofig');
%
% Description
%   plotscores(cvx,cvy) creates a 2-D scatter plot of canonical variate
%   scores. cvx is the canonical variate to plot on the x-axis,
%   while cvy is the canonical variate to plot on the y-axis. A
%   new figure window is created.
%
%   plotscores(cvx,cvy,'nofig') plots the scores in the currently active
%   figure window, or creates a new figure if none is available.
%
%   Other parameters can be applied to customise the plot. See the
%   utilities.gscatter function for more details.
%
% Copyright (c) 2017-2019, Alex Henderson.
% Licenced under the GNU General Public License (GPL) version 3.
%
% See also 
%   plotloadings plotexplainedvariance plotpcloadings
%   plotpcexplainedvariance plotpccumexplainedvariance utilities.gscatter
%   ChiSpectralPCAOutcome ChiSpectralCollection.


% Contact email: alex.henderson@manchester.ac.uk
% Licenced under the GNU General Public License (GPL) version 3
% http://www.gnu.org/copyleft/gpl.html
% Other licensing options are available, please contact Alex for details
% If you use this file in your work, please acknowledge the author(s) in
% your publications. 

% The latest version of this file is available on Bitbucket
% https://bitbucket.org/AlexHenderson/chitoolbox


titlestub = 'Scores on canonical variates ';
windowtitlestub = titlestub;
axislabelstub = 'score on CV ';
errorcode = 'CHI:ChiSpectralCVAOutcome';
errormessagestub = 'Requested canonical variate is out of range. Max CVs = ';

% If we have more than 1 canonical variate, check that the required cvs are
% in range. 
if (this.numcvs ~= 1)
    if ((cvx > this.numcvs) || (cvx < 1))
    err = MException([errorcode,':OutOfRange'], ...
        [errormessagestub, num2str(this.numcvs), '.']);
    throw(err);
    end

    if ((cvy > this.numcvs) || (cvy < 1))
    err = MException([errorcode,':OutOfRange'], ...
        [errormessagestub, num2str(this.numcvs), '.']);
    throw(err);
    end
end

argposition = find(cellfun(@(x) strcmpi(x, 'nofig') , varargin));
if argposition
    varargin(argposition) = [];
else
    % No 'nofig' found so create a new figure
    if (this.numcvs == 1)
        windowtitle = 'Score on canonical variate 1';
    else
        windowtitle = [windowtitlestub, num2str(cvx), ' and ' num2str(cvy)];
    end
    figure('Name',windowtitle,'NumberTitle','off');
end    

% colours = 'bgrcmky';
colours = get(gca,'colororder');

numcolours = size(colours,1);
if (this.pca.classmembership.numuniquelabels > numcolours)
    utilities.warningnobacktrace('There are more groups than colours, the colours will be recycled');
    while (this.pca.classmembership.numuniquelabels > size(colours,1))
        colours = vertcat(colours,colours); %#ok<AGROW>
    end
end

axiscolour = 'k';
decplaces = 3;

if (this.numcvs > 1)
    % We can use a grouped scatter plot
    utilities.gscatter(this.scores(:,cvx), this.scores(:,cvy), this.pca.classmembership.labels, 'colours', colours, 'nofig',varargin{:});
    
    xlabel([axislabelstub, num2str(cvx), ' (', num2str(this.explained(cvx),decplaces), '%)']);
    ylabel([axislabelstub, num2str(cvy), ' (', num2str(this.explained(cvy),decplaces), '%)']);
    title([titlestub, num2str(cvx), ' and ', num2str(cvy), ' (',num2str(this.pcs), ' pcs)']);
else
    % Only a single canonical variate so we can use a box plot
    boxplot(this.scores,this.pca.classmembership.labels, 'jitter', 0.2, 'notch','on', 'orientation','vertical',varargin{:});
    xlabel(this.pca.classmembership.title);
    ylabel('score on cv 1');
    title('Score on canonical variate 1');    
end

% Draw lines indicating zero x and y
hold on;
limits = axis;
xmin = limits(1,1);
xmax = limits(1,2);
ymax = limits(1,3);
ymin = limits(1,4);
h = plot([0,0], [0,ymax], axiscolour);
set(get(get(h,'Annotation'),'LegendInformation'),'IconDisplayStyle','off');
h = plot([0,0], [0,ymin], axiscolour);
set(get(get(h,'Annotation'),'LegendInformation'),'IconDisplayStyle','off');
h = plot([0,xmax], [0,0], axiscolour);
set(get(get(h,'Annotation'),'LegendInformation'),'IconDisplayStyle','off');
h = plot([0,xmin], [0,0], axiscolour);
set(get(get(h,'Annotation'),'LegendInformation'),'IconDisplayStyle','off');
hold off;    
