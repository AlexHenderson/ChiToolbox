function plotxscores(this,compx,compy,varargin)

% plotxscores  Plots partial least squares data block scores of your choice. 
%
% Syntax
%   plotxscores(compx,compy);
%   plotxscores(compx,compy,'nofig');
%
% Description
%   plotxscores(compx,compy) creates a 2-D scatter plot of PLS data block
%   scores. compx is the PLS component number to plot on the x-axis, while
%   compy is the PLS component number to plot on the y-axis. Note that
%   these components are all from the X-block (the independent variable
%   block, rather than the dependent (Y) block). A new figure window is
%   created.
%
%   plotxscores(compx,compy,'nofig') plots the scores in the currently
%   active figure window, or creates a new figure if none is available.
%
%   Other parameters can be applied to customise the plot. See the MATLAB
%   scatter function for more details. 
%
% Notes
%   If the object has classmembership available, the scores will be plotted
%   in colours relating to their class using the utilities.gscatter
%   function.
%
% Copyright (c) 2020, Alex Henderson.
% Licenced under the GNU General Public License (GPL) version 3.
%
% See also 
%   scatter plotloadings plotexplainedvariance plotcumexplainedvariance
%   ChiSpectralPLSOutcome ChiSpectralCollection.


% Contact email: alex.henderson@manchester.ac.uk
% Licenced under the GNU General Public License (GPL) version 3
% http://www.gnu.org/copyleft/gpl.html
% Other licensing options are available, please contact Alex for details
% If you use this file in your work, please acknowledge the author(s) in
% your publications. 

% The latest version of this file is available on Bitbucket
% https://bitbucket.org/AlexHenderson/Chitoolbox


titlestub = 'Data block scores on PLS components ';
windowtitlestub = titlestub;
axislabelstub = 'score on PLS ';
errorcode = 'Chi:ChiSpectralPLSOutcome';
errormessagestub = 'Requested PLS component is out of range. Max = ';

% Some defaults
sizedata = [];

if ((compx > this.ncomp) || (compx < 1))
    err = MException([errorcode,':OutOfRange'], ...
        [errormessagestub, num2str(this.ncomp), '.']);
    throw(err);
end
if ((compy > this.ncomp) || (compy < 1))
    err = MException([errorcode,':OutOfRange'], ...
        [errormessagestub, num2str(this.ncomp), '.']);
    throw(err);
end

argposition = find(cellfun(@(x) strcmpi(x, 'nofig') , varargin));
if argposition
    % Remove the parameter from the argument list
    varargin(argposition) = [];
else
    % No 'nofig' found so create a new figure
    windowtitle = [windowtitlestub, num2str(compx), ' and ' num2str(compy)];
    figure('Name',windowtitle,'NumberTitle','off');
end    

% sizedata
argposition = find(cellfun(@(x) isnumeric(x) , varargin));
if argposition
    sizedata = varargin{argposition};
    varargin(argposition) = [];
end

% colours = 'bgrcmky';
axiscolour = 'k';
decplaces = 3;

if ~isempty(this.depvar)
    scatter(this.xscores(:,compx), this.xscores(:,compy), sizedata, this.depvar.labels, varargin{:});
    c = colorbar;
    c.Label.String = this.depvar.title;
end    

xlabel([axislabelstub, num2str(compx), ' (', num2str(this.xexplained(compx),decplaces), '%)']);
ylabel([axislabelstub, num2str(compy), ' (', num2str(this.xexplained(compy),decplaces), '%)']);
title([titlestub, num2str(compx), ' and ', num2str(compy)]);

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

%% Manage data cursor information
% figurehandle = gcf;
% cursor = datacursormode(figurehandle);
% if ~isempty(this.classmembership)
%     labels = this.classmembership.labels;
%     if isnumeric(labels)
%         labels = num2str(labels);
%     end
%     plotinfo.linelabels = cellstr(labels);
% 
%     set(cursor,'UpdateFcn',{@utilities.datacursor,this,plotinfo});
% end
end

