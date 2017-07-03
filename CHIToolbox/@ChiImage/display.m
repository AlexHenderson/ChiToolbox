function display(this,varargin)
% display Basic display function

    if ~isempty(this.data)
        imagesc(this.totalimage(),varargin{:});
        if exist('parula.m','file')
            colormap(parula);
        else
            colormap(ChiSequentialColormap());
        end
        axis image;
        axis off;
    end
end
