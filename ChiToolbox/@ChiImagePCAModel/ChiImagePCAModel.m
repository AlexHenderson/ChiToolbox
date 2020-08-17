classdef ChiImagePCAModel < ChiBase
    
% ChiImagePCAModel
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
        history = ChiLogger();
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
        xlabel          % Composition of the xlabelname and the xlabelunit
    end
    
    methods
        %% Constructor
        function this = ChiImagePCAModel(scores,loadings,explained,variances,xvals,xlabelname,xlabelunit,reversex,xpixels,ypixels,varargin)
            % Create an instance of ChiPCAModel with given parameters
            
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
                this.xpixels = xpixels;
                this.ypixels = ypixels;

                this.xvals = utilities.force2row(this.xvals);
            end 
        end
        
        %% numpcs : Number of principal components
        function numpcs = get.numpcs(this)
            numpcs = size(this.loadings,2);
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
        
        %% xlabel : Generate the x-axis label
        function xlabel = get.xlabel(this)
            if isempty(this.xlabelunit)
                xlabel = this.xlabelname;
            else
                xlabel = [this.xlabelname, ' (', this.xlabelunit, ')'];
            end                
        end
        
        % ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
        
    end
    
end

