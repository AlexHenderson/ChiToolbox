function output = percentcc(this,whichFold)

% Percentage correctly classified

    if ~exist('whichFold','var')
        % output all the folds
        numLabels = this.folds{1, 1}.pccvaResult.PCAOutcome.classmembership.numuniquelabels;
        output = zeros(numLabels,this.numfolds);
        for k = 1:this.numfolds
            output(:,k) = this.folds{k}.percentCorrectlyClassified;
        end
    else
        output = this.folds{whichFold}.percentCorrectlyClassified;
    end
    
end
