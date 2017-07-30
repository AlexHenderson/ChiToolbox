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
%   Other parameters can be applied to customise the plot. See the MATLAB
%   gscatter function for more details. 
%
% Copyright (c) 2017, Alex Henderson.
% Licenced under the GNU General Public License (GPL) version 3.
%
% See also 
%   gscatter plotloadings plotexplainedvariance plotpcloadings
%   plotpcexplainedvariance plotpccumexplainedvariance
%   ChiSpectralPCAOutcome ChiSpectralCollection.


% Contact email: alex.henderson@manchester.ac.uk
% Licenced under the GNU General Public License (GPL) version 3
% http://www.gnu.org/copyleft/gpl.html
% Other licensing options are available, please contact Alex for details
% If you use this file in your work, please acknowledge the author(s) in
% your publications. 

% Version 1.0, July 2017
% The latest version of this file is available on Bitbucket
% https://bitbucket.org/AlexHenderson/chitoolbox


titlestub = 'Scores on canonical variates ';
windowtitlestub = titlestub;
axislabelstub = 'score on CV ';
errorcode = 'CHI:ChiSpectralCVAOutcome';
errormessagestub = 'Requested canonical variate is out of range. Max CVs = ';

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

colours = 'bgrcmky';
axiscolour = 'k';
decplaces = 3;


gscatter(this.scores(:,cvx), this.scores(:,cvy), this.PCAOutcome.classmembership.labels, colours, '.',varargin{:});

xlabel([axislabelstub, num2str(cvx), ' (', num2str(this.explained(cvx),decplaces), '%)']);
ylabel([axislabelstub, num2str(cvy), ' (', num2str(this.explained(cvy),decplaces), '%)']);
title([titlestub, num2str(cvx), ' and ', num2str(cvy), ' (',num2str(this.pcs), ' pcs)']);

% if ismatlab()
%   legend('Location','Best');
% else
%   legend();
% end      

% Draw lines indicating zero x and y
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

