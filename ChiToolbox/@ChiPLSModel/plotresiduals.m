function plotresiduals(this,varargin)

% plotresiduals  Plots the difference between the actual dependent variable and the predicted dependent variable. 
%
% Syntax
%   plotresiduals();
%   plotresiduals(____,'nofig');
%   plotresiduals(____,plottype);
%
% Description
%   plotresiduals() creates a barchart showing the residual when the
%   predicted dependent variable is subtracted from the original dependent
%   variable.
% 
%   plotresiduals(____,'nofig') plots the residuals in the currently
%   active figure window, or creates a new figure if none is available.
% 
%   plotresiduals(____,plottype) generates different types of plot: 'bar'
%   for a bar plot, 'stem' for a stem plot, or 'scatter' for a scatter
%   plot.
% 
%   Other parameters can be applied to customise the plot. See the MATLAB
%   bar/stem/scatter functions for more details. 
%
% Copyright (c) 2020, Alex Henderson.
% Licenced under the GNU General Public License (GPL) version 3.
%
% See also 
%   bar stem scatter plotxscores plotweights plotexplainedvariance
%   plotcumexplainedvariance ChiPLSModel ChiSpectralCollection.

% Contact email: alex.henderson@manchester.ac.uk
% Licenced under the GNU General Public License (GPL) version 3
% http://www.gnu.org/copyleft/gpl.html
% Other licensing options are available, please contact Alex for details
% If you use this file in your work, please acknowledge the author(s) in
% your publications. 

% Version 1.0, May 2020
% The latest version of this file is available on Bitbucket
% https://bitbucket.org/AlexHenderson/chitoolbox


%% Error checking
if isempty(this.residuals)
    err = MException(['CHI:',mfilename,':InputError'], ...
        'No residuals are available.');
    throw(err);
end

titletext = ['Residual (', this.depvar.title, ')'];
windowtitle = titletext;
ylabeltext = ['residual (', this.depvar.title, ')'];
xlabeltext = 'spectrum number';

% Defaults
plottype = 'bar';

%% Parse command line
argposition = find(cellfun(@(x) strcmpi(x, 'nofig') , varargin));
if argposition
    % Remove the parameter from the argument list
    varargin(argposition) = [];
else
    % No 'nofig' found so create a new figure
    figure('Name',windowtitle,'NumberTitle','off');
end

argposition = find(cellfun(@(x) strcmpi(x, 'bar') , varargin));
if argposition
    % Remove the parameter from the argument list
    varargin(argposition) = [];
    plottype = 'bar';
end

argposition = find(cellfun(@(x) strcmpi(x, 'stem') , varargin));
if argposition
    varargin(argposition) = [];
    plottype = 'stem';
end

argposition = find(cellfun(@(x) strcmpi(x, 'scatter') , varargin));
if argposition
    varargin(argposition) = [];
    plottype = 'scatter';
end

%% Generate plot
xdatatoplot = 1:size(this.residuals,1);
% xdatatoplot = this.depvar.labels;
ydatatoplot = this.residuals;

switch plottype
    case 'bar'
        bar(xdatatoplot, ydatatoplot, varargin{:});
    case 'scatter'
        scatter(xdatatoplot, ydatatoplot, varargin{:});
    case 'stem'
        stem(xdatatoplot, ydatatoplot, varargin{:});
    otherwise
        bar(xdatatoplot, ydatatoplot, varargin{:});
end

utilities.tightxaxis;
utilities.drawy0axis(axis);

xlabel(xlabeltext);
ylabel(ylabeltext);
title(titletext);

%% Manage data cursor information
figurehandle = gcf;
cursor = datacursormode(figurehandle);
set(cursor,'UpdateFcn',{@utilities.datacursor_plsresiduals,'spectrum number','residual'});    
    
end
