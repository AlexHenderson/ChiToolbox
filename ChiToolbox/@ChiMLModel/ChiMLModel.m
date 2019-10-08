classdef ChiMLModel < ChiBase
% ChiMLModel
%   Copyright (c) 2018-2019 Alex Henderson (alex.henderson@manchester.ac.uk)

    properties
        trainmask;
        testmask;
        algorithm;
        model;
        prediction;
        scores;
        stdevs;
        correctlyclassified;
        classmembership;        % An instance of ChiClassMembership
        elapsed;                % Time taken to generate the model (string)
        elaspedinseconds;       % Time taken to generate the model in seconds
        predictiontime;         % Time taken to predict the test data (string)
        predictionsec;          % Time taken to generate the test data in seconds
        history = ChiLogger();  % Log of data processing steps
    end
    
    properties (Dependent = true)
        %% Calculated properties
        cc;
        percentcorrectlyclassified;
        percentcc;
        pcc;
        numtrees;
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
                this.correctlyclassified = correctlyclassified;
                this.classmembership = classmembership;
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
        
    end
    
end
