classdef ChiRFModel < ChiBase
% ChiRFModel
%   Copyright (c) 2018 Alex Henderson (alex.henderson@manchester.ac.uk)

    properties
        trainmask;
        testmask;
        model;
        prediction;
        scores;
        stdevs;
        correctlyclassified;
        classmembership;        % an instance of ChiClassMembership
        elapsed;
        elaspedinseconds;
        history;                % an instance of ChiLogger
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
        function this = ChiRFModel(...
                        trainmask, ...
                        testmask, ...
                        model, ...
                        prediction, ...
                        scores, ...
                        stdevs, ...
                        correctlyclassified, ...
                        classmembership, ...
                        elapsed,...
                        elaspedinseconds)
                    
            if (nargin > 0) % Support calling with 0 arguments
                
                this.trainmask = trainmask;
                this.testmask = testmask;
                this.model = model;
                this.prediction = prediction;
                this.scores = scores;
                this.stdevs = stdevs;
                this.correctlyclassified = correctlyclassified;
                this.classmembership = classmembership;
                this.elapsed = elapsed;
                this.elaspedinseconds = elaspedinseconds;
                
            end 
            this.history = ChiLogger();
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
            numtrees = this.model.NumTrees;
        end
        
    end
    
end
