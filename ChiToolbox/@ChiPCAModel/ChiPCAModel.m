classdef ChiPCAModel < ChiModel & ChiBase

% ChiPCAModel  Results from a Principal Components Analysis (PCA) experiment.
%
% Syntax
%   model = ChiPCAModel(scores,loadings,explained,variances,xvals,xlabelname,xlabelunit,reversex);
%   model = ChiPCAModel(____,history);
% 
% Description
%   model = ChiPCAModel(scores,loadings,explained,variances,xvals,
%   xlabelname,xlabelunit,reversex) creates a wrapper for the outcome of a
%   principal components analysis experiment.
% 
%   model = ChiPCAModel(____,history) includes a ChiLogger history
%   object recording the data processing history.
% 
% Notes
%   If there are class membership labels available, a better method of
%   classification is Canonical Variates Analysis which takes the a priori
%   information into account. See ChiCVAModel for more information. 
% 
% Copyright (c) 2020, Alex Henderson.
% Licenced under the GNU General Public License (GPL) version 3.
%
% See also 
%   pca ChiPCAPrediction cva ChiCVAModel randomforest adaboost.

% Contact email: alex.henderson@manchester.ac.uk
% Licenced under the GNU General Public License (GPL) version 3
% http://www.gnu.org/copyleft/gpl.html
% Other licensing options are available, please contact Alex for details
% If you use this file in your work, please acknowledge the author(s) in
% your publications. 

% The latest version of this file is available on Bitbucket
% https://bitbucket.org/AlexHenderson/chitoolbox


    properties
        scores;                 % principal components scores
        loadings;               % principal components loadings
        explained;              % percentage explained variance
        variances;              % variance of each principal component
        xvals;                  % spectral x-axis values
        xlabelname;             % text for abscissa label on plots
        xlabelunit;             % text for abscissa label on plots
        reversex;               % should loadings be plotted high to low (default = false)
        trainingmean;           % mean of the training set (ChiSpectrum)
        classmembership;        % an instance of ChiClassMembership
        history = ChiLogger();  % log of data processing steps
    end
    
    properties (Dependent = true)
        numpcs;                 % number of principal components required to explain 95% of the variance in the model
        xlabel;                 % fully formed x-axis label for loadings plots
    end
    
    methods
        % Constructor
        function this = ChiPCAModel(scores,loadings,explained,variances,xvals,xlabelname,xlabelunit,reversex,varargin)
            % Create an instance of ChiPCAModel with given parameters
            
            argposition = find(cellfun(@(x) isa(x,'ChiLogger') , varargin));
            if argposition
                this.history = varargin{argposition}.clone;
                varargin(argposition) = [];
            else
                this.history = ChiLogger();
            end
            
            argposition = find(cellfun(@(x) isa(x,'ChiClassMembership') , varargin));
            if argposition
                this.classmembership = varargin{argposition}.clone;
                varargin(argposition) = [];
            else
                this.classmembership = [];
            end
            
            argposition = find(cellfun(@(x) isa(x,'ChiSpectrum') , varargin));
            if argposition
                this.trainingmean = varargin{argposition}.clone;
                varargin(argposition) = []; %#ok<NASGU>
            else
                this.trainingmean = [];
            end
            
            if (nargin > 0) % Support calling with 0 arguments
                
                this.scores = scores;
                this.loadings = loadings;
                this.explained = explained;
                this.variances = variances;
                this.xvals = xvals;
                this.xlabelname = xlabelname;
                this.xlabelunit = xlabelunit;
                this.reversex = reversex;
                
                this.xvals = utilities.force2row(this.xvals);
            end 
        end
        
        % ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
        function numpcs = get.numpcs(this)
            numpcs = size(this.loadings,2);
        end
       
        % ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
        function xlabel = get.xlabel(this)
            if isempty(this.xlabelunit)
                xlabel = this.xlabelname;
            else
                xlabel = [this.xlabelname, ' / ', this.xlabelunit, ''];
            end                
        end
        
        % ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
        
    end
    
end

