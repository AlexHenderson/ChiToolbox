classdef (Abstract) ChiAbstractSpectrum < ChiBase
    
% ChiAbstractSpectrum  Abstract class to define spectral characteristics
% Copyright (c) 2014 Alex Henderson (alex.henderson@manchester.ac.uk)
    
    properties (Abstract)
        xvals;      % Abscissa as a row vector
        data;       % Ordinate as a row vector
        reversex;   % Should abscissa be plotted in decreasing order
        xlabelname; % Text for abscissa label on plots
        xlabelunit; % Text for the abscissa label unit on plots
        ylabelname; % Text for ordinate label on plots
        ylabelunit; % Text for the ordinate label unit on plots
    end
    
    properties
        numspectra = 1; % Number of rows of data
    end
    
    properties
        % The definition of this data using ontological descriptors (see ChiOntologyInformation).
        ontologyinfo
    end    
    
    properties (Dependent = true, SetAccess = protected)
        numchannels;    % Number of data points
        xlabel          % Composition of the xlabelname and the xlabelunit
        ylabel          % Composition of the ylabelname and the ylabelunit
    end

    % =====================================================================
    methods 
    % =====================================================================
        % numchannels
        function numchannels = get.numchannels(this)
            % Calculate number of channels
            numchannels = length(this.data);
        end

        % ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
        % Name of variable
        function name = variablename(this) %#ok<MANU>
            name = utilities.callingline();
        end
        
        % ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
        function xlabel = get.xlabel(this)
            if isempty(this.xlabelunit)
                xlabel = this.xlabelname;
            else
                xlabel = [this.xlabelname, ' (', this.xlabelunit, ')'];
            end                
        end
        
        % ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
        function ylabel = get.ylabel(this)
            if isempty(this.ylabelunit)
                ylabel = this.ylabelname;
            else
                ylabel = [this.ylabelname, ' (', this.ylabelunit, ')'];
            end                
        end
        
        % ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    end
    
end

