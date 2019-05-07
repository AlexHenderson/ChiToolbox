function [cmap,previouscolormap] = ChiBimodalColormap(varargin)

% ChiBimodalColormap  Produces a magenta/green colormap.
%
% Syntax
%   [cmap,previouscolormap] = ChiBimodalColormap();
%   [____] = ChiBimodalColormap(____, 'levels',numlevels);
%   [____] = ChiBimodalColormap(____, 'root',rootvalue);
%
% Description
%   [cmap,previouscolormap] = ChiBimodalColormap() develops a colormap in
%   cmap that runs from magenta through black to green with 256 levels
%   and where each is the cube root of the linear value (rootvalue == 3).
%   previouscolormap is the previous colormap :-)
% 
%   [____] = ChiBimodalColormap(____, 'levels',numlevels) produces a
%   colormap with numlevels.
%
%   [____] = ChiBimodalColormap(____, 'root',rootvalue) uses rootvalue to
%   determine the nth root.
% 
% Notes
%   Initially a colormap is produced where there is a linear drop in
%   magenta, from 1 to 0 at the halfway point, whereupon it continues at 0.
%   Green is initially 0 until the halfway point then it increases linearly
%   to 1. Example: 
%     figure; plot(ChiBimodalColormap('root',1)); axis tight
%   
%   For principal components analysis, the main usage of a bimodal
%   colormap, many of the values are around the midpoint. Therefore, the
%   images appears very dark. Here we use the cube root of the colormap to
%   reduce the darkness of the values near the midpoint and therefore
%   enhance the differences in the data. Now there is no longer a linear
%   relationship between colour and intensity (principal component score),
%   but the images are more easily visualised. Example:
%     figure; plot(ChiBimodalColormap()); axis tight
% 
%   The choice of magenta and green is to assist those users with red/green
%   colour visual deficiency, sometimes called colour blindness. 
% 
% Copyright (c) 2014-2019, Alex Henderson.
% Licenced under the GNU General Public License (GPL) version 3.
%
% See also 
%   colormap nthroot.

% Contact email: alex.henderson@manchester.ac.uk
% Licenced under the GNU General Public License (GPL) version 3
% http://www.gnu.org/copyleft/gpl.html
% Other licensing options are available, please contact Alex for details
% If you use this file in your work, please acknowledge the author(s) in
% your publications. 

% The latest version of this file is available on Bitbucket
% https://bitbucket.org/AlexHenderson/chitoolbox


%% Defaults
levels = 256;
root = 3;

%% Parse command line
if nargin
    if isnumeric(varargin{1})
        err = MException(['CHI:',mfilename,':InputError'], ...
            ['The syntax for ', mfilename', 'has changed. See help for details']);
        throw(err);
    end

    argposition = find(cellfun(@(x) strcmpi(x, 'levels') , varargin));
    if argposition
        levels = varargin{argposition + 1};
        varargin(argposition+1) = [];
        varargin(argposition) = [];
    end
    
    argposition = find(cellfun(@(x) strcmpi(x, 'root') , varargin));
    if argposition
        root = varargin{argposition + 1};
        varargin(argposition+1) = [];
        varargin(argposition) = [];
    end

    if ~isempty(varargin)
        err = MException(['CHI:',mfilename,':InputError'], ...
            'Some parameters wer not interpreted.');
        throw(err);
    end
end

%% Produce the colormap
previouscolormap = colormap;

magentablackgreen = [[1 0 1];...
                     [0 0 0];...
                     [0 1 0]];

cmap = interp1(linspace(0,1,size(magentablackgreen,1)),magentablackgreen,linspace(0,1,levels));

%% Take the nth root
cmap = nthroot(cmap,root);

end % function ChiBimodalColormap
