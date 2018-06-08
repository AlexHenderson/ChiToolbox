function result = randomforest(varargin)

% randomforest  Random forest classification. 
%
% Syntax
%   result = randomforest();
%   result = randomforest(____, 'trees',numtrees);
%   result = randomforest(____, 'parallel');
%
% Description
%   result = randomforest() performs a random forest (RF) classification on
%   the data. 500 trees are used to build the RF model. If the Parallel
%   Computing Toolbox is available and the data are large, then calculation
%   will utilise parallel processing. Results are returned in a
%   ChiRFOutcome object.
% 
%   result = randomforest(____, 'trees',numtrees) generates a RF model with
%   numtrees trees. 
%
%   result = randomforest(____, 'parallel') uses a parallel pool with the
%   default number of worker threads. Requires the Parallel Computing
%   Toolbox.
%
% Notes
%   This function requires the Statistics and Machine Learning Toolbox. 
%   The Parallel Computing Toolbox is required for parallel computing. 
%   The data is randomly split 80% training and 20% test. 
%   The class sizes are not balanced prior to classification. It is
%   recommended that this be done beforehand. See
%   ChiSpectralCollection.balance for more information.
% 
% Copyright (c) 2018, Alex Henderson.
% Licenced under the GNU General Public License (GPL) version 3.
%
% See also 
%   TreeBagger parpool ChiSpectralCollection.balance

% Contact email: alex.henderson@manchester.ac.uk
% Licenced under the GNU General Public License (GPL) version 3
% http://www.gnu.org/copyleft/gpl.html
% Other licensing options are available, please contact Alex for details
% If you use this file in your work, please acknowledge the author(s) in
% your publications. 

% The latest version of this file is available on Bitbucket
% https://bitbucket.org/AlexHenderson/chitoolbox


%% Do we have the machine learning toolbox
if ~exist('TreeBagger','file')
    err = MException(['CHI:',mfilename,':InputError'], ...
        'The Statistics and Machine Learning Toolbox is required for this function.');
    throw(err);
end

%% Define this object
this = varargin{1};

%% Defaults
useparallel = -1;   % auto configure
numtrees = 500;

%% User requested parameters
argposition = find(cellfun(@(x) strcmpi(x, 'trees') , varargin));
if argposition
    numtrees = varargin(argposition + 1);
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

%% Determine whether to automatically use the parallel pool
% Need to balance the benefits of using the parallel pool with the time
% taken to start it up and wind it down. 
if useparallel == -1
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
tic;

%% Stratify 5 fold: 1 to test, 4 (pooled) to train
% There is a better way to do this, but I can't remember what it is
k = 5;
partition = cvpartition(this.classmembership.labelids,'kfold',k);

folds = false(this.numspectra,k);

for i = 1:k
    folds(:,i) = test(partition,i);
end

trainmask = any(folds(:,1:4),2);
trainlabels = this.classmembership.labelids(trainmask);

testmask = logical(folds(:,5));
testlabels = this.classmembership.labelids(testmask);

%% Open parallel pool
if useparallel
    poolobj = parpool;
    paroptions = statset('UseParallel',true);
else
    paroptions = statset();
end

%% Perform random forest
model = TreeBagger(numtrees,this.data(trainmask,:),trainlabels,'Options',paroptions);
modelCompact = model.compact();

%% Assess model performance
[prediction,scores,stdevs] = predict(modelCompact,this.data(testmask,:));
prediction = str2num(cell2mat(prediction)); %#ok<ST2NM>
correctlyclassified = (prediction == testlabels);

%% Close parallel pool
if useparallel
    delete(poolobj);
end

%% Stop timer
[elapsed,elaspedinseconds] = tock;

%% Write output
result = ChiRFOutcome(...
                    trainmask, ...
                    testmask, ...
                    numtrees, ...
                    modelCompact, ...
                    prediction, ...
                    scores, ...
                    stdevs, ...
                    correctlyclassified, ...
                    this.classmembership.clone(), ...
                    elapsed,...
                    elaspedinseconds);

end
