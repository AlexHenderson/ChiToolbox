function imagesc(this,varargin)
% imagesc Basic imagesc function

    imagesc(this.data,varargin{:});
    colormap(hot);
    axis image;
    axis off;
end        
