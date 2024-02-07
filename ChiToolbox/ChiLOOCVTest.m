function result = ChiLOOCVTest(data,funcname,varargin)

% ChiLOOCVTest  Performs leave-one-out crossvalidation, using the provided function, on the provided data.
%
% Syntax
%   result = ChiLOOCVTest(data,funcname)
%   result = ChiLOOCVTest(data,funcname,parameters)
%
% Description
%   result = ChiLOOCVTest(data,funcname) performs leave-one-out
%   crossvalidation of data. data must be a ChiSpectralCollection. funcname
%   must be a method of data.
% 
%   result = ChiLOOCVTest(data,funcname,parameters) allows for any
%   parameterisation, required by funcname, to be passed through to the
%   model generation step. parameters should be passed in the same format
%   as expected by funcname.
% 
% Notes
%   data must contain classmembership in order to facilitate
%   testing/prediction.
%
% Copyright (c) 2020, Alex Henderson.
% Licenced under the GNU General Public License (GPL) version 3.
%
% See also 
%   ChiHoldoutTest ChiKFoldTest ChiBootstrapTest ChiValidationSet

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

% Determine training and test data index values
% Generate overall list of idx values and make space for results
idx = (1:data.numspectra)';
trainingidx = cell(data.numspectra,1);
testidx = cell(data.numspectra,1);

% Calculate predictions
firstpass = true;
firstpass2 = true;
for i = 1:data.numspectra

    % Select the i'th spectrum as a test set
    testset = data.spectrumat(i);

    % Remove the i'th spectrum from the input data to produce a training set
    trainingset = data.clone;
    trainingset.removespectra(i);
    
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
        eval(['predictions = ', class(prediction), '.empty(data.numspectra,0);']);
        firstpass2 = false;
    end
    
    % Info to report
    trainingidx{i} = idx;   % make a copy of entire list
    trainingidx{i}(i) = []; % remove this loop variable
    testidx{i} = i;         % only a single test value, the same as the loop variable
    predictions(i,1) = prediction; %#ok<AGROW>
    
end

% Stop timer
[validationtime,validationsec] = tock(validationtimer); %#ok<ASGLU>

% Package for export
testparams = [];
result = ChiValidationSet(mfilename,testparams,...
            funcname,varargin,...
            data.clone(),...
            trainingidx,testidx,...
            predictions,validationsec);
result.history.add([mfilename,' (',funcname, ')']);

end % function
