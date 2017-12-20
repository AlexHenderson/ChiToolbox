classdef ChiKFoldOutcome < handle
    %ChiKFoldOutcome Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        numfolds;
        folds;
        pcs;
        history;        
    end
    
    methods
        %% Constructor
        function this = ChiKFoldOutcome(numfolds,folds,pcs)
            % Create an instance of ChiSpectralCVAOutcome with given parameters
            
            this.history = ChiLogger();
            if (nargin > 0) % Support calling with 0 arguments
                
                this.numfolds = numfolds;
                this.folds = folds;
                this.pcs = pcs;
            end 
        end
        
        %% clone : Make a copy 
        function output = clone(this)
            % Make a copy 
            output = ChiKFoldOutcome(this.numfolds,this.folds,this.pcs);
            output.history = this.history;
        end
        

    end
    
end

