classdef ChiSpectralCVAOutcome < ChiBase
    
% ChiSpectralCVAOutcome
%   Copyright (c) 2014 Alex Henderson (alex.henderson@manchester.ac.uk)

    properties
        scores;
        loadings;
        explained;
        cvs;
        eigenvectors;
        eigenvalues;        
        pcs;        % 95% cumulative explained variance
        pca;        % ChiSpectralPCAModel
        history = ChiLogger();    % Log of data processing steps
    end
    
    properties (Dependent = true)
        numcvs;  % number of canonical variates
    end
    
    methods
        %% Constructor
        function this = ChiSpectralCVAOutcome(scores,loadings,explained,cvs,...
                                                eigenvectors,eigenvalues,pcs,PCAOutcome,varargin)
            % Create an instance of ChiSpectralCVAOutcome with given parameters
            
            this.history = ChiLogger();
            argposition = find(cellfun(@(x) isa(x,'ChiLogger') , varargin));
            if argposition
                this.history = varargin{argposition}.clone;
                varargin(argposition) = []; %#ok<NASGU>
            end
            
            if (nargin > 0) % Support calling with 0 arguments
                
                this.scores = scores;
                this.loadings = loadings;
                this.explained = explained;
                this.cvs = cvs;
                this.eigenvectors = eigenvectors;
                this.eigenvalues = eigenvalues;
                this.pcs = pcs;
                this.pca = PCAOutcome;
            end 
        end
        
        %% numcvs : Get the number of canonical variates
        function numcvs = get.numcvs(this)
            numcvs = this.cvs;
        end        
        
    end
    
end

