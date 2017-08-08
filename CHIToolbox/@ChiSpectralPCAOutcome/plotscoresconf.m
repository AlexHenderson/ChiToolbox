function plotscoresconf(this,pcx,pcy,percentconf,varargin)

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


titlestub = 'Scores on principal components ';
windowtitlestub = titlestub;
axislabelstub = 'score on PC ';
errorcode = 'CHI:ChiSpectralPCAOutcome';
errormessagestub = 'Requested principal component is out of range. Max PCs = ';

colours = 'bgrcmky';
axiscolour = 'k';
decplaces = 3;

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
if ~exist('percentconf','var')
    percentconf = 95;
end

gscatter(this.scores(:,pcx), this.scores(:,pcy), this.classmembership.labels, colours, '.',varargin{:});

%% Draw the confidence ellipses
if ~exist('error_ellipse', 'file')
    utilities.warningnobacktrace('Function ''error_ellipse'' required to draw confidence ellipses. See https://uk.mathworks.com/matlabcentral/fileexchange/4705-error-ellipse');
else
    
    % Draw confidence ellipses at the requested level
    hold on;
    colouridx = 0;
    for i = 1:this.classmembership.numuniquelabels
        thisgroupX = this.scores(this.classmembership.labelids == i, pcx);
        thisgroupY = this.scores(this.classmembership.labelids == i, pcy);
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
h = plot([0,0], [0,ymin], axiscolour);
set(get(get(h,'Annotation'),'LegendInformation'),'IconDisplayStyle','off');
h = plot([0,xmax], [0,0], axiscolour);
set(get(get(h,'Annotation'),'LegendInformation'),'IconDisplayStyle','off');
h = plot([0,xmin], [0,0], axiscolour);
set(get(get(h,'Annotation'),'LegendInformation'),'IconDisplayStyle','off');
axis tight
hold off;


end

