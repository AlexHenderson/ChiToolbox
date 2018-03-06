function output = confusionmatrix(this,foldnumber)
%CONFUSIONMATRIX Summary of this function goes here
%   Detailed explanation goes here

fold = this.folds{foldnumber};
output = fold.confusionMatrix;


end

