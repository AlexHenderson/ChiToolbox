function display(this,varargin) %#ok<DISPLAY>
% display Basic display function

    if ~isempty(this.data)
        plot(this.xvals,this.data,varargin{:});
        axis tight;
        if this.reversex
            set(gca,'XDir','reverse');
        end
        if ~isempty(this.xlabel)
            set(get(gca,'XLabel'),'String',this.xlabel);
        end
        if ~isempty(this.ylabel)
            set(get(gca,'YLabel'),'String',this.ylabel);
        end
    end
end
