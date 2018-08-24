classdef (Abstract) ChiAbstractImage < handle
    
% ChiAbstractImage  Abstract class to define spatial characteristics
% Copyright (c) 2014 Alex Henderson (alex.henderson@manchester.ac.uk)
% 
% Here we manage the data as a 2D object rather than 3D to simplify
% operations

    properties (Abstract)
        xvals;      % Abscissa as a row vector
        data;       % Contents of object as a 2D matrix, spectra in rows
        reversex;   % Should abscissa be plotted in decreasing order
        xlabel;     % Text for abscissa label on plots
        ylabel;     % Text for ordinate label on plots
        
        xpixels;    % Number of pixels in the x-direction (width)
        ypixels;    % Number of pixels in the y-direction (height)
    end          

    properties
        spectrumclassname;  % The name of the class if a single pixel is selected
        spectralcollectionclassname;  % The name of the class if multiple spectra are selected
    end   
    
    properties (Abstract)
        % The definition of this data using ontological descriptors (see ChiOntologyInformation).
        ontologyinfo
    end    
    
    properties (Dependent = true, SetAccess = protected)
        width;          % Number of pixels in the x-direction
        height;         % Number of pixels in the y-direction
        numchannels;    % Number of data points
        numpixels;      % Number of pixels in the image
        numspectra;     % Number of spectra in the image
    end
    
    % =====================================================================
    methods
    % =====================================================================

        function width = get.width(this)
            width = this.xpixels;
        end
        
        % ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
        function height = get.height(this)
            % Calculate number of pixels down the image (y-direction)
            height = this.ypixels;
        end
        
        % ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
        function numchannels = get.numchannels(this)
            numchannels = size(this.data,2);
        end
        
        % ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
        function numpixels = get.numpixels(this)
            numpixels = this.ypixels * this.xpixels;
        end
        
        % ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
        function numspectra = get.numspectra(this)
            numspectra = this.numpixels;
        end
        
        % ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    end
    
    % =====================================================================
    methods (Abstract)
    % =====================================================================
        clone(this);
    end
    
end
