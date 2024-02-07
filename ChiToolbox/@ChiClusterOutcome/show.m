function varargout = show(varargin)

% show  Generates an image of the cluster data
%
% Syntax
%   show();
%   show('nofig');
%   show(____,'title',titletext);
%   show(____,'cmap',cmap);
%   handle = show(____);
%
% Description
%   show() generates an image of the cluster data.
%
%   show('nofig') shows the image in the currently active figure window,
%   or creates a new figure if none is available.
%
%   show(____,'title',titletext) shows titletext as a plot title.
% 
%   show(____,'cmap',cmap) uses the value of cmap to determine the colours
%   of the clusters. cmap can be the name of a MATLAB colormap for example
%   jet, a string containing the name of a MATLAB colormap for example
%   'hot', or a three-column matrix of RGB triplets.
% 
%   handle = show(____) returns a handle to the figure.
%
% Copyright (c) 2019, Alex Henderson.
% Licenced under the GNU General Public License (GPL) version 3.
%
% See also 
%   imagesc colormap ChiContinuousColormap.

% Contact email: alex.henderson@manchester.ac.uk
% Licenced under the GNU General Public License (GPL) version 3
% http://www.gnu.org/copyleft/gpl.html
% Other licensing options are available, please contact Alex for details
% If you use this file in your work, please acknowledge the author(s) in
% your publications. 

% The latest version of this file is available at:
% https://github.com/AlexHenderson/ChiToolbox


%% Basic error checking
this = varargin{1};
if isempty(this.clusters)
    err = MException(['CHI:',mfilename,':DisplayError'], ...
        'No data to show.');
    throw(err);
end

%% Defaults
    cmap = [];

%% Parse arguments
    % Do we need a new figure?
    argposition = find(cellfun(@(x) strcmpi(x, 'nofig') , varargin));
    if argposition
        % Remove the parameter from the argument list
        varargin(argposition) = [];
    else
        % No 'nofig' found so create a new figure
        figure;
    end
    
    % Do we want to add a title?
    titletext = '';
    argposition = find(cellfun(@(x) strcmpi(x, 'title') , varargin));
    if argposition
        titletext = varargin{argposition+1};
        % Remove the parameters from the argument list
        varargin(argposition+1) = [];
        varargin(argposition) = [];
    end

    % Do we want to specify a colormap?
    argposition = find(cellfun(@(x) strcmpi(x, 'cmap') , varargin));
    if argposition
        cmap = varargin{argposition+1};
        % Remove the parameters from the argument list
        varargin(argposition+1) = [];
        varargin(argposition) = [];
    end

%% Generate the image
    idx = uint8(this.clusters);     % to force direct indexing

    image(idx-1,varargin{2:end});   % direct indexing starts from 0
    axis image;axis off;

    % Build a colormap of correct number of colours
    if isempty(cmap)
        % Use a colour vision deficiency aware colormap
        if exist('parula.m','file')
            cmap = parula(this.numclusters);
        else
            cmap = ChiContinuousColormap(this.numclusters);
        end
    else
        if ischar(cmap)
            commandline = ['cmap = ',cmap,'(this.numclusters);'];
            eval(commandline);
        else
            if ismatrix(cmap)
                hsv = rgb2hsv(cmap);
                cmap = interp1(linspace(0,1,size(cmap,1)),hsv,linspace(0,1,this.numclusters));
                cmap = hsv2rgb(cmap);
            else
                err = MException(['CHI:',mfilename,':DisplayError'], ...
                    'Cannot interpret colormap.');
                throw(err);
            end
        end
    end
    
    colormap(gca,cmap);
    hcbar = colorbar(gca);

    labels = {};    % create labels with cluster numbers
    for i = 1:this.numclusters
        labels = vertcat(labels,{num2str(i)}); %#ok<AGROW>
    end

    ticks = 1:this.numclusters; % create tick marks in between colour bands
    ticks = ticks - 0.5;

    hcbar.Ticks = ticks; 
    hcbar.TickLabels = labels;
    hcbar.Label.String = 'cluster number';
    hcbar.TickLength = 0;    % hide tick marks

    % Add a title if requested
    if ~isempty(titletext)
        title(titletext)
    end

%% Tidy up    
    % Has the user asked for the figure handle?
    if nargout
        varargout{1} = gcf();
    end
    
end
