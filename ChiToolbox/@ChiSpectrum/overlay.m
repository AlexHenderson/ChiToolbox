function overlay(varargin)

% overlay  Produces a plot with overlaid data.
%
% Syntax
%   overlay(other);
%   overlay(____,'legend1',legend1text','legend2',legend2text');
%   overlay(____,'offset',offset);
%
% Description
%   overlay(other) creates a plot of this data with data from other
%   overlaid. other can be any Chi data type. 
% 
%   overlay(____,'legend1',legend1text','legend2',legend2text') generates a
%   legend for the plot where legend1text applies to the left axis and
%   legend2text applies to the right axis. 
% 
%   overlay(____,'offset',offset) produces a plot where the spectra are
%   plotted with the value of offset being added to other.
% 
% Copyright (c) 2019, Alex Henderson.
% Licenced under the GNU General Public License (GPL) version 3.
%
% See also 
%   plot overlay legend plotyy

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
% auto = false;
% argposition = find(cellfun(@(x) strcmpi(x, 'auto') , varargin));
% if argposition
%     auto = true;
%     varargin(argposition) = [];
% end
% 
% tight = false;
% argposition = find(cellfun(@(x) strcmpi(x, 'tight') , varargin));
% if argposition
%     tight = true;
%     varargin(argposition) = [];
% end
% 
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

% Is an offset requested
offset = 0;
argposition = find(cellfun(@(x) strcmpi(x, 'offset') , varargin));
if argposition
    offset = varargin{argposition+1};
    varargin(argposition+1) = [];
    varargin(argposition) = []; %#ok<NASGU>
end

%% Generate the figure
figure;

yyaxis left
if (isprop(this,'iscentroided') && this.iscentroided)
    [stickx,sticky] = utilities.stickify(this.xvals,this.data);
    plot(stickx,sticky);
else    
    plot(this.xvals,this.data);
end

yyaxis right
if (isprop(that,'iscentroided') && that.iscentroided)
    [stickx,sticky] = utilities.stickify(that.xvals,that.data);
    plot(stickx,(sticky + offset));
else    
    plot(that.xvals,(that.data + offset));
end

%% Make x-axis tight
utilities.tightxaxis(gca);

%% Reverse axis if this is reversed
if this.reversex
    set(gca,'XDir','reverse');
end

%% Autoscale y-axis if requested
% if auto
%     ylim(gca,'auto')
% end

%% Mange scaling if an offset is used
if offset
    yyaxis left
    leftlims = ylim;
    yyaxis right
    rightlims = ylim;
    
    miny = min(leftlims(1),rightlims(1));
    maxy = max(leftlims(2),rightlims(2));
    
    yyaxis left
    ylim([miny,maxy]);
    yyaxis right
    ylim([miny,maxy]);
end

%% Add axis labels
if ~isempty(this.xlabel)
    set(get(gca,'XLabel'),'String',this.xlabel);
end

yyaxis left
if isempty(this.ylabel)
    ylab = 'arbitrary units';
else
    ylab = this.ylabel;
end
set(get(gca,'YLabel'),'String',ylab);

yyaxis right
if isempty(that.ylabel)
    ylab = 'arbitrary units';
else
    ylab = that.ylabel;
end
if (offset ~= 0)
    ylab = ([ylab, ' (including an offset of ', num2str(offset) ,')']);
end

set(get(gca,'YLabel'),'String',ylab);

%% Add a legend if requested
if ~isempty(legendtext)
    legend(gca,legendtext,'Location','best');
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


end % function overlay
