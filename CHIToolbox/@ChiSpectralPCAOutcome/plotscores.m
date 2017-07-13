function plotscores(this,pc_x,pc_y,varargin)

% plotscores  Plots principal component scores of your choice. 
%
% Syntax
%   plotscores(pc_x,pc_y);
%   plotscores(pc_x,pc_y,'nofig');
%
% Description
%   plotscores(pc_x,pc_y) creates a 2-D scatter plot of principal component
%   scores. pc_x is the principal component number to plot on the x-axis,
%   while pc_y is the principal component number to plot on the y-axis. A
%   new figure window is created.
%
%   plotscores(pc_x,pc_y,'nofig') plots the scores in the currently active
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
%   plotcumexplainedvariance CHiSpectralPCAOutcome ChiSpectralCollection.


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
axislabelstub = 'score on PC ';
errorcode = 'CHI:ChiSpectralPCAOutcome';
errormessagestub = 'Requested principal component is out of range. Max PCs = ';

colours = 'bgrcmky';
axiscolour = 'k';
decplaces = 3;

if ((pc_x > this.numpcs) || (pc_x < 1))
    err = MException(errorcode, ...
        [errormessagestub, num2str(this.numpcs), '.']);
    throw(err);
end
if ((pc_y > this.numpcs) || (pc_y < 1))
    err = MException(errorcode, ...
        [errormessagestub, num2str(this.numpcs), '.']);
    throw(err);
end

argposition = find(cellfun(@(x) strcmpi(x, 'nofig') , varargin));
if argposition
    % Remove the parameter from the argument list
    varargin(argposition) = [];
else
    % No 'nofig' found so create a new figure
    windowtitle = [windowtitlestub, num2str(pc_y), ' and ' num2str(pc_x)];
    figure('Name',windowtitle,'NumberTitle','off');
end    

if ~isempty(this.classmembership)
    gscatter(this.scores(:,pc_x), this.scores(:,pc_y), this.classmembership.labels, colours, '.',varargin{:});
else
    scatter(this.scores(:,pc_x), this.scores(:,pc_y), '.',varargin{:});
end    

xlabel([axislabelstub, num2str(pc_x), ' (', num2str(this.explained(pc_x),decplaces), '%)']);
ylabel([axislabelstub, num2str(pc_y), ' (', num2str(this.explained(pc_y),decplaces), '%)']);
title([titlestub, num2str(pc_x), ' and ', num2str(pc_y)]);

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

