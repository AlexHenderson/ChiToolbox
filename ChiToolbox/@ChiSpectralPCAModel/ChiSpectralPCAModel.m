classdef ChiSpectralPCAModel < ChiBase
    
% ChiSpectralPCAModel
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
        history = ChiLogger();    % Log of data processing steps
    end
    
    properties (Dependent = true)
        %% Calculated properties
        numpcs
        xlabel
    end
    
    methods
        %% Constructor
        function this = ChiSpectralPCAModel(scores,loadings,explained,variances,xvals,xlabelname,xlabelunit,reversex,varargin)
            % Create an instance of ChiSpectralPCAModel with given parameters
            
            argposition = find(cellfun(@(x) isa(x,'ChiLogger') , varargin));
            if argposition
                this.history = varargin{argposition}.clone;
                varargin(argposition) = []; %#ok<NASGU>
            else
                this.history = ChiLogger();
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

