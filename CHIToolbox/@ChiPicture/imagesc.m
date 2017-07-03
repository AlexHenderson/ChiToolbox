function imagesc(this,varargin)
% imagesc Basic imagesc function

    imagesc(this.data,varargin{:});
        if exist('parula.m','file')
            colormap(parula);
        else
            colormap(ChiSequentialColormap());
        end
    axis image;
    axis off;
end        
