classdef ChiPCCVAModel < ChiModel & ChiBase
    
% ChiPCCVAModel  Results from Principal Components Canonical Variates Analysis (PCCVA).
%
% Syntax
%   model = ChiPCCVAModel(scores,loadings,explained,cvs,...
%                         eigenvectors,eigenvalues,pcs,PCAModel)
%   model = ChiPCCVAModel(____,history);
% 
% Description
%   model =
%   ChiPCCVAModel(scores,loadings,explained,cvs,eigenvectors,eigenvalues,pcs,PCAModel)
%   creates a wrapper for the outcome of principal components canonical
%   variates analysis.
% 
%   model = ChiPCCVAModel(____,history) includes a ChiLogger history
%   object, recording the data processing history.
% 
% Copyright (c) 2014-2020, Alex Henderson.
% Licenced under the GNU General Public License (GPL) version 3.
%
% See also 
%   pccva pca ChiPCAPrediction ChiPCCVAModel randomforest adaboost.

% Contact email: alex.henderson@manchester.ac.uk
% Licenced under the GNU General Public License (GPL) version 3
% http://www.gnu.org/copyleft/gpl.html
% Other licensing options are available, please contact Alex for details
% If you use this file in your work, please acknowledge the author(s) in
% your publications. 

% The latest version of this file is available at:
% https://github.com/AlexHenderson/ChiToolbox


    properties
        scores;         % principal components scores
        loadings;       % principal components loadings
        explained;      % percentage explained variance
        cvs;            % number of canonical variates used in the prediction
        eigenvectors;   % eigenvectors of CVA matrix rotation
        eigenvalues;    % eigenvalues of CVA matrix rotation
        pcs;            % number of principal components used in the prediction
        pca;            % ChiPCAModel underpinning this CVA model
        history = ChiLogger();  % log of data processing steps
    end
    
    properties (Dependent = true)
        numcvs;  % number of canonical variates used in the prediction
        classmembership;    % an instance of ChiClassMembership
    end
    
    methods
        % Constructor
        function this = ChiPCCVAModel(scores,loadings,explained,cvs,...
                        eigenvectors,eigenvalues,pcs,PCAModel,varargin)
            % Create an instance of ChiPCCVAModel with given parameters
            
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
        function classmembership = get.classmembership(this)
            classmembership = this.pca.classmembership;
        end
        
        % ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
        
    end
    
end

