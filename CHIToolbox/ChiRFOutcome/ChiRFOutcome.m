classdef ChiRFOutcome < handle
% ChiRFOutcome
%   Copyright (c) 2018 Alex Henderson (alex.henderson@manchester.ac.uk)

    properties
        trainmask;
        testmask;
        numtrees;
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
    end
    
    methods
        %% Constructor
        function this = ChiRFOutcome(...
                        trainmask, ...
                        testmask, ...
                        numtrees, ...
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
                this.numtrees = numtrees;
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
       
        %% clone : Make a copy
        function obj = clone(this)
            % Make a copy 
            obj = ChiRFOutcome(...
                        this.trainmask, ...
                        this.testmask, ...
                        this.numtrees, ...
                        this.model, ...
                        this.prediction, ...
                        this.scores, ...
                        this.stdevs, ...
                        this.correctlyclassified, ...
                        this.classmembership, ...
                        this.elapsed, ...
                        this.elaspedinseconds);
            
            obj.classmembership = this.classmembership.clone();
            obj.history = this.history.clone();
            
        end
        
    end
    
end

