function plotweight(this,comp,varargin)

% plotweight  Plots the partial least squares component weight of your choice. 
%
% Syntax
%   plotweight(comp);
%   plotweight(comp,'nofig');
%   plotweight(____,'bar');
%
% Description
%   plotweight(comp) creates a 2-D line chart of the partial least squares
%   component weight in a new figure window. Percentage explained variance
%   of this component in the data block is shown in parentheses. 
%
%   plotweight(comp,'nofig') plots the component weight in the currently
%   active figure window, or creates a new figure if none is available.
% 
%   plotweight(____,'bar') generates a bar plot, rather than a line plot.
%
%   Other parameters can be applied to customise the plot. See the MATLAB
%   plot/bar functions for more details. 
%
% Copyright (c) 2020, Alex Henderson.
% Licenced under the GNU General Public License (GPL) version 3.
%
% See also 
%   plot bar plotxscores plotexplainedvariance plotcumexplainedvariance
%   ChiPLSModel ChiSpectralCollection.

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
if isempty(this.weights)
    err = MException(['CHI:',mfilename,':InputError'], ...
        'No weights are available.');
    throw(err);
end

if ((comp > this.ncomp) || (comp < 1))
    err = MException(['CHI:',mfilename,':InputError'], ...
        ['Requested PLS component is out of range. Max comps = ',utilities.tostring(this.ncomp)]);
    throw(err);
end

titlestub = 'Weighting on PLS component ';
windowtitlestub = titlestub;
ylabelstub = 'weighting on PLS ';

barplot = false;

%% Parse command line
argposition = find(cellfun(@(x) strcmpi(x, 'nofig') , varargin));
if argposition
    % Remove the parameter from the argument list
    varargin(argposition) = [];
else
    % No 'nofig' found so create a new figure
    windowtitle = [windowtitlestub, num2str(comp)];
    figure('Name',windowtitle,'NumberTitle','off');
end

argposition = find(cellfun(@(x) strcmpi(x, 'bar') , varargin));
if argposition
    % Remove the parameter from the argument list
    varargin(argposition) = [];
    barplot = true;
end

%% Generate plot
datatoplot = this.weights(:,comp);
if barplot
    bar(this.xvals, datatoplot, varargin{:});
else
    plot(this.xvals, datatoplot, varargin{:});
end

if this.reversex
    set(gca,'XDir','reverse');
end

utilities.tightxaxis;

if ~barplot
    utilities.drawy0axis(axis);
end

xlabel(this.xlabel);        
ylabel([ylabelstub, num2str(comp), ' (', num2str(this.xexplained(comp),3), '%)']);
title([titlestub, num2str(comp)]);

%% Manage data cursor information
figurehandle = gcf;
cursor = datacursormode(figurehandle);
set(cursor,'UpdateFcn',{@utilities.datacursor_6sf});    
    
end
