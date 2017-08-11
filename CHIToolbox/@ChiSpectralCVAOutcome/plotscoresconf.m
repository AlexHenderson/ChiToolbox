function plotscoresconf(this,cvx,cvy,percentconf,varargin)

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
%   scatter, or gscatter, functions for more details. 
%
% Copyright (c) 2017, Alex Henderson.
% Licenced under the GNU General Public License (GPL) version 3.
%
% See also 
%   scatter gscatter plotscores plotloadings plotexplainedvariance
%   plotcumexplainedvariance ChiSpectralPCAOutcome ChiSpectralCollection.


% Contact email: alex.henderson@manchester.ac.uk
% Licenced under the GNU General Public License (GPL) version 3
% http://www.gnu.org/copyleft/gpl.html
% Other licensing options are available, please contact Alex for details
% If you use this file in your work, please acknowledge the author(s) in
% your publications. 

% Version 1.0, July 2017
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
errorcode = 'CHI:ChiSpectralCVAOutcome';
errormessagestub = 'Requested canonical variate is out of range. Max CVs = ';

colours = 'bgrcmky';
axiscolour = 'k';
decplaces = 3;

if isempty(this.PCAOutcome.classmembership)
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
if ~exist('percentconf','var')
    percentconf = 95;
end

gscatter(this.scores(:,cvx), this.scores(:,cvy), this.PCAOutcome.classmembership.labels, colours, '.',varargin{:});

%% Draw the confidence ellipses
if ~exist('error_ellipse', 'file')
    utilities.warningnobacktrace('Function ''error_ellipse'' required to draw confidence ellipses. See https://uk.mathworks.com/matlabcentral/fileexchange/4705-error-ellipse');
else
    
    % Draw confidence ellipses at the requested level
    hold on;
    colouridx = 0;
    for i = 1:this.PCAOutcome.classmembership.numuniquelabels
        thisgroupX = this.scores(this.PCAOutcome.classmembership.labelids == i, cvx);
        thisgroupY = this.scores(this.PCAOutcome.classmembership.labelids == i, cvy);
        groupmeanX = mean(thisgroupX);
        groupmeanY = mean(thisgroupY);
        groupcov = cov(thisgroupX, thisgroupY);
        colouridx = colouridx + 1;
        if colouridx > length(colours)
            % Wrap the colours if we run out. More than 7 groups
            % seems unlikely though. 
            colouridx = 1;
        end
        h = error_ellipse('C',groupcov,'mu',[groupmeanX,groupmeanY],'conf',percentconf/100, 'style', colours(colouridx));
        set(get(get(h,'Annotation'),'LegendInformation'),'IconDisplayStyle','off');
        
    end
%     newtitle = [thetitle, ' (', num2str(percentconf), '% conf)'];
%     title(newtitle);
    
    axis tight
    hold off;
    
end

%% Labels and titles
xlabel([axislabelstub, num2str(cvx), ' (', num2str(this.explained(cvx),decplaces), '%)']);
ylabel([axislabelstub, num2str(cvy), ' (', num2str(this.explained(cvy),decplaces), '%)']);
title([titlestub, num2str(cvx), ' and ', num2str(cvy), ' (', num2str(percentconf), '% conf)']);


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
h = plot([0,0], [0,ymin], axiscolour);
set(get(get(h,'Annotation'),'LegendInformation'),'IconDisplayStyle','off');
h = plot([0,xmax], [0,0], axiscolour);
set(get(get(h,'Annotation'),'LegendInformation'),'IconDisplayStyle','off');
h = plot([0,xmin], [0,0], axiscolour);
set(get(get(h,'Annotation'),'LegendInformation'),'IconDisplayStyle','off');
axis tight
hold off;


end
end

