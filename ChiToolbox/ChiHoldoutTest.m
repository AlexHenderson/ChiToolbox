function result = ChiHoldoutTest(data,funcname,varargin)

% ChiHoldoutTest  Performs a holdout test, using the provided function, on the provided data.
%
% Syntax
%   result = ChiHoldoutTest(data,funcname)
%   result = ChiHoldoutTest(data,funcname,parameters)
%
% Description
%   result = ChiHoldoutTest(data,funcname) performs a 80:20, training:test,
%   split of data. funcname is then performed on the training portion of
%   data. The outcome of funcname is a ChiModel. This ChiModel is then used
%   to predict the test portion of data and the outcome reported in result.
%   data must be a ChiSpectralCollection. funcname must be a method of
%   data. 
% 
%   result = ChiHoldoutTest(data,funcname,parameters) allows for any
%   parameterisation, required by funcname, to be passed through to the
%   model generation step. parameters should be passed in the same format
%   as expected by funcname.
% 
% Notes
%   This function requires the Statistics and Machine Learning Toolbox. 
%   The 80:20 split is stratified using cvpartition, therefore the training
%   and test sets should have approximately equal proportions of each
%   class.
%   data must contain classmembership in order to facilitate
%   testing/prediction.
%
% Copyright (c) 2020, Alex Henderson.
% Licenced under the GNU General Public License (GPL) version 3.
%
% See also 
%   ChiKFoldTest ChiLOOCVTest ChiBootstrapTest ChiValidationSet cvpartition

% Contact email: alex.henderson@manchester.ac.uk
% Licenced under the GNU General Public License (GPL) version 3
% http://www.gnu.org/copyleft/gpl.html
% Other licensing options are available, please contact Alex for details
% If you use this file in your work, please acknowledge the author(s) in
% your publications. 

% The latest version of this file is available at:
% https://github.com/AlexHenderson/ChiToolbox


% Do we have the machine learning toolbox
if ~exist('cvpartition','file')
    err = MException(['CHI:',mfilename,':InputError'], ...
        'The Statistics and Machine Learning Toolbox is required for this function.');
    throw(err);
end

% data must be a ChiSpectralCollection
if ~isa(data,'ChiSpectralCollection')
    err = MException(['CHI:',mfilename,':InputError'], ...
        'Can only perform validation on a ChiSpectralCollection.');
    throw(err);
end

% Check whether the function requested is a member of the data object
availablemethods = methods(data);
if ~any(ismember(availablemethods,funcname))
    err = MException(['CHI:',mfilename,':InputError'], ...
        [funcname, ' is not a member function of this ChiSpectralCollection.']);
    throw(err);
end

% Start timer
validationtimer = tic();

% Generate folds
% In order to generate a 80:20 split (training:test) we perform the first
% step of a 5-fold cross validation
numfolds = 5;
folds = cvpartition(data.classmembership.labels, 'KFold', numfolds);

% Determine training and test data index values
% Generate overall list of idx values and make space for results
idx = (1:data.numspectra)';
trainingidx = cell(1,1);
testidx = cell(1,1);

% Calculate predictions
firstpass = true;   % not required for holdout, but...
firstpass2 = true;  % not required for holdout, but...
k = 1;

    % Remove the training data from the original data to define the test set
    testset = data.removespectra(folds.training(k));

    % Remove the test data from the original data to define the training set
    trainingset = data.removespectra(folds.test(k));

    % Generate a handle to the function we wish to use for validation
    funchandle = str2func(funcname);
    
    % Build a model from this iteration's training set
    model = feval(funchandle, trainingset, varargin{:});
    
    % Check whether the requested function is one that produces a ChiModel
    % Only need this on the first pass through the data
    if firstpass
        if ~isa(model,'ChiModel')
            err = MException(['CHI:',mfilename,':InputError'], ...
                [funcname, ' does not produce a ChiModel and therefore cannot be validated.']);
            throw(err);
        end
        firstpass = false; %#ok<NASGU>
    end
    
    % All ChiModels should have a predict method. 
    % Not currently enforced, but...
    prediction = model.predict(testset);
    
    % Somewhere for the output of each test
    % This is inside the loop (with a 1 pass limit) since we need to know
    % the type of prediction in order to build the array. 
    if firstpass2
        eval(['predictions = ', class(prediction), '.empty(1,0);']);
        firstpass2 = false; %#ok<NASGU>
    end
    
    % Info to report
    trainingidx{k} = idx(folds.training(k));
    testidx{k} = idx(folds.test(k));
    predictions(k,1) = prediction;
    

% Stop timer
[validationtime,validationsec] = tock(validationtimer); %#ok<ASGLU>

% Package for export
testparams.trainingpercentage = 80;
result = ChiValidationSet(mfilename,testparams,...
            funcname,varargin,...
            data.clone(),...
            trainingidx,testidx,...
            predictions,validationsec);
result.history.add([mfilename,' (',funcname, ')']);

end % function
