function plotcvloading(this,cv,varargin)
% plotloading

    if ~isempty(this.cvloadings)
        if (cv > this.cvs)
            err = MException('CHI:ChiSpectralCVAOutcome:OutOfRange', ...
                ['Requested canonical variate out of range. Max CVs = ', num2str(this.numcvs), '.']);
            throw(err);
        end
        window_title = ['Loading on CV ', num2str(cv)];
%         figure_handle = figure('Name',window_title,'NumberTitle','off');

        datatoplot = this.cvloadings(:,cv);

        bar(this.PCAOutcome.xvals, datatoplot);
        if this.PCAOutcome.reversex
            set(gca,'XDir','reverse');
        end

        hold on
        xlabel(this.PCAOutcome.xlabel);
        ylabel(['loading on CV ', num2str(cv), ' (', num2str(this.cvexplained(cv),3), '%)']);
        title(['Loading on canonical variate ', num2str(cv)]);
        axis tight;
        hold off
    end
end
