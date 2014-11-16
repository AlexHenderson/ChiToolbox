function display(this,varargin)
% display Basic display function

    imagesc(this.data,varargin{:});
    colormap(hot);
    axis image;
    axis off;
end
