function [map,previouscolormap] = ChiContinuousColormap(levels)

previouscolormap = colormap;

if exist('levels','var')
    map = viridis(levels);
else
    map = viridis();
end    

end
