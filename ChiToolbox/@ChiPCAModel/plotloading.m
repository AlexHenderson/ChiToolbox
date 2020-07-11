function plotloading(this,pc,varargin)

% plotloading  Plots the principal component loading of your choice. 
%
% Syntax
%   plotloading(pc);
%   plotloading(pc,'nofig');
%   plotloading(____,'bar');
%
% Description
%   plotloading(pc) creates a 2-D line chart of the principal component
%   pc in a new figure window.
%
%   plotloading(pc,'nofig') plots the loading in the currently active
%   figure window, or creates a new figure if none is available.
% 
%   plotloading(____,'bar') generates a bar plot, rather than a line plot.
%
%   Other parameters can be applied to customise the plot. See the MATLAB
%   plot/bar functions for more details. 
%
% Copyright (c) 2017-2019, Alex Henderson.
% Licenced under the GNU General Public License (GPL) version 3.
%
% See also 
%   plot bar plotscores plotexplainedvariance plotcumexplainedvariance
%   ChiPCAModel ChiSpectralCollection.

% Contact email: alex.henderson@manchester.ac.uk
% Licenced under the GNU General Public License (GPL) version 3
% http://www.gnu.org/copyleft/gpl.html
% Other licensing options are available, please contact Alex for details
% If you use this file in your work, please acknowledge the author(s) in
% your publications. 

% Version 2.0, September 2018
% The latest version of this file is available on Bitbucket
% https://bitbucket.org/AlexHenderson/chitoolbox


%% Error checking
if isempty(this.loadings)
    err = MException(['CHI:',mfilename,':InputError'], ...
        'No loadings are available.');
    throw(err);
end

if ((pc > this.numpcs) || (pc < 1))
    err = MException(['CHI:',mfilename,':InputError'], ...
        ['Requested principal component is out of range. Max PCs = ',utilities.tostring(this.numpcs)]);
    throw(err);
end

titlestub = 'Loading on principal component ';
windowtitlestub = titlestub;
ylabelstub = 'loading on PC ';

barplot = false;

%% Parse command line
argposition = find(cellfun(@(x) strcmpi(x, 'nofig') , varargin));
if argposition
    % Remove the parameter from the argument list
    varargin(argposition) = [];
else
    % No 'nofig' found so create a new figure
    windowtitle = [windowtitlestub, num2str(pc)];
    figure('Name',windowtitle,'NumberTitle','off');
end

argposition = find(cellfun(@(x) strcmpi(x, 'bar') , varargin));
if argposition
    % Remove the parameter from the argument list
    varargin(argposition) = [];
    barplot = true;
end

%% Generate plot
datatoplot = this.loadings(:,pc);
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
ylabel([ylabelstub, num2str(pc), ' (', num2str(this.explained(pc),3), '%)']);
title([titlestub, num2str(pc)]);

%% Manage data cursor information
figurehandle = gcf;
cursor = datacursormode(figurehandle);
set(cursor,'UpdateFcn',{@utilities.datacursor_6sf});    
    
end
