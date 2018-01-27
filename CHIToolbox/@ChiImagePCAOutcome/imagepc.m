function imagepc(this, pc, varargin)

% ToDo: handle masked data

%% Do we need a new figure?
argposition = find(cellfun(@(x) strcmpi(x, 'nofig') , varargin));
if argposition
    % Remove the parameter from the argument list
    varargin(argposition) = [];
else
    % No 'nofig' found so create a new figure
    figure;
end


    if ~isempty(this.loadings)
        if (pc > this.numpcs)
            err = MException('CHI:ChiImagePCAOutcome:OutOfRange', ...
                ['Requested principal component is out of range. Max PCs = ', num2str(this.numpcs), '.']);
            throw(err);
        end

        invert = false;
        normalise = true;
        % ToDo: fix masked data
        toplot = reshape(this.scores,this.height,this.width,this.numpcs);
        pc_to_plot = toplot(:,:,pc);

        % window_title = ['PC ', int2str(pc)];
        figure_title = ['Score on principal component ', int2str(pc)];

        if invert
            pc_to_plot = pc_to_plot * -1;
        %     window_title = [window_title, ' (inverted)'];
            figure_title = [figure_title, ' (inverted)'];
        end
        % handle = figure('Name',window_title,'NumberTitle','off');

        if normalise
            pc_to_plot = this.normscores(pc_to_plot);
        end

        imagesc(pc_to_plot,varargin{:});
        axis image;

        title(figure_title);
        set(gca,'XTickLabel','');
        set(gca,'YTickLabel','');
        colorbar;        
        
        colormap(ChiBimodalColormap());
    end

end

