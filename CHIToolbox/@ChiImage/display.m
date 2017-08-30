function display(this,varargin)
% display Basic display function

%% Do we need a new figure?
argposition = find(cellfun(@(x) strcmpi(x, 'nofig') , varargin));
if argposition
    % Remove the parameter from the argument list
    varargin(argposition) = [];
else
    % No 'nofig' found so create a new figure
    figure;
end

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
