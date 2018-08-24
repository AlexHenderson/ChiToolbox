classdef (Abstract) ChiAbstractSpectralCollection < handle
% ChiAbstractSpectralCollection  Abstract class to define collections of spectra
% Copyright (c) 2017 Alex Henderson (alex.henderson@manchester.ac.uk)

% Here we manage the data as a 2D object

    properties (Abstract)
        xvals;      % Abscissa as a row vector
        data;       % Contents of object as a 2D matrix, spectra in rows
        reversex;   % Should abscissa be plotted in decreasing order
        xlabel;     % Text for abscissa label on plots
        ylabel;     % Text for ordinate label on plots
    end

    properties
        spectrumclassname;  % The name of the class if a single spectrum is selected
    end

    properties
        % The definition of this data using ontological descriptors (see ChiOntologyInformation).
        ontologyinfo
    end    
    
    properties (Dependent = true, SetAccess = protected)
        numchannels;    % Number of data points
        numspectra;     % Number of spectra
    end
    
    % =====================================================================
    methods
    % =====================================================================
        % numchannels : Calculate number of data points in the spectra
        function numchannels = get.numchannels(this)
            % Calculate number of data points per spectrum
            numchannels = size(this.data,2);
        end
        
        % numspectra : Calculate number of spectra in the collection
        function numspectra = get.numspectra(this)
            % Calculate number of spectra in this collection
            numspectra = size(this.data,1);
        end
    end
    
    
end
