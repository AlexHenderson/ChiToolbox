function plotloading(this,cv,varargin)
% plotcvloading

    titlestub = 'Loading on canonical variate ';
    windowtitlestub = titlestub;
    ylabelstub = 'loading on CV ';
    errorcode = 'CHI:ChiSpectralCVAOutcome';
    errormessagestub = 'Requested canonical variate is out of range. Max CVs = ';

    if ~isempty(this.loadings)
        if ((cv > this.cvs) || (cv < 1))
            err = MException(errorcode, ...
                [errormessagestub, num2str(this.numcvs), '.']);
            throw(err);
        end

        argposition = find(cellfun(@(x) strcmpi(x, 'nofig') , varargin));
        if argposition
            % Remove the parameter from the argument list
            varargin(argposition) = [];
        else
            % No 'nofig' found so create a new figure
            windowtitle = [windowtitlestub, num2str(cv)];
            figure('Name',windowtitle,'NumberTitle','off');
        end
        
        datatoplot = this.loadings(:,cv);
        bar(this.xvals, datatoplot, varargin{:});
        if this.reversex
            set(gca,'XDir','reverse');
        end
        axis tight;
        xlabel(this.xlabel);        
        ylabel([ylabelstub, num2str(cv), ' (', num2str(this.explained(cv),3), '%)']);
        title([titlestub, num2str(cv)]);
        
    end
end
