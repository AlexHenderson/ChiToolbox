classdef ChiPCCVAPrediction < ChiPrediction & ChiBase

% ChiPCCVAPrediction  Class to manage the outcome of CVA prediction.
%
% Syntax
%   outcome =
%   ChiPCCVAPrediction(model,unseendata,projectedscores,pcs,elapsed, ...
%       distances,predictedclass,trueclass,correctlyclassified)
%   outcome = ChiPCCVAPrediction(____,history)
% 
% Description
%   outcome =
%   ChiPCCVAPrediction(model,unseendata,projectedscores,pcs,elapsed,
%   distances,predictedclass,trueclass,correctlyclassified) creates a
%   wrapper for the outcome of a prediction by a PCA model on a set of
%   'previously unseen' data.
% 
%   outcome = ChiPCCVAPrediction(____,history) includes a ChiLogger history
%   object recording the data processing history.
% 
% Copyright (c) 2020-2023, Alex Henderson.
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

% The latest version of this file is available on Bitbucket
% https://bitbucket.org/AlexHenderson/chitoolbox


    properties
        model;      % ChiPCCVAModel from which the prediction was made
        unseendata;   % data that was predicted (previously unseen data)
        projectedscores;    % predicted CVA scores of the test set.
        elapsed;    % time in seconds that the prediction took
        distances;  % Mahalanobis distance of each test spectrum to each class
        predictedclasslabels;    % a cell array of labels indicating the outcome of prediction.
        correctlyclassified;    % if the unseen data was labelled, this is a vector indicating whether it was correctly classified. Otherwise it is an empty variable.
        history = ChiLogger();  % log of data processing steps
    end
    
    properties (Dependent = true)
        cc; % if the unseen data was labelled, this is a vector indicating whether it was correctly classified. Otherwise it is an empty variable.
        percentcorrectlyclassified; % if the unseen data was labelled, this is the percentage of predicted data correctly classified. 
        percentcc; % if the unseen data was labelled, this is the percentage of predicted data correctly classified. 
        pcc; % if the unseen data was labelled, this is the percentage of predicted data correctly classified. 
        predictedclassid; % predicted class label identifier
        elapsedstr;     % time that the prediction took as a string
    end
    
    methods
        %% Constructor
        function this = ChiPCCVAPrediction(...
                            model, ...
                            unseendata, ...
                            projectedscores, ...
                            elapsed, ...
                            distances, ...
                            predictedclasslabels, ...
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
                this.model = model;            % cloned by predict function
                this.unseendata = unseendata;  % cloned by predict function
                this.projectedscores = projectedscores;
                this.elapsed = elapsed;
                this.distances = distances;
                this.predictedclasslabels = predictedclasslabels;
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
       
%         %% trueclassid
%         function unseenclassid = get.unseenclassid(this)
%             numtestcases = this.unseendata.numspectra;
%             unseenclassid = zeros(numtestcases,1);
%             for i = 1:numtestcases
%                 unseenclassid(i) = find(strcmpi(this.model.pca.classmembership.uniquelabels,this.trueclasslabel(i)));
%             end
%         end
       
        %% predictedclassid
        function predictedclassid = get.predictedclassid(this)
            numtestcases = length(this.predictedclasslabel);
            predictedclassid = zeros(numtestcases,1);
            for i = 1:numtestcases
                predictedclassid(i) = find(strcmpi(this.model.pca.classmembership.uniquelabels,this.predictedclasslabel(i)));
            end
        end
       
        %% elapsedstr
        function elapsedstr = get.elapsedstr(this)
            elapsedstr = durationString(this.elapsed);
        end
       
    end
    
end
