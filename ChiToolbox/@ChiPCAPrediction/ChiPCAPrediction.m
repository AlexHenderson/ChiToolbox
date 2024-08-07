classdef ChiPCAPrediction < ChiPrediction & ChiBase

% ChiPCAPrediction  Class to manage the outcome of PCA prediction.
%
% Syntax
%   outcome =
%   ChiPCAPrediction(model,projectedscores,pcs,elapsed,distances, ...
%                        predictedclass,trueclass,correctlyclassified)
%   outcome = ChiPCAPrediction(____,history)
% 
% Description
%   outcome =
%   ChiPCAPrediction(model,projectedscores,pcs,elapsed,distances,
%   predictedclass,trueclass,correctlyclassified) creates a wrapper for the
%   outcome of a prediction by a PCA model on a set of 'previously unseen'
%   data.
% 
%   outcome = ChiPCAPrediction(____,history) includes a ChiLogger history
%   object recording the data processing history.
% 
% Notes
%   If there are class membership labels available, a better method of
%   classification is Canonical Variates Analysis which takes the a priori
%   information into account. See ChiPCCVAModel for more information. 
% 
% Copyright (c) 2020, Alex Henderson.
% Licenced under the GNU General Public License (GPL) version 3.
%
% See also 
%   pca ChiPCAModel cva ChiPCCVAModel randomforest adaboost.

% Contact email: alex.henderson@manchester.ac.uk
% Licenced under the GNU General Public License (GPL) version 3
% http://www.gnu.org/copyleft/gpl.html
% Other licensing options are available, please contact Alex for details
% If you use this file in your work, please acknowledge the author(s) in
% your publications. 

% The latest version of this file is available at:
% https://github.com/AlexHenderson/ChiToolbox


    properties
        model;      % ChiPCAModel from which the prediction was made
        projectedscores;    % predicted PCA scores of the test set.
        pcs;        % number of principal components used in the prediction
        elapsed;    % time in seconds that the prediction took
        distances;  % Mahalanobis distance of each test spectrum to each class
        predictedclasslabel; % a cell array of labels indicating the outcome of prediction.
        trueclasslabel;      % a cell array indicating the true label for each spectrum.
        correctlyclassified;    % if the unseen data was labelled, this is a vector indicating whether it was correctly classified. Otherwise it is an empty variable.
        history = ChiLogger();  % log of data processing steps
    end
    
    properties (Dependent = true)
        cc; % if the unseen data was labelled, this is a vector indicating whether it was correctly classified. Otherwise it is an empty variable.
        percentcorrectlyclassified; % if the unseen data was labelled, this is the percentage of predicted data correctly classified. 
        percentcc; % if the unseen data was labelled, this is the percentage of predicted data correctly classified. 
        pcc; % if the unseen data was labelled, this is the percentage of predicted data correctly classified. 
        predictedclassid; % predicted class label identifier
        trueclassid;      % true class label identifier
        elapsedstr;     % time that the prediction took, as a string
        numpcs;         % number of principal components used in the prediction
    end
    
    methods
        %% Constructor
        function this = ChiPCAPrediction(...
                            model, ...
                            projectedscores, ...
                            pcs, ...
                            elapsed, ...
                            distances, ...
                            predictedclasslabel, ...
                            trueclasslabel, ...
                            correctlyclassified, ...
                            varargin ...
                        )
                    
            argposition = find(cellfun(@(x) isa(x,'ChiLogger') , varargin));
            if argposition
                this.history = varargin{argposition}.clone;
                varargin(argposition) = [];  %#ok<NASGU>
            else
                this.history = ChiLogger();
            end
            
            if nargin % Support calling with 0 arguments
                this.model = model.clone();
                this.projectedscores = projectedscores;
                this.pcs = pcs;
                this.elapsed = elapsed;
                this.distances = distances;
                this.predictedclasslabel = predictedclasslabel;
                this.trueclasslabel = trueclasslabel;
                this.correctlyclassified = correctlyclassified;
            end 

        end
        
        %% percentcc
        function percentcorrectlyclassified = get.percentcorrectlyclassified(this)
            if ~isempty(this.correctlyclassified)
                percentcorrectlyclassified = 100 * sum(this.correctlyclassified) ./ length(this.correctlyclassified);
            else
                percentcorrectlyclassified = [];
            end
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
       
        %% trueclassid
        function trueclassid = get.trueclassid(this)
            numtestcases = length(this.predictedclasslabel);
            trueclassid = zeros(numtestcases,1);
            for i = 1:numtestcases
                trueclassid(i) = find(strcmpi(this.model.classmembership.uniquelabels,this.trueclasslabel(i)));
            end
        end
       
        %% predictedclassid
        function predictedclassid = get.predictedclassid(this)
            numtestcases = length(this.predictedclasslabel);
            predictedclassid = zeros(numtestcases,1);
            for i = 1:numtestcases
                predictedclassid(i) = find(strcmpi(this.model.classmembership.uniquelabels,this.predictedclasslabel(i)));
            end
        end
       
        %% elapsedstr
        function elapsedstr = get.elapsedstr(this)
            elapsedstr = durationString(this.elapsed);
        end
       
        %% numpcs
        function numpcs = get.numpcs(this)
            numpcs = this.pcs;
        end
       
    end
    
end
