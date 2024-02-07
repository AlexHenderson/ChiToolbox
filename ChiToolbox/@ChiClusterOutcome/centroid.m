function varargout = centroid(this,whichk,varargin)

% centroid  Generates an image of the cluster data
%
% Syntax
%   centroid();
%   centroid(____,'cmap',cmap);
%   handle = centroid(____);
%
% Description
%   centroid() generates an image of the cluster data.
%
%   centroid(____,'cmap',cmap) uses the value of cmap to determine the colours
%   of the clusters. cmap can be the name of a MATLAB colormap for example
%   jet, a string containing the name of a MATLAB colormap for example
%   'hot', or a three-column matrix of RGB triplets.
% 
%   handle = centroid(____) returns a handle to the figure.
%
% Copyright (c) 2020, Alex Henderson.
% Licenced under the GNU General Public License (GPL) version 3.
%
% See also 
%   ChiSpectrum colormap ChiContinuousColormap.

% Contact email: alex.henderson@manchester.ac.uk
% Licenced under the GNU General Public License (GPL) version 3
% http://www.gnu.org/copyleft/gpl.html
% Other licensing options are available, please contact Alex for details
% If you use this file in your work, please acknowledge the author(s) in
% your publications. 

% The latest version of this file is available at:
% https://github.com/AlexHenderson/ChiToolbox


%% Basic error checking
if isempty(this.clusters)
    err = MException(['CHI:',mfilename,':DisplayError'], ...
        'No data to centroid.');
    throw(err);
end

%% Defaults
    cmap = [];

%% Parse arguments
%     % Do we need a new figure?
%     argposition = find(cellfun(@(x) strcmpi(x, 'nofig') , varargin));
%     if argposition
%         % Remove the parameter from the argument list
%         varargin(argposition) = [];
%     else
%         % No 'nofig' found so create a new figure
%         figure;
%     end
    
%     % Do we want to add a title?
%     titletext = '';
%     argposition = find(cellfun(@(x) strcmpi(x, 'title') , varargin));
%     if argposition
%         titletext = varargin{argposition+1};
%         % Remove the parameters from the argument list
%         varargin(argposition+1) = [];
%         varargin(argposition) = [];
%     end

    % Do we want to specify a colormap?
    argposition = find(cellfun(@(x) strcmpi(x, 'cmap') , varargin));
    if argposition
        cmap = varargin{argposition+1};
        % Remove the parameters from the argument list
        varargin(argposition+1) = [];
        varargin(argposition) = [];
    end
    
%% Generate the colour palette    
    cmap = this.colours('cmap',cmap);

%% Generate the image
    handle = this.centroids.spectrumat(whichk).plot('color',cmap(whichk,:),varargin{:});

%     % Add a title if requested
%     if ~isempty(titletext)
%         title(titletext)
%     end

%% Tidy up    
    % Has the user asked for the figure handle?
    if nargout
        varargout{1} = handle;
    end
    
end
