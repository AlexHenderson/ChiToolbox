classdef ChiImagePCAOutcome < handle
% ChiImagePCAOutcome
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
        mask;
        masked = false;
        history;
    end
    
    properties (Dependent = true)
        %% Calculated properties
    end
    
    properties (SetAccess = protected)
        xpixels;    % Number of pixels in the x-direction (width)
        ypixels;    % Number of pixels in the y-direction (height)
    end          

    properties (Dependent = true, SetAccess = protected)
    %% Calculated properties
        width;          % Number of pixels in the x-direction
        height;         % Number of pixels in the y-direction
        numpcs;         % Number of principal components
    end
    
    methods
        %% Constructor
        function this = ChiImagePCAOutcome(scores,loadings,explained,variances,xvals,xlabelname,xlabelunit,reversex,xpixels,ypixels)
            % Create an instance of ChiSpectralPCAOutcome with given parameters
            
            if (nargin > 0) % Support calling with 0 arguments
                
                this.scores = scores;
                this.loadings = loadings;
                this.explained = explained;
                this.variances = variances;
                this.xvals = xvals;
                this.xlabelname = xlabelname;
                this.xlabelunit = xlabelunit;
                this.reversex = reversex;
                this.xpixels = xpixels;
                this.ypixels = ypixels;

                this.history = ChiLogger();
                
                this.xvals = ChiForceToRow(this.xvals);
            end 
        end
        
        %% numpcs : Number of principal components
        function numpcs = get.numpcs(this)
            numpcs = size(this.loadings,2);
        end
        
        %% clone : Make a copy of this image
        function output = clone(this)
            % Make a copy of this image
            output = ChiImagePCAOutcome(this.scores,this.loadings,this.explained,this.variances,this.xvals,this.xlabelname,this.xlabelunit,this.reversex,this.xpixels,this.ypixels);
            output.history = this.history.clone();
        end
        
        
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
        
    end
    
end

