function plotscores(this,pcx,pcy,varargin)

% plotscores  Plots principal component scores overlaid with projected data
%
% Syntax
%   plotscores(pcx,pcy);
%   plotscores(pcx,pcy,'nofig');
%
% Description
%   plotscores(pcx,pcy) creates a 2-D scatter plot of principal component
%   scores. Predicted scores from the previously unseen data are overlaid
%   using a different marker (default = '*').
%   If the predicted data had a classmembership, the predicted markers are
%   shown in their 'true' colour. If the predicted data had no
%   classmembership the markers are classified as 'undefined label' and
%   shown in black.
%   pcx is the principal component number to plot on the x-axis, while pcy
%   is the principal component number to plot on the y-axis. A new figure
%   window is created.
%
%   plotscores(pcx,pcy,'nofig') plots the scores in the currently active
%   figure window, or creates a new figure if none is available.
%
%   Other parameters can be applied to customise the plot. See the MATLAB
%   scatter, or utilities.gscatter, functions for more details. 
%
% Notes
%   If the object has classmembership available, the scores will be plotted
%   in colours relating to their class using the utilities.gscatter
%   function.
%
% Copyright (c) 2017-2023, Alex Henderson.
% Licenced under the GNU General Public License (GPL) version 3.
%
% See also 
%   scatter utilities.gscatter ChiPCAModel ChiSpectralCollection.

% Contact email: alex.henderson@manchester.ac.uk
% Licenced under the GNU General Public License (GPL) version 3
% http://www.gnu.org/copyleft/gpl.html
% Other licensing options are available, please contact Alex for details
% If you use this file in your work, please acknowledge the author(s) in
% your publications. 

% The latest version of this file is available on Bitbucket
% https://bitbucket.org/AlexHenderson/Chitoolbox


titlestub = 'Scores on principal components ';
windowtitlestub = titlestub;
axislabelstub = 'score on PC ';
errorcode = 'Chi:ChiPCAModel';
errormessagestub = 'Requested principal component is out of range. Max PCs = ';

% Some defaults
marker = '.';
pmarker = '*';
sizedata = 6;
sizedatadefined = false;

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
    windowtitle = [windowtitlestub, num2str(pcx), ' and ' num2str(pcy)];
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
decplaces = 3;

projectedcolours = colours(unique(this.trueclassid,'stable'),:);
projectedlabels = this.trueclasslabel;

if isempty(this.trueclasslabel)
    projectedcolours = 'k';
    projectedlabels = cell(size(this.projectedscores,1),1);
    projectedlabels(:) = {'undefined label'};    
end

if ~isempty(this.model.classmembership)
    utilities.gscatter(this.model.scores(:,pcx), this.model.scores(:,pcy), this.model.classmembership.labels, 'colours', colours, 'sizedata', sizedata, marker, 'nofig', varargin{:});
    hold on;
    utilities.gscatter(this.projectedscores(:,pcx), this.projectedscores(:,pcy), projectedlabels, 'colours', projectedcolours, 'sizedata', sizedata, pmarker, 'nofig', varargin{:});
    hold off;
else
    utilities.scatterformatted(this.model.scores(:,pcx), this.model.scores(:,pcy), sizedata .* sizedata, marker, varargin{:});
    hold on;
    utilities.scatterformatted(this.projectedscores(:,pcx), this.projectedscores(:,pcy), sizedata .* sizedata, pmarker, varargin{:});
    hold off;
end    

xlabel([axislabelstub, num2str(pcx), ' (', num2str(this.model.explained(pcx),decplaces), '%)']);
ylabel([axislabelstub, num2str(pcy), ' (', num2str(this.model.explained(pcy),decplaces), '%)']);
title([titlestub, num2str(pcx), ' and ', num2str(pcy)]);

%% Draw lines indicating zero x and y
utilities.draw00axes(axis);

%% Manage data cursor information
plotinfo = struct;
plotinfo.xpointlabel = ['PC ', num2str(pcx)];
plotinfo.ypointlabel = ['PC ', num2str(pcy)];
plotinfo.xdata = this.model.scores(:,pcx);
plotinfo.ydata = this.model.scores(:,pcy);

if ~isempty(this.model.classmembership)
    plotinfo.pointmembershiplabels = this.model.classmembership.labels;
end

figurehandle = gcf;
cursor = datacursormode(figurehandle);
set(cursor,'UpdateFcn',{@utilities.datacursor_scores_6sf,this,plotinfo});
    
end
