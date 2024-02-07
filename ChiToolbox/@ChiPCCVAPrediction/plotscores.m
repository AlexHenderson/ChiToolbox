function plotscores(this,cvx,cvy,varargin)

% plotscores  Plots canonical variate scores overlaid with projected data
%
% Syntax
%   plotscores(cvx,cvy);
%   plotscores(cvx,cvy,'nofig');
%   plotscores(____, 'markersize', value);
%   plotscores(____, 'pmarker', value);
%
% Description
%   plotscores(cvx,cvy) creates a 2-D scatter plot of canonical variate
%   scores. Predicted scores from the previously unseen data are overlaid
%   using a different marker (default = '*'). 
%   If the predicted data had a classmembership, the predicted markers are
%   shown in their 'true' colour. If the predicted data had no
%   classmembership the markers are classified as 'projected' and
%   shown in dark grey.
%   cvx is the canonical variate number to plot on the x-axis, while cvy is
%   the canonical variate number to plot on the y-axis. A new figure window
%   is created.
%
%   plotscores(cvx,cvy,'nofig') plots the scores in the currently active
%   figure window, or creates a new figure if none is available.
%
%   plotscores(____, 'markersize', value) plots the markers relating to the
%   model with size value. If marker is '.' (the default) this will be
%   scaled up automatically. 
% 
%   plotscores(____, 'pmarker', value) plots the markers relating to the
%   projected data using the symbol in value. Default is '*'.
% 
%   Other parameters can be applied to customise the plot. See the MATLAB
%   scatter, or utilities.gscatter, functions for more details. 
%
% Notes
%   If the unseen data has no class variable, the projection will be
%   labelled 'projected' and plotted in dark grey. 
%
% Copyright (c) 2020-2023, Alex Henderson.
% Licenced under the GNU General Public License (GPL) version 3.
%
% See also 
%   scatter utilities.gscatter ChiPCCVAModel ChiSpectralCollection.

% Contact email: alex.henderson@manchester.ac.uk
% Licenced under the GNU General Public License (GPL) version 3
% http://www.gnu.org/copyleft/gpl.html
% Other licensing options are available, please contact Alex for details
% If you use this file in your work, please acknowledge the author(s) in
% your publications. 

% The latest version of this file is available at:
% https://github.com/AlexHenderson/ChiToolbox


%% Defaults
titlestub = 'Scores on canonical variates ';
windowtitlestub = titlestub;
axislabelstub = 'score on CV ';

% Some defaults
marker = '.';
pmarker = '*';
markersize = 6;
pmarkersize = 6;
sizedatadefined = false;
explainedvariancedecplaces = 3;

%% Everything in range?
% If we have more than 1 canonical variate, check that the required cvs are
% in range. 
if (this.model.numcvs ~= 1)
    if ((cvx > this.model.numcvs) || (cvx < 1))
    err = MException([errorcode,':OutOfRange'], ...
        [errormessagestub, num2str(this.model.numcvs), '.']);
    throw(err);
    end

    if ((cvy > this.model.numcvs) || (cvy < 1))
    err = MException([errorcode,':OutOfRange'], ...
        [errormessagestub, num2str(this.model.numcvs), '.']);
    throw(err);
    end
end

%% Parse command line
argposition = find(cellfun(@(x) strcmpi(x, 'nofig') , varargin));
if argposition
    % Remove the parameter from the argument list
    varargin(argposition) = [];
else
    % No 'nofig' found so create a new figure
    if (this.model.numcvs == 1)
        windowtitle = 'Score on canonical variate 1';
    else
        windowtitle = [windowtitlestub, num2str(cvx), ' and ' num2str(cvy)];
    end
    figure('Name',windowtitle,'NumberTitle','off');
end    

% sizedata
argposition = find(cellfun(@(x) strcmpi(x, 'markersize'), varargin));
if argposition
    markersize = varargin{argposition+1};
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

%% Define colours, and marker types and sizes
% If the chosen marker is a dot and the size has not been defined, make the
% dot a bit bigger. 
if (strcmp(marker, '.') && ~sizedatadefined)
    markersize = 15;
end

colours = get(gca,'colororder');

if isempty(this.unseendata.classmembership)
    projectedcolours = [0.3, 0.3, 0.3];
    projectedlabels = cell(size(this.projectedscores,1),1);
    projectedlabels(:) = {'projected'};    
else
    projectedcolours = colours(unique(this.unseendata.classmembership.labelids,'stable'),:);
    projectedlabels = this.unseendata.classmembership.labels;
end

%% Commence plotting
if (this.model.numcvs > 1)
    % We can use a grouped scatter plot
    if ~isempty(this.model.pca.classmembership)
        utilities.gscatter(this.model.scores(:,cvx), this.model.scores(:,cvy), this.model.pca.classmembership.labels, 'colours', colours, 'sizedata', markersize, marker, 'nofig', varargin{:});
        hold on;
        utilities.gscatter(this.projectedscores(:,cvx), this.projectedscores(:,cvy), projectedlabels, 'colours', projectedcolours, 'sizedata', pmarkersize, pmarker, 'nofig', varargin{:});
        hold off;
    else
        % Not sure we can ever get here, since the classmembership is
        % required for the CVA
        utilties.scatterformatted(this.model.scores(:,cvx), this.model.scores(:,cvy), markersize .* markersize, marker, varargin{:});
        hold on;
        utilties.scatterformatted(this.projectedscores(:,cvx), this.projectedscores(:,cvy), markersize .* markersize, pmarker, varargin{:});
        hold off;
    end    

    xlabel([axislabelstub, num2str(cvx), ' (', num2str(this.model.explained(cvx),explainedvariancedecplaces), '%)']);
    ylabel([axislabelstub, num2str(cvy), ' (', num2str(this.model.explained(cvy),explainedvariancedecplaces), '%)']);
    title([titlestub, num2str(cvx), ' and ', num2str(cvy)]);
    
    
    % Manage data cursor information
    plotinfo = struct;
    plotinfo.xpointlabel = ['CV ', num2str(cvx)];
    plotinfo.xdata = this.model.scores(:,cvx);

    if (this.model.numcvs > 1)
        plotinfo.ydata = this.model.scores(:,cvy);
        plotinfo.ypointlabel = ['CV ', num2str(cvy)];
    end

    if ~isempty(this.model.pca.classmembership)
        plotinfo.pointmembershiplabels = this.model.pca.classmembership.labels;
    end

    figurehandle = gcf;
    cursor = datacursormode(figurehandle);
    set(cursor,'UpdateFcn',{@utilities.datacursor_scores_6sf,this,plotinfo});
    
    axis tight

else
    % Only a single canonical variate so we can use a box plot
    utilities.boxplotformatted(this.model.scores,this.model.classmembership.labels,varargin{:});
    xlabel(this.model.classmembership.title);
    ylabel('score on cv 1');
    title('Score on canonical variate 1');
    
    hold on
    % model label overlay
    uniquelabels = this.model.classmembership.uniquelabels;
    for i = 1:length(uniquelabels)
        label = uniquelabels{i};
        idx = strcmpi(this.model.classmembership.labels, label);
        x = ones(sum(idx),1) * i;
        y = this.model.scores(idx);
        utilties.scatterformatted(x, y, markersize .* 2, marker, 'jitter','on', 'jitter', 0.1, varargin{:});
    end
    hold off
    
    hold on
    % projected label overlay
    uniquelabels = this.model.classmembership.uniquelabels;
    for i = 1:length(uniquelabels)
        label = uniquelabels{i};
        idx = strcmpi(projectedlabels, label);
        x = ones(sum(idx),1) * i;
        y = this.projectedscores(idx);
        utilties.scatterformatted(x, y, markersize .* 2, pmarker, 'jitter','on', 'jitter', 0.2, varargin{:});
    end
    hold off
end

%% Draw lines indicating zero x and y
utilities.draw00axes(axis);

end
