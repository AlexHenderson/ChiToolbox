classdef (Abstract) ChiAbstractImage < handle
    
% ChiAbstractImage  Abstract class to define spatial characteristics
% Copyright (c) 2014 Alex Henderson (alex.henderson@manchester.ac.uk)
% 
% Here we manage the data as a 2D object rather than 3D to simplify
% operations

    properties (Abstract)
        xvals;      % Abscissa as a row vector
        data;       % Contents of object as a 2D matrix, spectra in rows
        xpixels;    % Number of pixels in the x-direction (width)
        ypixels;    % Number of pixels in the y-direction (height)
        reversex;   % Should abscissa be plotted in decreasing order
        xlabelname; % Text for abscissa label on plots
        xlabelunit; % Text for the abscissa label unit on plots
        ylabelname; % Text for ordinate label on plots
        ylabelunit; % Text for the ordinate label unit on plots
    end          

    properties
        spectrumclassname;  % The name of the class if a single pixel is selected
        spectralcollectionclassname;  % The name of the class if multiple spectra are selected
    end   
    
    properties
        % The definition of this data using ontological descriptors (see ChiOntologyInformation).
        ontologyinfo
    end    
    
    properties (Dependent = true, SetAccess = protected)
        width;          % Number of pixels in the x-direction
        height;         % Number of pixels in the y-direction
        numchannels;    % Number of data points
        numpixels;      % Number of pixels in the image
        numspectra;     % Number of spectra in the image
        xlabel          % Composition of the xlabelname and the xlabelunit
        ylabel          % Composition of the ylabelname and the ylabelunit
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
    
    % =====================================================================
    methods (Abstract)
    % =====================================================================
        clone(this);
    end
    
end
