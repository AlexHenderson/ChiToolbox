function plotyy(varargin)

% plotyy  Produces a plot with overlaid data.
%
% Syntax
%   plotyy(other);
%   plotyy(other,'auto');
%   plotyy(____,'legend1',legend1text','legend2',legend2text');
%
% Description
%   plotyy(other) creates a plot of this data with data from other
%   overlaid. other can be any Chi data type. 
% 
%   plotyy(other,'auto') autoscales the y-axis.
% 
%   plotyy(____,'legend1',legend1text','legend2',legend2text') generates a
%   legend for the plot where legend1text applies to the left axis and
%   legend2text applies to the right axis. 
% 
% Copyright (c) 2019, Alex Henderson.
% Licenced under the GNU General Public License (GPL) version 3.
%
% See also 
%   plot plotyy overlay legend

% Contact email: alex.henderson@manchester.ac.uk
% Licenced under the GNU General Public License (GPL) version 3
% http://www.gnu.org/copyleft/gpl.html
% Other licensing options are available, please contact Alex for details
% If you use this file in your work, please acknowledge the author(s) in
% your publications. 

% The latest version of this file is available on Bitbucket
% https://bitbucket.org/AlexHenderson/chitoolbox


%% Version check
% Recommend using overlay, that implements yyaxis, if MATLAB version is
% recent enough
v = version('-release');
v = str2num(v(1:4)); %#ok<ST2NM>
if (v > 2015)
    utilities.warningnobacktrace('Using overlay rather than plotyy may produce better results.');
end

%% Define data
this = varargin{1};
that = varargin{2};

%% Gather user input
auto = false;
argposition = find(cellfun(@(x) strcmpi(x, 'auto') , varargin));
if argposition
    auto = true;
    varargin(argposition) = [];
end

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
    varargin(argposition) = []; %#ok<NASGU>
end

%% Generate the figure
figure;

trace1 = this.clone;
trace2 = that.clone;
if (isprop(trace1,'iscentroided') && trace1.iscentroided)
    [trace1.xvals,trace1.data] = utilities.stickify(trace1.xvals,trace1.data);
end
if (isprop(trace2,'iscentroided') && trace2.iscentroided)
    [trace2.xvals,trace2.data] = utilities.stickify(trace2.xvals,trace2.data);
end
[ax,h1,h2] = plotyy(trace1.xvals,trace1.data, trace2.xvals,trace2.data); %#ok<ASGLU>

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

%% Add a legend if requested
if ~isempty(legendtext)
    legend(ax(1),legendtext,'Location','best');
end

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


end % function plotyy
