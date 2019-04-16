function output = confusion(this,whichFold)

% Confusion matrix

    if ~exist('whichFold','var')
        % output all the folds
        numLabels = this.folds{1, 1}.pccvaResult.PCAOutcome.classmembership.numuniquelabels;
        output = zeros(numLabels,numLabels,this.numfolds);
        
        for k = 1:this.numfolds
            output(:,:,k) = this.folds{k}.confusionMatrix;
        end
    else
        output = this.folds{whichFold}.confusionMatrix;
    end
    
end
