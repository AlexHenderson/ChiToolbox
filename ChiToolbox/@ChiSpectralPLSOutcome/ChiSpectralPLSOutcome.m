classdef ChiSpectralPLSOutcome < ChiBase
    
% ChiSpectralPLSOutcome
%   Copyright (c) 2019 Alex Henderson (alex.henderson@manchester.ac.uk)

    properties
        xscores;
        xloadings;
        yscores;
        yloadings;
        xexplained;
        yexplained;
        xvals;
        ncomp;
        xlabelname;         % text for abscissa label on x-block plots
        xlabelunit;         % text for abscissa label on x-block plots
        yblocklabelname;    % text for abscissa label on y-block plots
        yblocklabelunit;    % text for abscissa label on y-block plots
        reversex;
        classmembership;    % an instance of ChiClassMembership
        history = ChiLogger();    % Log of data processing steps
    end
    
    properties (Dependent = true)
        %% Calculated properties
        xlabel
        yblocklabel
    end
    
    methods
        %% Constructor
        function this = ChiSpectralPLSOutcome(xscores,xloadings,...
                yscores,yloadings,...
                xexplained,yexplained,...
                ncomp,xvals,...
                xlabelname,xlabelunit,...
                yblocklabelname,yblocklabelunit,...
                reversex,classmembership,varargin)
            % Create an instance of ChiSpectralPLSOutcome with given parameters
            
            argposition = find(cellfun(@(x) isa(x,'ChiLogger') , varargin));
            if argposition
                this.history = varargin{argposition}.clone;
                varargin(argposition) = []; %#ok<NASGU>
            else
                this.history = ChiLogger();
            end
            
            if (nargin > 0) % Support calling with 0 arguments
                
                this.xscores = xscores;
                this.xloadings = xloadings;
                this.yscores = yscores;
                this.yloadings = yloadings;
                this.xexplained = xexplained;
                this.yexplained = yexplained;
                this.ncomp = ncomp;
                this.xvals = xvals;
                this.xlabelname = xlabelname;
                this.xlabelunit = xlabelunit;
                this.yblocklabelname = yblocklabelname;
                this.yblocklabelunit = yblocklabelunit;
                this.reversex = reversex;
                this.classmembership = classmembership.clone();
                
                this.xvals = utilities.force2row(this.xvals);
            end 
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
        function yblocklabel = get.yblocklabel(this)
            if isempty(this.yblocklabelunit)
                yblocklabel = this.yblocklabelname;
            else
                yblocklabel = [this.yblocklabelname, ' / ', this.yblocklabelunit, ''];
            end                
        end
        
        % ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
        
    end
    
end
