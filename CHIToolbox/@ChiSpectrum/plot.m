function plot(this,varargin)
% Basic plot function
% Copyright (c) 2014 Alex Henderson (alex.henderson@manchester.ac.uk)

    plot(this.xvals,this.data,varargin{:});
    axis tight;
    if (this.reversex)
        set(gca,'XDir','reverse');
    end
    if (~isempty(this.xlabel))
        set(get(gca,'XLabel'),'String',this.xlabel);
    end
    if (~isempty(this.ylabel))
        set(get(gca,'YLabel'),'String',this.ylabel);
    end
end
