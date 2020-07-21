function [output,kfold_pccva_result] = ChiKFoldPCCVA(data,numFolds,pcs)

% function: ChiKFoldPCCVA
%           k-fold cross-validation using PC-CVA
% version:  2.0
% usage:
%           kfold_pccva_result = ChiKFoldPCCVA(data, numFolds, classMembership);
%           kfold_pccva_result = ChiKFoldPCCVA(data, numFolds, classMembership, pcs);
%
% where:
%   data - a collection of spectra in rows
%   numFolds - the number of folds to calculate (k)
%   classMembership - a list of the specific class membership of each row.
%       This can be numbers, strings, or a cell array, one per row. 
%   pcs - the appropriate number of pcs to use. If not provided, the
%       number is determined from the entire data set by selecting the
%       number of pcs that first exceed 95% explained variance.
%       More advanced methods are available, using pressrsstest.m for
%       example. (optional)
%
%   kfold_pccva_result - a cell array containing the following:
%     uniqueClassNames - a list of the names of the classes
%     classMembershipId - a numeric list of the class membership for each
%       spectrum
%     numUniqueClasses - number of classes
%     numFolds - the number of folds requested
%     partitions - a cvpartition object containing the memberships of each
%       fold
%     pcs - the number of principal components used in the CVA calculation
%     percentageCorrectlyClassifiedPerFold - percentage of correctly
%       classified test samples for each fold (columns)and each class (rows).
%     if numUniqueClasses == 2 we also have:
%       sensitivities - sensitivity for each fold
%       specificities - specificity for each fold 
%       percentageSensitivities - percentage sensitivity for each fold
%       percentageSpecificities - percentage specificity for each fold
%     folds - a cell array, one for each fold, each containing a struct
%       with the following fields:
%       trainingSet - the spectra used to train the model
%       trainingClassIds - the class membership for each of the training
%         set spectra
%       testSet - the spectra used to test the model
%       testClassIds - the class membership for each of the test set
%         spectra
%       pccva - a struct containing the following fields:
%         pcloadings - the loadings produced from principal components
%           analysis (PCA) of the training set
%         pcscores - the scores weighting of each PC for each spectrum in the
%           training set
%         pcexplained - the percentage explained variance of each PC in the
%         training set
%         pcs - the number of principal components used in the canonical
%         variates analysis (CVA) calculation
%         cvloadings - the loadings produced from canonical variates analysis
%         (CVA)of the PC scores
%         cvscores - the scores weighting of each canonical variate for each
%         PC
%         cvexplained - the percentage explained variance of each CV
%         cvs - the number of groups used in the CVA calculation
%         (numUniqueClasses -1)
%         cveigenvectors - the eigenvectors produced in the CVA calculation
%         cveigenvalues - the eigenvalues produced in the CVA calculation
%       projection - the location in CVA scores space of the projected test
%         spectra
%       distances - the Mahalanobis distance of each test spectrum to each of
%         the class distributions
%       nearest - the classMembershipId of the class to which each test
%         spectrum is predicted to belong
%       correctlyClassified - a logical list of whether the test spectra were
%         correctly classified into the class they are known to belong to
%       confusionMatrix - a confusion matrix for this classification outcome.
%         Columns relate to known class membership (truth), rows relate to
%         the prediction of the model
%       percentageCorrectlyClassifiedPerFold - the percentage of each class
%         that were correctly classified
%       metrics - a struct containing the following parameters calculated
%         from the confusion matrix (contingency table). This is available
%         only if numUniqueClasses == 2
%           true_positive_rate
%           false_positive_rate
%           sensitivity
%           specificity
%           precision
%           recall
%           positive_predictive_value
%           F_measure
% 
%   DO NOT USE AUTOSCALED DATA. 
%   THE PROJECTION OF TEST DATA INTO THE CVA-SPACE DOESN'T HANDLE IT.
%
%   k-fold cross-validation is sampling without replacement. It can be
%   considered as either a multiple holdout, or a coarse leave-one-out
%   cross-validation approach. 
%
%   If we have N spectra we randomly apportion these across k collections
%   (folds), such that no spectrum appears in more than one fold. We now
%   have k collections of spectra. For each collection we take that
%   collection as a test set and pool the remaining collections to form
%   a training set. PC-CVA is then performed and the results noted. Next
%   we move to the second collection and take that as a test set, pooling
%   all other collections as a training set. Once all collections have
%   acted as a test set we have k results and these can then be averaged
%   and their standard deviation, or variance, measured.
%
%   This routine uses stratification to generate the folds. There will be
%   an error if a class is not represented in the training or test sets.
%
%   A model is generated using the training data and requested number of
%   principal components followed by canonical variates analysis. The
%   test set is projected into the model and the Mahalanobis distance of
%   each test spectrum from each group centre is calculated. Correct
%   classification is when a test spectrum has the smallest distance to the
%   group it should (a priori) be a member of. Incorrect classification is
%   when it is nearer to a different group. The actual distance isn't
%   considered, only the magnitude of the distance. 
%   This is repeated numfolds times (k). 
%
%   Copyright (c) 2012-2017, Alex Henderson 
%   Contact email: alex.henderson@manchester.ac.uk
%   Licenced under the GNU General Public License (GPL) version 3
%   http://www.gnu.org/copyleft/gpl.html
%   Other licensing options are available, please contact Alex for details
%   If you use this file in your work, please acknowledge the author(s) in
%   your publications. 

%   version 2.0 June 2017
%    Modified to incorporate many of the functions into a single function
%    The outputs are now in a cell array of structures, one per fold
%    Plotting has been removed
%    The class names have been converted to numbers to simplify the unique
%    statements. This was a problem when using cell arrays. Therefore we
%    only need the names (or other identifiers for each class), rather than
%    both a name and an identifier
%    Number of pcs is calculated automatically if not provided
%    Added deprecation handling for princomp
%    Name of function changed to kfoldpccva
%   version 1.0 April 2012, 
%    initial release

%% Get numeric identifiers for each class
[uniqueClassNames,uniqueClassIds,classMembershipId] = unique(data.classmembership.labels, 'rows');
numUniqueClasses = length(uniqueClassIds);

%% Create space for outputs and record global information
kfold_pccva_result = struct;

kfold_pccva_result.uniqueClassNames = uniqueClassNames;
kfold_pccva_result.classMembershipId = classMembershipId;
kfold_pccva_result.numUniqueClasses = numUniqueClasses;
kfold_pccva_result.numFolds = numFolds;

folds = cell(numFolds,1);

%% Stratify the data across the number of folds
cvpartitions = cvpartition(data.classmembership.labels, 'KFold', numFolds);

kfold_pccva_result.partitions = cvpartitions;

%% Determine the number of pcs to use, if not provided
% Need to use the same number of pcs for each fold, so calculate using the
% entire data set. 
% Valid PCs determined by the number required to reach 95% explained
% variance, or using the user defined number.

if ~exist('pcs','var')
    pca = ChiSpectralPCA(data);
    cumulative_explained_variance = cumsum(pca.explained);

    % Determine valid PCs
    pcs = find((cumulative_explained_variance > 95), 1, 'first');
end

kfold_pccva_result.pcs = pcs;

%% Train and test each fold
for k = 1:numFolds
    foldInfo = struct;
    
    %% Isolate the data for this fold
    trainingMask = training(cvpartitions,k);
    trainingSet = data.data(trainingMask,:);
    classMembershipId = data.classmembership.labelids;
    trainingClassIds = classMembershipId(trainingMask);

    testMask = test(cvpartitions,k);
    testSet = data.data(testMask,:);
    testClassIds = classMembershipId(testMask);
    
    %% Mean center
    % Mean center the training set
    trainingMean = mean(trainingSet);
    trainingSet = trainingSet - repmat(trainingMean, size(trainingSet,1), 1);
    % Now remove the TRAINING mean from the TEST data
    % This is to ensure that the test data is rotated about the same origin
    % as the test data during the projection phase. 
    testSet = testSet - repmat(trainingMean, size(testSet,1), 1);
    
    foldInfo.trainingSet = trainingSet;
    foldInfo.trainingClassIds = trainingClassIds;
    foldInfo.testSet = testSet;
    foldInfo.testClassIds = testClassIds;
    
    %% PCCVA of the training set
%     [cvloadings,cvscores,cvexplained,cvs,pcloadings,pcscores,pcexplained,pcs,cveigenvectors,cveigenvalues] = pccva(trainingSet,trainingClassIds,pcs);

    pccvaResult = data.pccva(pcs);
    
    foldInfo.pccva = pccvaResult;

%     foldInfo.pccva.pcloadings = pcloadings;
%     foldInfo.pccva.pcscores = pcscores;
%     foldInfo.pccva.pcexplained = pcexplained;
%     foldInfo.pccva.pcs = pcs;
%     foldInfo.pccva.cvloadings = cvloadings;
%     foldInfo.pccva.cvscores = cvscores;
%     foldInfo.pccva.cvexplained = cvexplained;
%     foldInfo.pccva.cvs = cvs;
%     foldInfo.pccva.cveigenvectors = cveigenvectors;
%     foldInfo.pccva.cveigenvalues = cveigenvalues;
    
    %% Project the test data into the model
    pcProjection = testSet * pccvaResult.pca.loadings;
    cvProjection = pcProjection * pccvaResult.eigenvectors * diag(pccvaResult.eigenvalues);

    foldInfo.projection = cvProjection;

    %% Measure the distance of each projected test data point to each class
    foldDistances = zeros(size(testSet,1), numUniqueClasses);

    for i = 1:numUniqueClasses
        classcvscores = pccvaResult.scores((trainingClassIds == i), :);
        foldDistances(:,i) = mahal(cvProjection, classcvscores);
    end
    
    foldInfo.distances = foldDistances;

    [mindist,foldNearest] = min(foldDistances, [], 2); %#ok<ASGLU>
    foldCorrectlyClassified = (foldNearest == testClassIds);

    foldInfo.nearest = foldNearest;
    foldInfo.correctlyClassified = foldCorrectlyClassified;
    
    %% Generate confusion matrix
    % Columns are truth, rows are predictions
    confusionMatrix = zeros(numUniqueClasses);
    for currentclass = 1:numUniqueClasses
        classresult = foldNearest(testClassIds == currentclass);
        [classid, counts] = utilities.countclasses(classresult,(1:numUniqueClasses)'); %#ok<ASGLU>
        confusionMatrix(:,currentclass) = counts;
    end
    
    foldInfo.confusionMatrix = confusionMatrix;
    
    %% Calculate percentage correct classification for this fold
    percentCorrectlyClassified = 100 * (diag(confusionMatrix)' ./ sum(confusionMatrix))';
    
    foldInfo.percentCorrectlyClassified = percentCorrectlyClassified;
    
    %% If we have a 2-class problem we can calculate additional parameters
    if (numUniqueClasses == 2)
        % Taken from Pattern Recognition Letters 27 (2006) 861–874
        % https://doi.org/10.1016/j.patrec.2005.10.010
        
        % cm = TP FP
        %      FN TN
        TP = confusionMatrix(1,1);
        FP = confusionMatrix(1,2);
        FN = confusionMatrix(2,1); %#ok<NASGU>
        TN = confusionMatrix(2,2); %#ok<NASGU>
        numP = sum(confusionMatrix(:,1));
        numN = sum(confusionMatrix(:,2));
        
        true_positive_rate = TP / numP; % TP / TP + FN
        false_positive_rate = FP / numN; % FP / FP + TN
        sensitivity = true_positive_rate;
        specificity = 1 - false_positive_rate; % TN / (FP + TN)
        precision = TP / (TP + FP);
        recall = true_positive_rate;
        positive_predictive_value = precision;
        F_measure = 2 / ((1/precision) + (1/recall));

        foldInfo.metrics.true_positive_rate = true_positive_rate;
        foldInfo.metrics.false_positive_rate = false_positive_rate;
        foldInfo.metrics.sensitivity = sensitivity;
        foldInfo.metrics.specificity = specificity;
        foldInfo.metrics.precision = precision;
        foldInfo.metrics.recall = recall;
        foldInfo.metrics.positive_predictive_value = positive_predictive_value;
        foldInfo.metrics.F_measure = F_measure;
    end
        
    %% Save the data for this fold
    folds{k} = foldInfo;

end

%% Calculate some global metrics
percentageCorrectlyClassified = zeros(numUniqueClasses,numFolds);
for i = 1:numFolds
    percentageCorrectlyClassified(:,i) = folds{i}.percentCorrectlyClassified;
end

kfold_pccva_result.percentageCorrectlyClassifiedPerFold = percentageCorrectlyClassified;

%% If we have a 2-class problem we can calculate additional parameters
if (numUniqueClasses == 2)
    sensitivities = zeros(numFolds,1);
    specificities = zeros(numFolds,1);
    for i = 1:numFolds
        sensitivities(i) = folds{i}.metrics.sensitivity;
        specificities(i) = folds{i}.metrics.specificity;
    end

    kfold_pccva_result.sensitivities = sensitivities;
    kfold_pccva_result.specificities = specificities;
    kfold_pccva_result.percentageSensitivities = sensitivities * 100;
    kfold_pccva_result.percentageSpecificities = specificities * 100;
end

%% Collect the information from each fold into the global output
kfold_pccva_result.folds = folds;

output = ChiKFoldOutcome(folds);
