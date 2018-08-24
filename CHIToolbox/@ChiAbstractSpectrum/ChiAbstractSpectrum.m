classdef (Abstract) ChiAbstractSpectrum < handle
% ChiAbstractSpectrum  Abstract class to define spectral characteristics
% Copyright (c) 2014 Alex Henderson (alex.henderson@manchester.ac.uk)
    
    properties (Abstract)
        xvals;      % Abscissa as a row vector
        data;       % Ordinate as a row vector
        reversex;   % Should abscissa be plotted in decreasing order
        xlabel;     % Text for abscissa label on plots
        ylabel;     % Text for ordinate label on plots
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
    end
    
    % =====================================================================
    methods (Abstract)
    % =====================================================================
        clone(this);
    end
    
end

