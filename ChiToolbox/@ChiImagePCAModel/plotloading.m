function plotloading(this,pc,varargin)

% plotloading  Plots the principal component loading of your choice. 
%
% Syntax
%   plotloading(pc);
%   plotloading(pc,'nofig');
%   plotloading(____,'bar');
%   plotloading(____,'nobkgd');
%   plotloading(____,'alpha',alphavalue);
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
%   plotloading(____,'nobkgd') uses a white background.
%
%   plotloading(____,'alpha',alphavalue) changes the transparency of any
%   background. By default alphavalue == 0.6 which corresponds to 40%
%   transparency. alphavalue must be between 0.0 and 1.0. 
%
%   Other parameters can be applied to customise the plot. See the MATLAB
%   plot/bar functions for more details. 
%
% Copyright (c) 2017-2019, Alex Henderson.
% Licenced under the GNU General Public License (GPL) version 3.
%
% See also 
%   plot bar imagepc plotexplainedvariance plotcumexplainedvariance
%   ChiImagePCAModel ChiImage.

% Contact email: alex.henderson@manchester.ac.uk
% Licenced under the GNU General Public License (GPL) version 3
% http://www.gnu.org/copyleft/gpl.html
% Other licensing options are available, please contact Alex for details
% If you use this file in your work, please acknowledge the author(s) in
% your publications. 

% The latest version of this file is available on Bitbucket
% https://bitbucket.org/AlexHenderson/Chitoolbox


%% Defaults
titlestub = 'Loading on principal component ';
windowtitlestub = titlestub;
ylabelstub = 'loading on PC ';
barplot = false;
usecolouredblocks = true;
alpha = 0.6;

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

%% Parse command line
argposition = find(cellfun(@(x) strcmpi(x, 'nofig') , varargin));
if argposition
    varargin(argposition) = [];
    h = gcf;
else
    % No 'nofig' found so create a new figure
    windowtitle = [windowtitlestub, num2str(pc)];
    h = figure('Name',windowtitle,'NumberTitle','off');
end

argposition = find(cellfun(@(x) strcmpi(x, 'bar') , varargin));
if argposition
    % Remove the parameter from the argument list
    barplot = true;
    usecolouredblocks = false;
    varargin(argposition) = [];
end

argposition = find(cellfun(@(x) strcmpi(x, 'nobkgd') , varargin));
if argposition
    usecolouredblocks = false;
    varargin(argposition) = [];
end

argposition = find(cellfun(@(x) strcmpi(x, 'alpha') , varargin));
if argposition
    alpha = varargin{argposition + 1};
    varargin(argposition + 1) = [];
    varargin(argposition) = [];
end

%% Generate plot
datatoplot = this.loadings(:,pc);

if barplot
    bar(this.xvals, datatoplot, varargin{:});
else
    % Draw a line plot
    plot(this.xvals, datatoplot, varargin{:});
    utilities.tightxaxis;

    if usecolouredblocks
        limits = axis;
        xmin = limits(1,1);
        xmax = limits(1,2);
        ymin = limits(1,3);
        ymax = limits(1,4);
        x = [xmin, xmax, xmax, xmin];

        hold on;
        % Positive loading zone
        y = [0, 0, ymax, ymax];
        patch(x, y, [0,0,1,1], 'FaceColor','interp', 'EdgeColor','none', 'FaceAlpha',alpha);

        % Negative loading zone
        y = [0, 0, ymin, ymin];
        patch(x, y, [0,0,-1,-1], 'FaceColor','interp', 'EdgeColor','none', 'FaceAlpha',alpha);

        cmap = ChiBimodalColormap();
        colormap(h,cmap);

        % Overwrite the original plot to bring it to the front
        plot(this.xvals, datatoplot, 'Color', 'b', varargin{:});
        hold off;
    end
end

if this.reversex
    set(gca,'XDir','reverse');
end

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
