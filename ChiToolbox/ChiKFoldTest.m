function result = ChiKFoldTest(data,funcname,numfolds,varargin)

% ChiKFoldTest  Performs k-fold crossvalidation, using the provided function, on the provided data.
%
% Syntax
%   result = ChiKFoldTest(data,funcname,numfolds)
%   result = ChiKFoldTest(data,funcname,numfolds,parameters)
%
% Description
%   result = ChiKFoldTest(data,funcname,numfolds) performs k-fold
%   crossvalidation of data, where the number of folds (k) is provided in
%   numfolds. data must be a ChiSpectralCollection. funcname must be a
%   method of data.
% 
%   result = ChiKFoldTest(data,funcname,numfolds,parameters) allows for any
%   parameterisation, required by funcname, to be passed through to the
%   model generation step. parameters should be passed in the same format
%   as expected by funcname.
% 
% Notes
%   This function requires the Statistics and Machine Learning Toolbox. 
%   The fold generation is stratified using cvpartition, therefore the
%   training and test sets should have approximately equal proportions of
%   each class.
%   data must contain classmembership in order to facilitate
%   testing/prediction.
%
% Copyright (c) 2020, Alex Henderson.
% Licenced under the GNU General Public License (GPL) version 3.
%
% See also 
%   ChiHoldoutTest ChiLOOCVTest ChiBootstrapTest ChiValidationSet cvpartition

% Contact email: alex.henderson@manchester.ac.uk
% Licenced under the GNU General Public License (GPL) version 3
% http://www.gnu.org/copyleft/gpl.html
% Other licensing options are available, please contact Alex for details
% If you use this file in your work, please acknowledge the author(s) in
% your publications. 

% The latest version of this file is available on Bitbucket
% https://bitbucket.org/AlexHenderson/chitoolbox


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
folds = cvpartition(data.classmembership.labels, 'KFold', numfolds);

% Determine training and test data index values
% Generate overall list of idx values and make space for results
idx = (1:data.numspectra)';
trainingidx = cell(numfolds,1);
testidx = cell(numfolds,1);

% Calculate predictions
firstpass = true;
firstpass2 = true;
for k = 1:numfolds

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
        firstpass = false;
    end
    
    % All ChiModels should have a predict method. 
    % Not currently enforced, but...
    prediction = model.predict(testset);
    
    % Somewhere for the output of each test
    % This is inside the loop (with a 1 pass limit) since we need to know
    % the type of prediction in order to build the array. 
    if firstpass2
        eval(['predictions = ', class(prediction), '.empty(numfolds,0);']);
        firstpass2 = false;
    end
    
    % Info to report
    trainingidx{k} = idx(folds.training(k));
    testidx{k} = idx(folds.test(k));
    predictions(k,1) = prediction; %#ok<AGROW>
    
end

% Stop timer
[validationtime,validationsec] = tock(validationtimer); %#ok<ASGLU>

% Package for export
testparams.numfolds = numfolds;
result = ChiValidationSet(mfilename,testparams,...
            funcname,varargin,...
            data.clone(),...
            trainingidx,testidx,...
            predictions,validationsec);
result.history.add([mfilename,' (',funcname, ')']);

end % function
