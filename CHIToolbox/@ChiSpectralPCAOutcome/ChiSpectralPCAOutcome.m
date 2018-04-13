classdef ChiSpectralPCAOutcome < handle
% ChiSpectralPCAOutcome
%   Copyright (c) 2014 Alex Henderson (alex.henderson@manchester.ac.uk)

    properties
        scores;
        loadings;
        explained;
        variances;
        xvals;
        xlabel; % text for abscissa label on plots
        reversex;
        classmembership; % an instance of ChiClassMembership
        history;
    end
    
    properties (Dependent = true)
        %% Calculated properties
        numpcs;
    end
    
    methods
        %% Constructor
        function this = ChiSpectralPCAOutcome(scores,loadings,explained,variances,xvals,xlabel,reversex)
            % Create an instance of ChiSpectralPCAOutcome with given parameters
            
            this.history = cell(1);
            if (nargin > 0) % Support calling with 0 arguments
                
                this.scores = scores;
                this.loadings = loadings;
                this.explained = explained;
                this.variances = variances;
                this.xvals = xvals;
                this.xlabel = xlabel;
                this.reversex = reversex;
                
                this.xvals = ChiForceToRow(this.xvals);
            end 
        end
        
        %% xpixels : Width of image
        function numpcs = get.numpcs(this)
            numpcs = size(this.loadings,2);
        end
       
        %% clone : Make a copy of this image
        function output = clone(this)
            % Make a copy of this image
            output = ChiSpectralPCAOutcome(this.scores,this.loadings,this.explained,this.variances,this.xvals,this.xlabel,this.reversex);
            output.classmembership = this.classmembership;
            output.history = this.history;
            
        end
        
    end
    
end

