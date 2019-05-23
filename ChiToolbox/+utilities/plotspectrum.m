function varargout = plotspectrum(this,varargin)

% plotspectrum  Plots a spectrum. 
%
% Syntax
%   plotspectrum();
%   plotspectrum('nofig');
%   plotspectrum(____,'axes',desiredaxes);
%   plotspectrum(____,'title',titletext);
%   handle = plotspectrum(____);
%
% Description
%   plotspectrum() creates a 2-D line plot of the ChiSpectrum object in a
%   new figure window.
%
%   plotspectrum('nofig') plots the spectra in the currently active
%   figure window, or creates a new figure if none is available.
%
%   plotspectrum(____,'axes',desiredaxes) plots the spectrum in the
%   desiredaxes. Defaults to gca. 
% 
%   plotspectrum(____,'title',titletext) displays titletext as a plot title.
% 
%   handle = plotspectrum(____) returns a handle to the figure.
%
%   Other parameters can be applied to customise the plot. See the MATLAB
%   plot function for more details. 
%
% Copyright (c) 2017-2019, Alex Henderson.
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

% Version 2.0, August 2018
% The latest version of this file is available on Bitbucket
% https://bitbucket.org/AlexHenderson/chitoolbox

% varargin management borrowed from here:
% https://uk.mathworks.com/matlabcentral/answers/127878-interpreting-varargin-name-value-pairs


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

%% Do we want to add a title?
titletext = '';
argposition = find(cellfun(@(x) strcmpi(x, 'title') , varargin));
if argposition
    titletext = varargin{argposition+1};
    % Remove the parameters from the argument list
    varargin(argposition+1) = [];
    varargin(argposition) = [];
end

%% Do the plotting
plot(ax,this.xvals,this.data,varargin{:});

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
