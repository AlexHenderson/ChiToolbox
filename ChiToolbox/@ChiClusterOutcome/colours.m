function varargout = colours(varargin)

% colours  Generates an image of the cluster data
%
% Syntax
%   colours();
%   colours('cmap',cmap);
%   handle = colours(____);
%
% Description
%   colours() generates a colormap to display the clusters.
%
%   colours('cmap',cmap) uses the value of cmap to determine the colours
%   of the clusters. cmap can be the name of a MATLAB colormap for example
%   jet, a string containing the name of a MATLAB colormap for example
%   'hot', or a three-column matrix of RGB triplets.
% 
%   handle = colours(____) returns a handle to the figure.
%
% Copyright (c) 2020, Alex Henderson.
% Licenced under the GNU General Public License (GPL) version 3.
%
% See also 
%   colormap ChiContinuousColormap.

% Contact email: alex.henderson@manchester.ac.uk
% Licenced under the GNU General Public License (GPL) version 3
% http://www.gnu.org/copyleft/gpl.html
% Other licensing options are available, please contact Alex for details
% If you use this file in your work, please acknowledge the author(s) in
% your publications. 

% The latest version of this file is available on Bitbucket
% https://bitbucket.org/AlexHenderson/chitoolbox


%% Basic error checking
this = varargin{1};
if isempty(this.clusters)
    err = MException(['CHI:',mfilename,':DisplayError'], ...
        'No clusters available.');
    throw(err);
end

%% Defaults
    cmap = [];

%% Parse arguments
    % Do we want to specify a colormap?
    argposition = find(cellfun(@(x) strcmpi(x, 'cmap') , varargin));
    if argposition
        cmap = varargin{argposition+1};
        % Remove the parameters from the argument list
        varargin(argposition+1) = [];
        varargin(argposition) = [];
    end

%% Generate the image
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
    
%% Tidy up    
    % Has the user asked for the colours?
    if nargout
        varargout{1} = cmap;
    end
    
end
