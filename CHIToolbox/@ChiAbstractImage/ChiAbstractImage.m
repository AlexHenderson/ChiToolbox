classdef (Abstract) ChiAbstractImage < handle
    
% ChiAbstractImage  Abstract class to define spatial characteristics
% Copyright (c) 2014 Alex Henderson (alex.henderson@manchester.ac.uk)

% Here we manage the data as a 2D object rather than 3D to simplify
% operations

    properties (Abstract)
        xvals;  % abscissa as a row vector
        data;       % Contents of object as a 2D matrix
        reversex; % should abscissa be plotted increasing or decreasing
                  % true means plot high to low
%         reversex@logical; % should abscissa be plotted increasing or decreasing
        xlabel; % text for abscissa label on plots
        ylabel; % text for ordinate label on plots
    end

%     properties (Abstract, SetAccess = protected)
    properties (Abstract)
        xpixels;        % Number of pixels in the x-direction (width)
        ypixels;        % Number of pixels in the y-direction (height)
    end          

    properties (Dependent = true, SetAccess = protected)
    %% Calculated properties
        width;          % Number of pixels in the x-direction
        height;         % Number of pixels in the y-direction
        numchannels;    % Number of data points
        numpixels;      % Number of pixels in the image
        numspectra;     % Number of spectra in the image
    end
    
    methods
        %% width : Calculate number of pixels across the image (x-direction)
        function width = get.width(this)
            % Calculate number of pixels across the image (x-direction)
            width = this.xpixels;
        end
        
        %% height : Calculate number of pixels down the image (y-direction)
        function height = get.height(this)
            % Calculate number of pixels down the image (y-direction)
            height = this.ypixels;
        end
        
        %% numchannels : Calculate number of pixels down the image (y-direction)
        function numchannels = get.numchannels(this)
            % Calculate number of data points per spectrum
            numchannels = size(this.data,2);
        end
        %% numpixels : Number of pixels in the image
        function numpixels = get.numpixels(this)
            % numpixels : Number of pixels in the image
            
            numpixels = this.ypixels * this.xpixels;
        end
        %% numspectra : Number of spectra in the image
        function numspectra = get.numspectra(this)
            % numspectra : Number of spectra in the image
            
            numspectra = this.numpixels;
        end
    end
    
    methods (Abstract)
        clone(this);
    end
    
end

