function prediction = predict(varargin)

% predict  Predicts the class labels of a previously unseen data set.
%
% Syntax
%   prediction = predict(unseen);
%
% Description
%   prediction = predict(unseen) predicts class labels, generated by this
%   ChiSpectralPCAModel, for each spectrum in unseen. unseen is a
%   ChiSpectrum, or ChiSpectralCollection, and prediction is a
%   ChiPCAPrediction object. 
%   If unseen has a classmembership, then prediction will include a
%   property indicating whether the spectra were correctly classified.
% 
% Copyright (c) 2020, Alex Henderson.
% Licenced under the GNU General Public License (GPL) version 3.
%
% See also 
%   ChiCVAPrediction ChiSpectralCollection.

% Contact email: alex.henderson@manchester.ac.uk
% Licenced under the GNU General Public License (GPL) version 3
% http://www.gnu.org/copyleft/gpl.html
% Other licensing options are available, please contact Alex for details
% If you use this file in your work, please acknowledge the author(s) in
% your publications. 

% The latest version of this file is available on Bitbucket
% https://bitbucket.org/AlexHenderson/chitoolbox


%% Start timer
predictiontimer = tic();

%% Get this object
this = varargin{1};

%% Identify test data
argposition = find(cellfun(@(x) isa(x,'ChiSpectralCollection') , varargin));
if argposition
    testset = varargin{argposition}.clone;
    varargin(argposition) = []; %#ok<NASGU>
else
    argposition = find(cellfun(@(x) isa(x,'ChiSpectrum') , varargin));
    if argposition
        testset = varargin{argposition}.clone;
        varargin(argposition) = []; %#ok<NASGU>
    else
        err = MException(['CHI:',mfilename,':InputError'], ...
            'Can only predict ChiSpectra, or ChiSpectralCollections.');
        throw(err);
    end
end

%% Project the test data into the underlying PCA model then into this CVA model
pcaprediction = this.pca.predict(testset);
projectedscores = pcaprediction.projectedscores * this.eigenvectors * diag(this.eigenvalues);

%% Make space for results
trueclass = [];
correctlyclassified = [];

%% Only if we have class membership can we determine predicted classes
% Make space for the results
distances = zeros(testset.numspectra, this.pca.classmembership.numclasses);

% Measure the distance of each projected test data point to each class
for c = 1:this.pca.classmembership.numclasses
    classscores = this.scores((this.pca.classmembership.labelids == c),:);
    distances(:,c) = mahal(projectedscores,classscores);
end

% Determine the predicted class
[mindist,predictedclass] = min(distances, [], 2); %#ok<ASGLU>

% If we already knew the true labels, we can also calculate the prediction accuracy
if ~isempty(testset.classmembership)
    trueclass = testset.classmembership.labelids;
    correctlyclassified = (predictedclass == trueclass);
end

%% Stop timer
[predictiontime,predictionsec] = tock(predictiontimer); %#ok<ASGLU>

%% Generate results
prediction = ChiCVAPrediction(...
                this.clone(), ...
                projectedscores, ...
                predictionsec, ...
                distances, ...
                predictedclass, ...
                trueclass, ...
                correctlyclassified ...
            );

prediction.history.add('CVA prediction of unseen data');

end