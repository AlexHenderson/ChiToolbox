function model = randomforest(varargin)

% randomforest  Random forest classification. 
%
% Syntax
%   model = randomforest();
%   model = randomforest(____, 'treebagger');
%   model = randomforest(____, 'trees',numtrees);
%   model = randomforest(____, 'parallel');
%   model = randomforest(____, 'trainingset', trainmask);
%
% Description
%   model = randomforest() performs a random forest (RF) classification on
%   the data. 500 trees are used to build the RF model. If the algorithm is
%   'treebagger', the Parallel Computing Toolbox is available and the data
%   are large, then calculation will utilise parallel processing. model is
%   a ChiMLModel object.
% 
%   model = randomforest(____, 'treebagger') uses the TreeBagger algorithm
%   rather than fitcensemble. 
% 
%   model = randomforest(____, 'trees',numtrees) generates a RF model with
%   numtrees trees. 
%
%   model = randomforest(____, 'parallel') uses a parallel pool with the
%   default number of worker threads. 
%   If the number of trees * the number of spectra is greated than 5
%   million, and a parallel pool is available, it will be used by default
%   to speed up processing.
%   Requires the Parallel Computing Toolbox. Only valid for TreeBagger
%   algorithm, ignored otherwise.
% 
%   model = randomforest(____, 'trainingset', trainmask) uses the true
%   values in trainmask to select the training data for the random forest
%   calculation. Any false values will denote test data. trainmask is a
%   column vector of logicals that is the same size as the data to be
%   classified.
%
% Notes
%   This function requires the Statistics and Machine Learning Toolbox. 
%   The Parallel Computing Toolbox is required for parallel computing. 
%   The data is randomly split 80% training and 20% test, unless a training
%   set is provided.
%   The class sizes are not balanced prior to classification. It is
%   recommended that this be done beforehand. See
%   ChiSpectralCollection.balance for more information.
% 
% Copyright (c) 2018-2019, Alex Henderson.
% Licenced under the GNU General Public License (GPL) version 3.
%
% See also 
%   fitcensemble TreeBagger adaboost ChiMLModel parpool ChiSpectralCollection.balance

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

%% Defaults
useparallel = -1;   % auto configure
numtrees = 500;
alg = 'fitcensemble';

%% User requested parameters
argposition = find(cellfun(@(x) strcmpi(x, 'trees') , varargin));
if argposition
    numtrees = varargin{argposition + 1};
    varargin(argposition + 1) = [];
    varargin(argposition) = [];
end

trainmask = [];
argposition = find(cellfun(@(x) strcmpi(x, 'trainingset') , varargin));
if argposition
    trainmask = varargin{argposition + 1};
    if (length(trainmask) ~= this.numspectra)
        err = MException(['CHI:',mfilename,':InputError'], ...
            'trainmask must be a vector of logical values, the same length as the number of spectra.');
        throw(err);
    end
    if ~islogical(trainmask)
        err = MException(['CHI:',mfilename,':InputError'], ...
            'trainmask must be a vector of logical values, the same length as the number of spectra.');
        throw(err);
    end
    trainmask = utilities.force2col(trainmask);
    varargin(argposition + 1) = [];
    varargin(argposition) = [];
end

argposition = find(cellfun(@(x) strcmpi(x, 'parallel') , varargin));
if argposition
    if ~exist('parpool','file')
        utilities.warningnobacktrace('The Parallel Computing Toolbox is required to use parallel processing.');
        useparallel = false;
    else
        useparallel = true;
    end
    varargin(argposition) = [];
end

argposition = find(cellfun(@(x) strcmpi(x, 'treebagger') , varargin));
if argposition
    algorithm = 'Random Forest (TreeBagger)';
    alg = 'treebagger';
    varargin(argposition) = [];
else
    algorithm = 'Random Forest (fitcensemble)';
end

% Additional arguments are passed directly to the algorithm

%% Determine whether to automatically use the parallel pool
% Need to balance the benefits of using the parallel pool with the time
% taken to start it up and wind it down. 
if ((useparallel == -1) && strcmpi(alg, 'treebagger'))
    % User did not specify use of the pool
    if ((numtrees * this.numspectra) > 5000000)
        % Data seems quite large
        if exist('parpool','file')
            % We have access to the pool
            useparallel = true;
        else 
            useparallel = false;
        end
    else
        useparallel = false;
    end
end

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

%% Open parallel pool
if (useparallel && strcmpi(alg, 'treebagger'))
    poolobj = parpool;
    paroptions = statset('UseParallel',true);
else
    paroptions = statset();
end

%% Perform random forest
switch alg
    case 'treebagger'
        internalmodel = TreeBagger(numtrees,this.data(trainmask,:),trainlabels,'Options',paroptions, varargin{:});
    case 'fitcensemble'
        internalmodel = fitcensemble(this.data(trainmask,:),trainlabels, 'Method','Bag', 'NumLearningCycles',numtrees, varargin{:});
    otherwise
        err = MException(['CHI:',mfilename,':InputError'], ...
            ['Unrecognised algorithm: ', alg]);
        throw(err);
end
modelCompact = internalmodel.compact();

%% Create output so that we can predict the test data using the model built above
prediction = [];
scores = [];
stdevs = [];
correctlyclassified = [];
elapsed = [];
elaspedinseconds = [];
predictiontime = [];
predictionsec = [];

model = ChiMLModel(...
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

%% Assess model performance
predictiontimer = tic();
testdata = this.applymask(testmask);

switch alg
    case 'treebagger'
        temp = model.predict(testdata);
        prediction = temp.labelid;
        scores = temp.scores;
        stdevs = temp.stdevs;
        prediction = str2num(cell2mat(prediction)); %#ok<ST2NM>
    case 'fitcensemble'
        temp = model.predict(testdata);
        prediction = temp.labelid;
        scores = temp.scores;
        stdevs = [];
end
        
correctlyclassified = (prediction == testlabels);
[predictiontime,predictionsec] = tock(predictiontimer);

%% Close parallel pool
% % Just leave the pool open in case we need it again shortly
% if (useparallel && strcmpi(alg, 'treebagger'))
%     delete(poolobj);
% end

%% Stop timer
[elapsed,elaspedinseconds] = tock(modeltimer);

%% Update the output
model.prediction = prediction;
model.scores = scores;
model.stdevs = stdevs;
model.correctlyclassified = correctlyclassified;
model.elapsed = elapsed;
model.elaspedinseconds = elaspedinseconds;
model.predictiontime = predictiontime;
model.predictionsec = predictionsec;

end
