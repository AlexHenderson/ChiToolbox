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
% Copyright (c) 2020-2023, Alex Henderson.
% Licenced under the GNU General Public License (GPL) version 3.
%
% See also 
%   scatter plotloadings plotexplainedvariance plotcumexplainedvariance
%   ChiPLSModel ChiSpectralCollection.


% Contact email: alex.henderson@manchester.ac.uk
% Licenced under the GNU General Public License (GPL) version 3
% http://www.gnu.org/copyleft/gpl.html
% Other licensing options are available, please contact Alex for details
% If you use this file in your work, please acknowledge the author(s) in
% your publications. 

% The latest version of this file is available at:
% https://github.com/AlexHenderson/ChiToolbox


titlestub = 'Data block scores on PLS components ';
windowtitlestub = titlestub;
axislabelstub = 'score on PLS ';
errorcode = 'Chi:ChiPLSModel';
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
decplaces = 3;

if ~isempty(this.depvar)
    utilities.scatterformatted(this.xscores(:,compx), this.xscores(:,compy), sizedata, this.depvar.labels, varargin{:});
    c = colorbar;
    c.Label.String = this.depvar.title;
end    

xlabel([axislabelstub, num2str(compx), ' (', num2str(this.xexplained(compx),decplaces), '%)']);
ylabel([axislabelstub, num2str(compy), ' (', num2str(this.xexplained(compy),decplaces), '%)']);
title([titlestub, num2str(compx), ' and ', num2str(compy)]);

%% Draw lines indicating zero x and y
utilities.draw00axes(axis);

%% Manage data cursor information
plotinfo = struct;
plotinfo.xpointlabel = ['PLS ', num2str(compx)];
plotinfo.ypointlabel = ['PLS ', num2str(compy)];
plotinfo.xdata = this.xscores(:,compx);
plotinfo.ydata = this.xscores(:,compy);

if ~isempty(this.classmembership)
    % Convert numeric labels to char
    labels = cellfun(@num2str,num2cell(this.classmembership.labels(:)),'uniformoutput',false);
    % Append the classmembership title
    labelswithtitle = cellfun(@(s)[s,' ',this.depvar.title],labels,'UniformOutput',false);
    % Send to datacursor
    plotinfo.pointmembershiplabels = labelswithtitle;
end

figurehandle = gcf;
cursor = datacursormode(figurehandle);
set(cursor,'UpdateFcn',{@utilities.datacursor_scores_6sf,this,plotinfo});

end % function plotxscores
