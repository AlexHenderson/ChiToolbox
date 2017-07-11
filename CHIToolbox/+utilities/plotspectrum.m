function plotspectrum(this,varargin)
%plotspectrum Plots one or more spectra
%   Creates a new figure window unless 'nofig' is passed as a parameter


% varargin management borrowed from here:
% https://uk.mathworks.com/matlabcentral/answers/127878-interpreting-varargin-name-value-pairs
argposition = find(cellfun(@(x) strcmpi(x, 'nofig') , varargin));
if argposition
    % Remove the parameter from the argument list
    varargin(argposition) = [];
else
    % No 'nofig' found so create a new figure
    figure;
end

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

