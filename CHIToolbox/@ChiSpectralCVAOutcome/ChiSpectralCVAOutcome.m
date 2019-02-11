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
        pca;        % ChiSpectralPCAOutcome
        history;
    end
    
    properties (Dependent = true)
    %% Calculated properties
        numcvs;  % number of canonical variates
    end
    
    methods
        %% Constructor
        function this = ChiSpectralCVAOutcome(scores,loadings,explained,cvs,...
                                                eigenvectors,eigenvalues,pcs,PCAOutcome)
            % Create an instance of ChiSpectralCVAOutcome with given parameters
            
            this.history = ChiLogger();
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

