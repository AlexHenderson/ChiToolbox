classdef ChiSpectralPCAOutcome < handle
% ChiSpectralPCAOutcome
%   Copyright (c) 2014 Alex Henderson (alex.henderson@manchester.ac.uk)

    properties
        scores;
        loadings;
        explained;
        variances;
        xvals;
        xlabelname; % text for abscissa label on plots
        xlabelunit; % text for abscissa label on plots
        reversex;
        classmembership; % an instance of ChiClassMembership
        history;
    end
    
    properties (Dependent = true)
        %% Calculated properties
        numpcs
        xlabel
    end
    
    methods
        %% Constructor
        function this = ChiSpectralPCAOutcome(scores,loadings,explained,variances,xvals,xlabelname,xlabelunit,reversex)
            % Create an instance of ChiSpectralPCAOutcome with given parameters
            
            this.history = cell(1);
            if (nargin > 0) % Support calling with 0 arguments
                
                this.scores = scores;
                this.loadings = loadings;
                this.explained = explained;
                this.variances = variances;
                this.xvals = xvals;
                this.xlabelname = xlabelname;
                this.xlabelunit = xlabelunit;
                this.reversex = reversex;
                
                this.xvals = ChiForceToRow(this.xvals);
            end 
        end
        
        % ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
        % clone : Make a copy of this image
        function output = clone(this)
            % Make a copy of this image
            output = ChiSpectralPCAOutcome(this.scores,this.loadings,this.explained,this.variances,this.xvals,this.xlabelname,this.xlabelunit,this.reversex);
            output.classmembership = this.classmembership;
            output.history = this.history;
            
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

