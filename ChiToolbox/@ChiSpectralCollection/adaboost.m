function result = adaboost(varargin)

% adaboost  Adaptive Boosting classification. 
%
% Syntax
%   result = adaboost();
%   result = adaboost(____, 'iterations',iters);
%   result = adaboost(____, 'trainingset', trainmask);
%   result = adaboost(____, Name, Value);
%
% Description
%   result = adaboost() performs an adaptive boosting (adaboost)
%   classification on the data. 500 iterations are used to build the model.
%   Results are returned in a ChiMLModel object.
% 
%   result = adaboost(____, 'iterations',iters) generates a model with
%   iters iterations. 
%
%   result = adaboost(____, 'trainingset', trainmask) uses the true values
%   in trainmask to select the training data for the classification. Any
%   false values will denote test data. trainmask is a column vector of
%   logicals that is the same size as the data to be classified.
%
%   result = adaboost(____, Name, Value) Name Value pairs that are passed
%   directly to the AdaBoost algorithm. See fitcensemble for details.
%
% Notes
%   This function requires the Statistics and Machine Learning Toolbox. 
%   The data is randomly split 80% training and 20% test, unless a training
%   set is provided.
%   The class sizes are not balanced prior to classification. It is
%   recommended that this be done beforehand. See
%   ChiSpectralCollection.balance for more information.
%   If the data has two unique classes the AdaBoost.M1 algorithm is used.
%   For three or more classes the AdaBoost.M2 algorithm is used. 
% 
% Copyright (c) 2019, Alex Henderson.
% Licenced under the GNU General Public License (GPL) version 3.
%
% See also 
%   fitcensemble randomforest ChiMLModel ChiSpectralCollection.balance

% Contact email: alex.henderson@manchester.ac.uk
% Licenced under the GNU General Public License (GPL) version 3
% http://www.gnu.org/copyleft/gpl.html
% Other licensing options are available, please contact Alex for details
% If you use this file in your work, please acknowledge the author(s) in
% your publications. 

% The latest version of this file is available on Bitbucket
% https://bitbucket.org/AlexHenderson/chitoolbox


%% Do we have the machine learning toolbox
if ~exist('fitcensemble','file')
    err = MException(['CHI:',mfilename,':InputError'], ...
        'The Statistics and Machine Learning Toolbox is required for this function.');
    throw(err);
end

%% Define this object
this = varargin{1};
varargin(1) = [];

%% Need class membership
if isempty(this.classmembership)
    err = MException(['CHI:',mfilename,':InputError'], ...
        'No class membership is available. This is required for classification methods.');
    throw(err);
end

if (this.classmembership.numclasses < 2)
    err = MException(['CHI:',mfilename,':InputError'], ...
        'Not enough classes available for classification.');
    throw(err);
end

%% Defaults
numiterations = 500;

%% User requested parameters
argposition = find(cellfun(@(x) strcmpi(x, 'iterations') , varargin));
if argposition
    numiterations = varargin{argposition + 1};
    varargin(argposition + 1) = [];
    varargin(argposition) = [];
end

trainmask = [];
argposition = find(cellfun(@(x) strcmpi(x, 'trainingset') , varargin));
if argposition
    trainmask = varargin{argposition + 1};
    if ~islogical(trainmask)
        err = MException(['CHI:',mfilename,':InputError'], ...
            'trainmask must be a vector of logical values, the same length as the number of spectra.');
        throw(err);
    end
    if (length(trainmask) ~= this.numspectra)
        err = MException(['CHI:',mfilename,':InputError'], ...
            'trainmask must be a vector of logical values, the same length as the number of spectra.');
        throw(err);
    end
    trainmask = utilities.force2col(trainmask);
    varargin(argposition + 1) = [];
    varargin(argposition) = []; 
end

% Additional arguments are passed directly to the algorithm

%% Start timer
modeltimer = tic;

%% Stratify 5 fold: 1 to test, 4 (pooled) to train
% There is a better way to do this, but I can't remember what it is

if isempty(trainmask)

    k = 5;
    partition = cvpartition(this.classmembership.labelids,'kfold',k);

    folds = false(this.numspectra,k);

    for i = 1:k
        folds(:,i) = test(partition,i);
    end

    trainmask = any(folds(:,1:4),2);
end

trainlabels = this.classmembership.labelids(trainmask);

testmask = ~trainmask;
testlabels = this.classmembership.labelids(testmask);

%% Perform AdaBoost
switch this.classmembership.numclasses
    case 2
        % Develop a binary model
        model = fitcensemble(this.data(trainmask,:),trainlabels, 'Method','AdaBoostM1', 'NumLearningCycles',numiterations, varargin{:});
        algorithm = 'AdaBoost.M1';
    otherwise
        % Develop a multi-class model
        model = fitcensemble(this.data(trainmask,:),trainlabels, 'Method','AdaBoostM2', 'NumLearningCycles',numiterations, varargin{:});
        algorithm = 'AdaBoost.M2';
end
modelCompact = model.compact();

%% Assess model performance
predictiontimer = tic();
% [prediction,scores,stdevs] = predict(modelCompact,this.data(testmask,:));
[prediction,scores] = predict(modelCompact,this.data(testmask,:));
stdevs = [];
% prediction = str2num(cell2mat(prediction)); %#ok<ST2NM>
correctlyclassified = (prediction == testlabels);
[predictiontime,predictionsec] = tock(predictiontimer);

%% Stop timer
[elapsed,elaspedinseconds] = tock(modeltimer);

%% Write output
result = ChiMLModel(...
                    trainmask, ...
                    testmask, ...
                    algorithm, ...
                    modelCompact, ...
                    prediction, ...
                    scores, ...
                    stdevs, ...
                    correctlyclassified, ...
                    this.classmembership.clone(), ...
                    elapsed,...
                    elaspedinseconds,...
                    predictiontime,...
                    predictionsec...
                    );

end
