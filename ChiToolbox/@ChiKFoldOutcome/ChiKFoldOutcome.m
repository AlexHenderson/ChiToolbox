classdef ChiKFoldOutcome < ChiBase
    %ChiKFoldOutcome Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        folds;
        history;        
    end
    
    properties (Dependent = true)
        numfolds;
        numcvs;
        numpcs;
        classnames;
    end
    
    methods
        %% Constructor
        function this = ChiKFoldOutcome(folds, varargin)
            % Create an instance of ChiSpectralCVAOutcome with given parameters
            
            argposition = find(cellfun(@(x) isa(x,'ChiLogger') , varargin));
            if argposition
                this.history = varargin{argposition}.clone;
                varargin(argposition) = []; %#ok<NASGU>
            else
                this.history = ChiLogger();
            end

            if (nargin > 0) % Support calling with 0 arguments
                this.folds = folds;
            end 
        end
        
    end
    
    methods % get and set
        
        %% numfolds : Number of folds
        function numfolds = get.numfolds(this)
            % numfolds : Number of folds
            numfolds = size(this.folds,1);
        end

        %% numcvs : Number of canonical variates
        function numcvs = get.numcvs(this)
            % numcvs : Number of canonical variates
            numcvs = this.folds{1}.pccva.numcvs;
        end

        %% numpcs : Number of principal components
        function numpcs = get.numpcs(this)
            % numcvs : Number of canonical variates
            numpcs = this.folds{1}.pccva.pcs;
        end

        %% classnames : Unique class names
        function classnames = get.classnames(this)
            % classnames : Unique class names
            classnames = this.folds{1}.pccva.pca.classmembership.uniquelabels;
        end
        
    end
    
end

