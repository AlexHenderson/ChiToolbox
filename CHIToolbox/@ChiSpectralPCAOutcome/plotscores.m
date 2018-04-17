function plotscores(this,pcx,pcy,varargin)

% plotscores  Plots principal component scores of your choice. 
%
% Syntax
%   plotscores(pcx,pcy);
%   plotscores(pcx,pcy,'nofig');
%
% Description
%   plotscores(pcx,pcy) creates a 2-D scatter plot of principal component
%   scores. pcx is the principal component number to plot on the x-axis,
%   while pcy is the principal component number to plot on the y-axis. A
%   new figure window is created.
%
%   plotscores(pcx,pcy,'nofig') plots the scores in the currently active
%   figure window, or creates a new figure if none is available.
%
%   Other parameters can be applied to customise the plot. See the MATLAB
%   scatter, or gscatter, functions for more details. 
%
% Notes
%   If the object has classmembership available, the scores will be plotted
%   in colours relating to their class using the gscatter function.
%
% Copyright (c) 2017, Alex Henderson.
% Licenced under the GNU General Public License (GPL) version 3.
%
% See also 
%   scatter gscatter plotloadings plotexplainedvariance
%   plotcumexplainedvariance ChiSpectralPCAOutcome ChiSpectralCollection.


% Contact email: alex.henderson@manchester.ac.uk
% Licenced under the GNU General Public License (GPL) version 3
% http://www.gnu.org/copyleft/gpl.html
% Other licensing options are available, please contact Alex for details
% If you use this file in your work, please acknowledge the author(s) in
% your publications. 

% Version 1.0, July 2017
% The latest version of this file is available on Bitbucket
% https://bitbucket.org/AlexHenderson/Chitoolbox

titlestub = 'Scores on principal components ';
windowtitlestub = titlestub;
axislabelstub = 'score on PC ';
errorcode = 'Chi:ChiSpectralPCAOutcome';
errormessagestub = 'Requested principal component is out of range. Max PCs = ';

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

% colours = 'bgrcmky';
colours = get(gca,'colororder');
axiscolour = 'k';
decplaces = 3;

if ~isempty(this.classmembership)
    nan.inst.gscatter(this.scores(:,pcx), this.scores(:,pcy), this.classmembership.labels, colours, '.',varargin{:});
else
    scatter(this.scores(:,pcx), this.scores(:,pcy), '.',varargin{:});
end    

xlabel([axislabelstub, num2str(pcx), ' (', num2str(this.explained(pcx),decplaces), '%)']);
ylabel([axislabelstub, num2str(pcy), ' (', num2str(this.explained(pcy),decplaces), '%)']);
title([titlestub, num2str(pcx), ' and ', num2str(pcy)]);

% if ~isempty(this.classmembership)
%     if ismatlab()
%       legend('Location','Best');
%     else
%       legend();
%     end      
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

