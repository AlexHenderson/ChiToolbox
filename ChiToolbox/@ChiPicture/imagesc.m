function varargout = imagesc(varargin)

% imagesc  Displays the data as an image that uses the full range of colors in the colormap
%
% Syntax
%   imagesc();
%   imagesc('nofig');
%   imagesc(____,'axes',desiredaxes);
%   imagesc(____,'title',titletext);
%   handle = imagesc(____);
%
% Description
%   imagesc() displays the data as an image that uses the full range of
%   colors in the colormap
% 
%   imagesc('nofig') displays the image in the currently active figure
%   window, or creates a new figure if none is available.
%
%   imagesc(____,'axes',desiredaxes) displays the image in the desiredaxes.
%   Defaults to gca.
% 
%   imagesc(____,'title',titletext) displays titletext as an image title.
% 
%   handle = imagesc(____) returns a handle to this figure.
% 
%   Other parameters can be applied to customise the image. See the MATLAB
%   imagesc function for more details. 
% 
% Notes
%   If the data is bimodal, the ChiBimodalColormap is used. Otherwise, if
%   the parula colormap is available it is used. If parula is not available
%   the ChiSequentialColormap is used. 
% 
% Copyright (c) 2018-2019, Alex Henderson.
% Licenced under the GNU General Public License (GPL) version 3.
%
% See also 
%   imagesc gca parula ChiBimodalColormap ChiSequentialColormap.

% Contact email: alex.henderson@manchester.ac.uk
% Licenced under the GNU General Public License (GPL) version 3
% http://www.gnu.org/copyleft/gpl.html
% Other licensing options are available, please contact Alex for details
% If you use this file in your work, please acknowledge the author(s) in
% your publications. 

% The latest version of this file is available on Bitbucket
% https://bitbucket.org/AlexHenderson/chitoolbox


    this = varargin{1};
    
    % Do we need a new figure?
    argposition = find(cellfun(@(x) strcmpi(x, 'nofig') , varargin));
    if argposition
        % Remove the parameter from the argument list
        varargin(argposition) = [];
    else
        % No 'nofig' found so create a new figure
        figure;
    end

    % Get required axes
    argposition = find(cellfun(@(x) strcmpi(x, 'axes') , varargin));
    if argposition
        % Remove the parameters from the argument list
        ax = varargin{argposition+1};
        varargin(argposition + 1) = [];
        varargin(argposition) = [];
    else
        ax = gca;
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
    
    % Generate the figure
    if nargout
        varargout{:} = imagesc(ax,this.data,varargin{2:end});
    else
        imagesc(ax,this.data,varargin{2:end});
    end
    axis(ax,'image');
    axis(ax,'off');
    
    % Use an appropriate colormap
    if this.bimodal
        colormap(ChiBimodalColormap());
    else        
        if exist('parula.m','file')
            colormap(parula);
        else
            colormap(ChiSequentialColormap());
        end
    end
    
    % Add a title if requested
    if ~isempty(titletext)
        title(titletext)
    end
    
    % Has the user asked for the figure handle?
    if nargout
        varargout{1} = gcf();
    end
    
end        
