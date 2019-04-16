function [map,previouscolormap] = ChiSequentialColormap(levels)

previouscolormap = colormap;

if exist('levels','var')
    map = viridis(levels);
else
    map = viridis();
end    

end
