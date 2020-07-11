classdef ChiCVAPrediction < ChiBase

% ChiCVAPrediction  Class to manage the outcome of CVA prediction.
%
% Syntax
%   outcome =
%   ChiCVAPrediction(model,projectedscores,pcs,elapsed,distances, ...
%                        predictedclass,trueclass,correctlyclassified)
%   outcome = ChiCVAPrediction(____,history)
% 
% Description
%   outcome =
%   ChiCVAPrediction(model,projectedscores,pcs,elapsed,distances,
%   predictedclass,trueclass,correctlyclassified) creates a wrapper for the
%   outcome of a prediction by a PCA model on a set of 'previously unseen'
%   data.
% 
%   outcome = ChiCVAPrediction(____,history) includes a ChiLogger history
%   object recording the data processing history.
% 
% Notes
%   If there are class membership labels available, a better method of
%   classification is Canonical Variates Analysis which takes the a priori
%   information into account. See ChiCVAModel for more information. 
% 
% Copyright (c) 2020, Alex Henderson.
% Licenced under the GNU General Public License (GPL) version 3.
%
% See also 
%   pca ChiPCAModel cva ChiCVAModel randomforest adaboost.

% Contact email: alex.henderson@manchester.ac.uk
% Licenced under the GNU General Public License (GPL) version 3
% http://www.gnu.org/copyleft/gpl.html
% Other licensing options are available, please contact Alex for details
% If you use this file in your work, please acknowledge the author(s) in
% your publications. 

% The latest version of this file is available on Bitbucket
% https://bitbucket.org/AlexHenderson/chitoolbox


    properties
        model;      % CVA model from which the prediction was made
        projectedscores;    % predicted CVA scores of the test set.
        elapsed;    % time in seconds that the prediction took
        distances;  % Mahalanobis distance of each test spectrum to each class
        predictedclass; % a list of label identifiers indicating the outcome of prediction.
        trueclass; % a list of label identifiers indicating the outcome of prediction.
        correctlyclassified;    % if the unseen data was labelled, this is a vector indicating whether it was correctly classified. Otherwise it is an empty variable.
        history = ChiLogger();  % log of data processing steps
    end
    
    properties (Dependent = true)
        cc; % if the unseen data was labelled, this is a vector indicating whether it was correctly classified. Otherwise it is an empty variable.
        percentcorrectlyclassified; % if the unseen data was labelled, this is the percentage of predicted data correctly classified. 
        percentcc; % if the unseen data was labelled, this is the percentage of predicted data correctly classified. 
        pcc; % if the unseen data was labelled, this is the percentage of predicted data correctly classified. 
        predictedlabel; % predicted class label
        truelabel;      % true class label
        elapsedstr;     % time that the prediction took as a string
    end
    
    methods
        %% Constructor
        function this = ChiCVAPrediction(...
                            model, ...
                            projectedscores, ...
                            elapsed, ...
                            distances, ...
                            predictedclass, ...
                            trueclass, ...
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
                this.elapsed = elapsed;
                this.distances = distances;
                this.predictedclass = predictedclass;
                this.trueclass = trueclass;
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
       
        %% truelabel
        function truelabel = get.truelabel(this)
            truelabel = this.model.pca.classmembership.uniquelabels(this.trueclass);
        end
       
        %% predictedlabel
        function predictedlabel = get.predictedlabel(this)
            predictedlabel = this.model.pca.classmembership.uniquelabels(this.predictedclass);
        end
       
        %% elapsedstr
        function elapsedstr = get.elapsedstr(this)
            elapsedstr = durationString(this.elapsed);
        end
       
    end
    
end
