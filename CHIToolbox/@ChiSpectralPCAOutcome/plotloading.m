function plotloading(this,pc,varargin)
% plotloading

    if ~isempty(this.loadings)
        if (pc > this.numpcs)
            err = MException('CHI:ChiSpectralPCAOutcome:OutOfRange', ...
                ['Requested principal component is out of range. Max PCs = ', num2str(this.numpcs), '.']);
            throw(err);
        end
        window_title = ['Loading on PC ', num2str(pc)];
%         figure_handle = figure('Name',window_title,'NumberTitle','off');

        datatoplot = this.loadings(:,pc);

        bar(this.xvals, datatoplot);
        if this.reversex
            set(gca,'XDir','reverse');
        end

        hold on
        xlabel(this.xlabel);
        ylabel(['loading on PC ', num2str(pc), ' (', num2str(this.explained(pc),3), '%)']);
        title(['Loading on principal component ', num2str(pc)]);
        axis tight;
        hold off
    end
end
