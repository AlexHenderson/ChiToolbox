function varargout = display(this,varargin)

% display Basic display function

if ~isempty(this.data)

    % Do we need a new figure?
    argposition = find(cellfun(@(x) strcmpi(x, 'nofig') , varargin));
    if argposition
        % Remove the parameter from the argument list
        varargin(argposition) = [];
    else
        % No 'nofig' found so create a new figure
        figure;
    end

    % Has the user asked for the figure handle?
    if nargout
        varargout{1} = gcf();
    end
    
    % Generate the image
    imagesc(this.totalimage(),varargin{:});
    if exist('parula.m','file')
        colormap(parula);
    else
        colormap(ChiSequentialColormap());
    end
    axis image;
    axis off;
    
else
    err = MException(['CHI:',mfilename,':DisplayError'], ...
        'No data to display.');
    throw(err);
end
    
    
end
