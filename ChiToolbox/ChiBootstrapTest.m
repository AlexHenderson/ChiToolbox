function result = ChiBootstrapTest(data,funcname,numbootstraps,varargin)

% ChiBootstrapTest  Performs bootstrap validation, using the provided function, on the provided data.
%
% Syntax
%   result = ChiBootstrapTest(data,funcname,numbootstraps)
%   result = ChiBootstrapTest(data,funcname,numbootstraps,parameters)
%
% Description
%   result = ChiBootstrapTest(data,funcname,numbootstraps) performs
%   bootstrap validation of data. The number of bootstrap tests is provided
%   in numbootstraps. data must be a ChiSpectralCollection. funcname must
%   be a method of data.
% 
%   result = ChiBootstrapTest(data,funcname,numbootstraps,parameters)
%   allows for any parameterisation, required by funcname, to be passed
%   through to the model generation step. parameters should be passed in
%   the same format as expected by funcname.
% 
% Notes
%   data must contain classmembership in order to facilitate
%   testing/prediction.
%
% Copyright (c) 2020, Alex Henderson.
% Licenced under the GNU General Public License (GPL) version 3.
%
% See also 
%   ChiHoldoutTest ChiKFoldTest ChiLOOCVTest ChiValidationSet

% Contact email: alex.henderson@manchester.ac.uk
% Licenced under the GNU General Public License (GPL) version 3
% http://www.gnu.org/copyleft/gpl.html
% Other licensing options are available, please contact Alex for details
% If you use this file in your work, please acknowledge the author(s) in
% your publications. 

% The latest version of this file is available at:
% https://github.com/AlexHenderson/ChiToolbox


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

% Calculate something useful
numspectra = data.numspectra;
numspectracolvector = (1:numspectra)';

% Determine training and test data index values
% Generate overall list of idx values and make space for results
idx = (1:numspectra)';
trainingidx = cell(numbootstraps,1);
testidx = cell(numbootstraps,1);

% Calculate predictions
firstpass = true;
firstpass2 = true;
for b = 1:numbootstraps

    % Generate bootstrap
    % trainingsetidx is a column with numspectra random integers 
    % between 1 and numspectra
    trainingsetidx = randi(numspectra,numspectra,1);
    % testsetidx is index positions that are not in the selected list, 
    % ie. never chosen
    testsetidx = setdiff(numspectracolvector,trainingsetidx);

    % Remove the training data from the original data to define the test set
    testset = data.removespectra(trainingsetidx);

    % Remove the test data from the original data to define the training set
    trainingset = data.removespectra(testsetidx);

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
        eval(['predictions = ', class(prediction), '.empty(numbootstraps,0);']);
        firstpass2 = false;
    end
    
    % Info to report
    trainingidx{b} = sort(trainingsetidx);
    testidx{b} = testsetidx;
    predictions(b,1) = prediction; %#ok<AGROW>
    
end

% Stop timer
[validationtime,validationsec] = tock(validationtimer); %#ok<ASGLU>

% Package for export
testparams.numbootstraps = numbootstraps;
result = ChiValidationSet(mfilename,testparams,...
            funcname,varargin,...
            data.clone(),...
            trainingidx,testidx,...
            predictions,validationsec);
result.history.add([mfilename,' (',funcname, ')']);

end % function
