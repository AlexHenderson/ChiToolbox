function overlay(varargin)

% overlay  Produces a plot with overlaid data.
%
% Syntax
%   overlay(other);
%   overlay(other,'auto');
%
% Description
%   overlay(other) creates a plot of this data with data from other
%   overlaid. other can be any Chi data type. 
% 
%   overlay(other,'auto') autoscales the y-axis.
% 
% Copyright (c) 2019, Alex Henderson.
% Licenced under the GNU General Public License (GPL) version 3.
%
% See also 
%   plot plotyy

% Contact email: alex.henderson@manchester.ac.uk
% Licenced under the GNU General Public License (GPL) version 3
% http://www.gnu.org/copyleft/gpl.html
% Other licensing options are available, please contact Alex for details
% If you use this file in your work, please acknowledge the author(s) in
% your publications. 

% The latest version of this file is available on Bitbucket
% https://bitbucket.org/AlexHenderson/chitoolbox


this = varargin{1};
that = varargin{2};

%% Gather user input
auto = false;
argposition = find(cellfun(@(x) strcmpi(x, 'auto') , varargin));
if argposition
    auto = true;
end

% Legend input currently not used. It's really hard :-(
legendtext = {};
argposition = find(cellfun(@(x) strcmpi(x, 'legend1') , varargin));
if argposition
    legendtext(1) = varargin(argposition+1);
    varargin(argposition+1) = [];
    varargin(argposition) = [];
end
argposition = find(cellfun(@(x) strcmpi(x, 'legend2') , varargin));
if argposition
    legendtext(2) = varargin(argposition+1);
    varargin(argposition+1) = [];
    varargin(argposition) = [];
end

%% Generate the figure
figure;
[ax,h1,h2] = plotyy(this.xvals,this.data, that.xvals,that.data); %#ok<ASGLU>

%% Make x-axis tight
minx = min(this.xvals(1),that.xvals(1));
maxx = max(this.xvals(end),that.xvals(end));
xlim(ax(1), [minx, maxx])
xlim(ax(2), [minx, maxx])

%% Reverse axis if this is reversed
if this.reversex
    set(ax(1),'XDir','reverse');
    set(ax(2),'XDir','reverse');
end

%% Autoscale y-axis if requested
if auto
    ylim(ax(1),'auto')
    ylim(ax(2),'auto')
end

%% Add axis labels
if ~isempty(this.xlabel)
    set(get(gca,'XLabel'),'String',this.xlabel);
end

if isempty(this.ylabel)
    ylab = 'arbitrary units';
else
    ylab = this.ylabel;
end
ax(1).YLabel.String = ylab;

if isempty(that.ylabel)
    ylab = 'arbitrary units';
else
    ylab = that.ylabel;
end
ax(2).YLabel.String = ylab;

%% Legends are REALLY complicated for multiple lines from multiple data sets
% if ~isempty(legendtext)
%     legend(ax(1),legendtext);
% end
% if ~isempty(legendtext)
%     legend(ax(2),legendtext);
% end

%% Warnings if data may be mismatched
if ~strcmpi(class(this),class(that))
    utilities.warningnobacktrace('These data sets may be incompatible.')
end

if ~strcmpi(this.xlabel,that.xlabel)
    utilities.warningnobacktrace('The x-axes of these data sets may not match.')
end
if ~strcmpi(this.ylabel,that.ylabel)
    utilities.warningnobacktrace('The y-axes of these data sets may not match.')
end


end % function overlay
