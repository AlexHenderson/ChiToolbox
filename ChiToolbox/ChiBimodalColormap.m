function [map,previouscolormap] = ChiBimodalColormap(levels)

previouscolormap = colormap;

magentablackgreen = [[1 0 1];...
                     [0 0 0];...
                     [0 1 0]];

if (nargin < 1)
    levels = 256;
end

map = interp1(linspace(0,1,size(magentablackgreen,1)),magentablackgreen,linspace(0,1,levels));
