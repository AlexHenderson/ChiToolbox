classdef ChiSpectralCVAModel < ChiBase
    
% ChiSpectralCVAModel
%   Copyright (c) 2014 Alex Henderson (alex.henderson@manchester.ac.uk)

    properties
        scores;         % principal components scores
        loadings;       % principal components loadings
        explained;      % percentage explained variance
        cvs;            % number of canonical variates used in the prediction
        eigenvectors;   % eigenvectors of CVA matrix rotation
        eigenvalues;    % eigenvalues of CVA matrix rotation
        pcs;            % number of principal components used in the prediction
        pca;            % ChiSpectralPCAModel underpinning this CVA model
        history = ChiLogger();  % log of data processing steps
    end
    
    properties (Dependent = true)
        numcvs;  % number of canonical variates used in the prediction
    end
    
    methods
        % Constructor
        function this = ChiSpectralCVAModel(scores,loadings,explained,cvs,...
                        eigenvectors,eigenvalues,pcs,PCAModel,varargin)
            % Create an instance of ChiSpectralCVAModel with given parameters
            
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
                this.pca = PCAModel.clone();
            end 
        end
        
        % ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
        function numcvs = get.numcvs(this)
            numcvs = this.cvs;
        end
        
        % ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
        
    end
    
end

