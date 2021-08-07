function varargout = plotspectrumsegmented(this,varargin)

% plotspectrumsegmented  Plots a spectrum in segments. 
%
% Syntax
%   plotspectrumsegmented();
%   plotspectrumsegmented(____,'nofig');
%   plotspectrumsegmented(____,linearity);
%   plotspectrumsegmented(____,'axes',desiredaxes);
%   plotspectrumsegmented(____,'title',titletext);
%   handle = plotspectrumsegmented(____);
%
% Description
%   plotspectrumsegmented() creates a 2-D line plot of the ChiSpectrum
%   object in a new figure window. Lines are plotted in segments.
%
%   plotspectrumsegmented(____,'nofig') plots the segments of the spectrum
%   in the currently active figure window, or creates a new figure if none
%   is available.
%
%   plotspectrumsegmented(____,'linearity', linearity) plots the segments
%   of the spectrum using the linearity defined. Options are 'linear'
%   (default) or 'quadratic'.
%
%   plotspectrumsegmented(____,'axes',desiredaxes) plots the segments of
%   the spectrum in the desiredaxes. Defaults to gca.
% 
%   plotspectrumsegmented(____,'title',titletext) displays titletext as a
%   plot title.
% 
%   handle = plotspectrumsegmented(____) returns a handle to the figure.
%
% Notes
%   Segments are generated when part of the spectrum is removed. Examples
%   of functions that generate segments include removerange and keeprange.
% 
%   Other parameters can be applied to customise the plot. See the MATLAB
%   plot function for more details. 
%
% Copyright (c) 2021, Alex Henderson.
% Licenced under the GNU General Public License (GPL) version 3.
%
% See also 
%   plot ChiSpectrum gca.

% Contact email: alex.henderson@manchester.ac.uk
% Licenced under the GNU General Public License (GPL) version 3
% http://www.gnu.org/copyleft/gpl.html
% Other licensing options are available, please contact Alex for details
% If you use this file in your work, please acknowledge the author(s) in
% your publications. 

% The latest version of this file is available on Bitbucket
% https://bitbucket.org/AlexHenderson/chitoolbox

% varargin management borrowed from here:
% https://uk.mathworks.com/matlabcentral/answers/127878-interpreting-varargin-name-value-pairs


%% Do we want to add a title?
titletext = '';
argposition = find(cellfun(@(x) strcmpi(x, 'title') , varargin));
if argposition
    titletext = varargin{argposition+1};
    % Remove the parameters from the argument list
    varargin(argposition+1) = [];
    varargin(argposition) = [];
end

%% Shape of the x-axis: linear or quadratic
linearity = 'linear';
argposition = find(cellfun(@(x) strcmpi(x, 'linearity') , varargin));
if argposition
    linearity = lower(varargin{argposition+1});
    % Check for incorrect input
    if ~(strcmpi(linearity, 'linear') || strcmpi(linearity, 'quadratic'))
        err = MException(['CHI:',mfilename,':InputError'], ...
            'Options for linearity are ''linear'' or ''quadratic''');
        throw(err);
    end
        
    % Remove the parameters from the argument list
    varargin(argposition+1) = [];
    varargin(argposition) = [];
end

%% Do we need a new figure?
argposition = find(cellfun(@(x) strcmpi(x, 'nofig') , varargin));
if argposition
    % Remove the parameter from the argument list
    varargin(argposition) = [];
else
    % No 'nofig' found so create a new figure
    figure;
end

%% Get required axes
argposition = find(cellfun(@(x) strcmpi(x, 'axes') , varargin));
if argposition
    % Remove the parameters from the argument list
    ax = varargin{argposition+1};
    varargin(argposition + 1) = [];
    varargin(argposition) = [];
else
    ax = gca;
end

%% Do the plotting
handles = utilities.plotsegments(ax,this.xvals,this.data,linearity,varargin{:}); %#ok<NASGU>

%% Prettify plot
utilities.tightxaxis(ax);

if this.reversex
    set(ax,'XDir','reverse');
end
if ~isempty(this.xlabel)
    set(get(ax,'XLabel'),'String',this.xlabel);
end

if isempty(this.ylabel)
    ylab = 'arbitrary units';
else
    ylab = this.ylabel;
end
set(get(ax,'YLabel'),'String',ylab);

% Add a title if requested
if ~isempty(titletext)
    title(titletext)
end

%% Manage data cursor information
figurehandle = gcf;
cursor = datacursormode(figurehandle);
set(cursor,'UpdateFcn',@utilities.datacursor_6sf);

%% Has the user asked for the figure handle?
if nargout
    varargout{1} = gcf();
end

end % function plotspectrum
