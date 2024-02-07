classdef ChiMLModel < ChiModel & ChiBase

% ChiMLModel  Class to manage the outcome of machine learning algorithms.
%
% Syntax
%   model = ChiMLModel(trainingmask,testmask,algorithm,compactmodel,
%                       prediction,scores,stdevs,correctlyclassified,
%                       classmembership,elapsed,elaspedinseconds,
%                       predictiontime,predictionsec)
%
% Description
%   model = ChiMLModel(____) creates a wrapper for a model produced by a
%   machine learning algorithm, typically random forest or adaboost
%
% Copyright (c) 2018-2019, Alex Henderson.
% Licenced under the GNU General Public License (GPL) version 3.
%
% See also 
%   randomforest adaboost fitcensemble.

% Contact email: alex.henderson@manchester.ac.uk
% Licenced under the GNU General Public License (GPL) version 3
% http://www.gnu.org/copyleft/gpl.html
% Other licensing options are available, please contact Alex for details
% If you use this file in your work, please acknowledge the author(s) in
% your publications. 

% The latest version of this file is available at:
% https://github.com/AlexHenderson/ChiToolbox


    properties
        trainmask;  % Logical column vector where true values indicate spectra to train the model
        testmask;   % Logical column vector where true values indicate spectra to test the model
        algorithm;  % String describing the algorithm used to generate the model
        model;      % Compact model output from fitcensemble or TreeBagger
        prediction; % Column vector of class label identifiers containing the prediction for each test spectrum
        scores;     % Score of the prediction for each spectrum and each label
        stdevs;     % Standard deviation of label predictions (TreeBagger only)
        importances % Estimates of importance of input variables (ChiSpectrum)
        oobimportances % Out-of-bag, estimates of importance of input variables (ChiSpectrum)
        correctlyclassified;    % Column vector of logical values where true indicates a test spectrum correctly classified
        classmembership;        % An instance of ChiClassMembership
        elapsed;                % Time taken to generate the model (string)
        elaspedinseconds;       % Time taken to generate the model in seconds
        predictiontime;         % Time taken to predict the test data (string)
        predictionsec;          % Time taken to generate the test data in seconds
        history = ChiLogger();  % Log of data processing steps
    end
    
    properties (Dependent = true)
        cc; % Column vector of logical values where true indicates a test spectrum correctly classified
        percentcorrectlyclassified; % Percentage of test data correctly classified
        percentcc;  % Percentage of test data correctly classified
        pcc;    % Percentage of test data correctly classified
        numtrees;   % Number of classifiers in the ensemble. Decision trees for random forest, or iterations for AdaBoost
        iterations; % Number of classifiers in the ensemble. Decision trees for random forest, or iterations for AdaBoost
    end
    
    methods
        %% Constructor
        function this = ChiMLModel(...
                        trainmask, ...
                        testmask, ...
                        algorithm, ...
                        model, ...
                        prediction, ...
                        scores, ...
                        stdevs, ...
                        importances, ...
                        oobimportances, ...
                        correctlyclassified, ...
                        classmembership, ...
                        elapsed,...
                        elaspedinseconds,...
                        predictiontime,...
                        predictionsec,...
                        varargin)
                    
            argposition = find(cellfun(@(x) isa(x,'ChiLogger') , varargin));
            if argposition
                this.history = varargin{argposition}.clone;
                varargin(argposition) = []; %#ok<NASGU>
            else
                this.history = ChiLogger();
            end
            
            if (nargin > 0) % Support calling with 0 arguments
                this.trainmask = trainmask;
                this.testmask = testmask;
                this.algorithm = algorithm;
                this.model = model;
                this.prediction = prediction;
                this.scores = scores;
                this.stdevs = stdevs;
                this.importances = importances.clone;
                this.oobimportances = oobimportances.clone;
                this.correctlyclassified = correctlyclassified;
                this.classmembership = classmembership.clone;
                this.elapsed = elapsed;
                this.elaspedinseconds = elaspedinseconds;
                this.predictiontime = predictiontime;
                this.predictionsec = predictionsec;
            end 
        end
        
        %% percentcc
        function percentcorrectlyclassified = get.percentcorrectlyclassified(this)
            percentcorrectlyclassified = 100 * sum(this.correctlyclassified) ./ length(this.correctlyclassified);
        end
        
        %% percentcc
        function percentcc = get.percentcc(this)
            percentcc = this.percentcorrectlyclassified;
        end
        
        %% cc
        function cc = get.cc(this)
            cc = this.correctlyclassified;
        end
       
        %% pcc
        function pcc = get.pcc(this)
            pcc = this.percentcc;
        end
       
        %% numtrees
        function numtrees = get.numtrees(this)
            if isa(this.model,'CompactTreeBagger')
                numtrees = this.model.NumTrees;
            else
                 if isa(this.model,'classreg.learning.classif.CompactClassificationEnsemble')
                    numtrees = this.model.NumTrained;
                 end
            end
        end
        
        %% iterations
        function iterations = get.iterations(this)
            iterations = this.numtrees;
        end
        
    end
    
end
