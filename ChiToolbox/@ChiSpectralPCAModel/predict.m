function prediction = predict(varargin)


%% Start timer
predictiontimer = tic();

%% Get this object
this = varargin{1};

%% Identify test data
argposition = find(cellfun(@(x) isa(x,'ChiSpectralCollection') , varargin));
if argposition
    testset = varargin{argposition}.clone;
    varargin(argposition) = [];
else
    argposition = find(cellfun(@(x) isa(x,'ChiSpectrum') , varargin));
    if argposition
        testset = varargin{argposition}.clone;
        varargin(argposition) = [];
    else
        err = MException(['CHI:',mfilename,':InputError'], ...
            'Can only predict ChiSpectra, or ChiSpectralCollections.');
        throw(err);
    end
end

%% Identify number of PCs
pcs = [];
argposition = find(cellfun(@(x) isnumeric(x) , varargin));
if argposition
    pcs = varargin{argposition};
    varargin(argposition) = []; %#ok<NASGU>
end

%% Check we have class membership?
if (isempty(this.classmembership) || isempty(testset.classmembership))
    utilities.warningnobacktrace('These data have no class membership. Only projections will be calculated.');
end

%% Subtract the TRAINING mean from the TEST data
testset.data = testset.data - this.trainingmean.data;

%% Project the test data into the model
% Here we rotate the test data matrix by the same amount that the training
% data was rotated during the original PCA
projectedscores = testset.data * this.loadings;

%% Determine how many PCs make up 95% of the explained variance
if isempty(pcs)
    % Calculate the number of pcs that explain 95% of the variance
    cumpcexplained = cumsum(this.explained);
    pcs = find((cumpcexplained > 95), 1, 'first');
end

%% Make space for results
distances = [];
predictedclass = [];
trueclass = [];
correctlyclassified = [];

%% Only if we have class membership can we determine predicted classes
if ~isempty(this.classmembership)

    % Make space for the results
    distances = zeros(testset.numspectra, this.classmembership.numclasses);

    % Measure the distance of each projected test data point to each class
    for c = 1:this.classmembership.numclasses
        classscores = this.scores((this.classmembership.labelids == c),:);
        distances(:,c) = mahal(projectedscores(:,1:pcs),classscores(:,1:pcs));
    end

    % Determine the predicted class
    [mindist,predictedclass] = min(distances, [], 2); %#ok<ASGLU>
    
    % If we already knew the true labels, we can also calculate the prediction accuracy
    if ~isempty(testset.classmembership)
        trueclass = testset.classmembership.labelids;
        correctlyclassified = (predictedclass == trueclass);
    end
end 

%% Stop timer
[predictiontime,predictionsec] = tock(predictiontimer); %#ok<ASGLU>

%% Generate results
prediction = ChiPCAPrediction(...
                this.clone(), ...
                projectedscores, ...
                pcs, ...
                predictionsec, ...
                distances, ...
                predictedclass, ...
                trueclass, ...
                correctlyclassified ...
            );

prediction.history.add('PCA prediction of unseen data');

end
