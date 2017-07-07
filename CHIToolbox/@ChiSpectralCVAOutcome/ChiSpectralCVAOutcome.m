classdef ChiSpectralCVAOutcome < handle
% ChiSpectralCVAOutcome
%   Copyright (c) 2014 Alex Henderson (alex.henderson@manchester.ac.uk)

    properties
        cvscores;
        cvloadings;
        cvexplained;
        cvs;
        eigenvectors;
        eigenvalues;        
        pcs;    % 95% cumulative explained variance
        PCAOutcome; % ChiSpectralPCAOutcome
        history;
    end
    
    
    methods
        %% Constructor
        function this = ChiSpectralCVAOutcome(cvscores,cvloadings,cvexplained,cvs,...
                                                eigenvectors,eigenvalues,pcs,PCAOutcome)
            % Create an instance of ChiSpectralCVAOutcome with given parameters
            
            this.history = ChiLogger();
            if (nargin > 0) % Support calling with 0 arguments
                
                this.cvscores = cvscores;
                this.cvloadings = cvloadings;
                this.cvexplained = cvexplained;
                this.cvs = cvs;
                this.eigenvectors = eigenvectors;
                this.eigenvalues = eigenvalues;
                this.pcs = pcs;
                this.PCAOutcome = PCAOutcome;
            end 
        end
        
        %% clone : Make a copy 
        function output = clone(this)
            % Make a copy 
            output = ChiSpectralCVAOutcome(this.cvscores,this.cvloadings,this.cvexplained,this.cvs,...
                                                this.eigenvectors,this.eigenvalues,this.pcs,this.PCAOutcome);
            output.history = this.history;
        end
        
    end
    
end

