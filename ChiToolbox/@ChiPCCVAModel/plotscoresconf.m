function plotscoresconf(this,cvx,cvy,varargin)

% plotscoresconf  Plots canonical variate scores with confidence ellipses. 
%
% Syntax
%   plotscoresconf(cvx,cvy);
%   plotscoresconf(cvx,cvy,percentconf);
%   plotscoresconf(____,'nofig');
%
% Description
%   plotscoresconf(cvx,cvy) creates a 2-D scatter plot of canonical variate
%   scores. cvx is the canonical variate number to plot on the x-axis,
%   while cvy is the canonical variate number to plot on the y-axis.
%   Ellipses are drawn for all classes at 95% conficence. A new figure
%   window is created.
%
%   plotscoresconf(cvx,cvy,percentconf) Canonical variate scores are plotted
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
%   plotexplainedvariance plotcumexplainedvariance ChiPCAModel
%   ChiSpectralCollection.

% Contact email: alex.henderson@manchester.ac.uk
% Licenced under the GNU General Public License (GPL) version 3
% http://www.gnu.org/copyleft/gpl.html
% Other licensing options are available, please contact Alex for details
% If you use this file in your work, please acknowledge the author(s) in
% your publications. 

% The latest version of this file is available on Bitbucket
% https://bitbucket.org/AlexHenderson/chitoolbox


if (this.numcvs == 1)
    % We can't plot confidence limits on a box plot, so warn the user and
    % drop back to the standard plotscores function
    utilities.warningnobacktrace('Confidence limits are not appropriate for a single canonical variate.');
    this.plotscores(cvx,cvy,varargin{:});
else

titlestub = 'Scores on canonical variates ';
windowtitlestub = titlestub;
axislabelstub = 'score on CV ';
errorcode = 'CHI:ChiPCCVAModel';
errormessagestub = 'Requested canonical variate is out of range. Max CVs = ';

if isempty(this.pca.classmembership)
    err = MException([errorcode,':InputError'], ...
        'This collection has no classmembership. Confidence ellipses cannot be drawn.');
    throw(err);
end

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

argposition = find(cellfun(@(x) strcmpi(x, 'nofig') , varargin));
if argposition
    % Remove the parameter from the argument list
    varargin(argposition) = [];
else
    % No 'nofig' found so create a new figure
    windowtitle = [windowtitlestub, num2str(cvy), ' and ' num2str(cvx)];
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
decplaces = 3;
colours = get(gca,'colororder');

% Check the format of colours
numcolours = size(colours,1);
if (this.pca.classmembership.numuniquelabels > numcolours)
    utilities.warningnobacktrace('There are more groups than colours, the colours will be recycled');
    while (this.pca.classmembership.numuniquelabels > size(colours,1))
        colours = vertcat(colours,colours); %#ok<AGROW>
    end
end

utilities.gscatter(this.scores(:,cvx), this.scores(:,cvy), this.pca.classmembership.labels, 'colours', colours, 'nofig', varargin{:});

%% Draw the confidence ellipses
if ~exist('error_ellipse', 'file')
    utilities.warningnobacktrace('Function ''error_ellipse'' required to draw confidence ellipses. See https://uk.mathworks.com/matlabcentral/fileexchange/4705-error-ellipse');
else
    
    % Draw confidence ellipses at the requested level
    hold on;
    for i = 1:this.pca.classmembership.numuniquelabels
        thisgroupX = this.scores(this.pca.classmembership.labelids == i, cvx);
        thisgroupY = this.scores(this.pca.classmembership.labelids == i, cvy);
        groupmeanX = mean(thisgroupX);
        groupmeanY = mean(thisgroupY);
        groupcov = cov(thisgroupX, thisgroupY);
        h = error_ellipse('C',groupcov,'mu',[groupmeanX,groupmeanY],'conf',percentconf/100);
        h.Color = colours(i,:);
        set(get(get(h,'Annotation'),'LegendInformation'),'IconDisplayStyle','off');
        h.UserData = this.pca.classmembership.uniquelabelat(i);
        
    end
%     newtitle = [thetitle, ' (', num2str(percentconf), '% conf)'];
%     title(newtitle);
    
    axis tight
    hold off;
    
end

%% Labels and titles
xlabel([axislabelstub, num2str(cvx), ' (', num2str(this.explained(cvx),decplaces), '%)']);
ylabel([axislabelstub, num2str(cvy), ' (', num2str(this.explained(cvy),decplaces), '%)']);
title([titlestub, num2str(cvx), ' and ', num2str(cvy), ' (', num2str(this.pcs), ' pcs, ', num2str(percentconf), '% conf)']);

%% Legend
% if ~isempty(this.classmembership)
%     if ismatlab()
%       legend('Location','Best');
%     else
%       legend();
%     end      
% end    

%% Draw lines indicating zero x and y
utilities.draw00axes(axis);

%% Manage data cursor information
plotinfo = struct;
plotinfo.xpointlabel = ['CV ', num2str(cvx)];
plotinfo.ypointlabel = ['CV ', num2str(cvy)];
plotinfo.xdata = this.scores(:,cvx);
plotinfo.ydata = this.scores(:,cvy);
plotinfo.confidence = percentconf;

if ~isempty(this.pca.classmembership)
    plotinfo.pointmembershiplabels = this.pca.classmembership.labels;
end

figurehandle = gcf;
cursor = datacursormode(figurehandle);
set(cursor,'UpdateFcn',{@utilities.datacursor_scores_6sf,this,plotinfo});

end

end % function plotscoresconf
