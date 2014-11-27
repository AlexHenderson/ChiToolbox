classdef ChiImage < handle & ChiCloneable
% CHIIMAGE Storage class for hyperspectral images
% Copyright (c) 2014 Alex Henderson (alex.henderson@manchester.ac.uk)
    
    % matlab.mixin.Copyable only for >R2011a
    % Want compatibility with R2009a
    
    %% Properties
        properties  
            %% Basic properties
            xvals;  % abscissa as a row vector
            data;  % ordinate as a 2D array (matrix)
            reversex@logical = false; % should abscissa be plotted increasing (false = default) or decreasing (true)
            xlabel@char = ''; % text for abscissa label on plots (default = empty)
            ylabel@char = ''; % text for ordinate label on plots (default = empty)
            mask@logical;
            masked@logical = false;
            info;
            log;
        end

        properties (SetAccess = protected)
            xpixels;    % Number of pixels in the x-direction (width)
            ypixels;    % Number of pixels in the y-direction (height)
        end          
        
        properties (Dependent = true)
        %% Calculated properties
            channels;       % number of data points
            width;          % Number of pixels in the x-direction
            height;         % Number of pixels in the y-direction
            totalspectrum;  % sum of columns of data
            totalimage;     % sum of layers of data
        end
    
    %% Methods
    methods
        %% Constructor
        function this = ChiImage(xvals,data,reversex,xlabel,ylabel,xpixels,ypixels,masked,mask,info)
            % Create an instance of ChiImage with given parameters
            
            if (nargin > 0) % Support calling with 0 arguments
                this.xvals = xvals;
                this.data = data;
                this.log = cell(1);
                
                % Force to row vector
                this.xvals = ChiForceToRow(this.xvals);
                
                if (nargin > 2)
                    this.reversex = reversex;
                    if (nargin > 3)
                        this.xlabel = xlabel;
                        this.ylabel = ylabel;
                        if (nargin > 5)
                            this.xpixels = xpixels;
                            this.ypixels = ypixels;
                            if (nargin > 7)
                                this.masked = masked;
                                this.mask = mask;
                                if (nargin > 9)
                                    this.info = info;
                                end
                            end
                        end
                    end
                end
                % Reshape data into a 2D array
                
                [dims] = size(this.data);
                switch (length(dims))
                    case 1
                        % vector of intensities 
                        this.data = reshape(this.data,ypixels*xpixels,[]);
                    case 2
                        % 2D so probably don't need to reshape
                        this.data = reshape(this.data,this.ypixels*this.xpixels,[]);
                        % TODO: Check xpixels and ypixels are valid
                    case 3
                        % 3D data so unfold array
                        this.ypixels = dims(1);
                        this.xpixels = dims(2);
                        chans = dims(3);
                        this.data = reshape(this.data,this.ypixels*this.xpixels,chans);
                    otherwise
                        % Too many or too few dimensions. 
                        err = MException('CHI:ChiImage:DimensionalityError', ...
                            'Data is not 1D, 2D or 3D');
                        throw(err);
                end
            end 
        end
        
        %% channels : Calculate number of channels
        function channels = get.channels(this)
            % Calculate number of channels

            channels = length(this.xvals);
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
        
        %% totalspectrum : Calculate total signal spectrum
        function totalspectrum = get.totalspectrum(this)
            % Calculate total signal spectrum
            
            totalspectrum = ChiSpectrum(this.xvals,sum(this.data),this.reversex,this.xlabel,this.ylabel);
            totalspectrum.log = vertcat(this.log,'Generate totalspectrum');
        end        
        
        %% totalimage : Calculate total signal image
        function totalimage = get.totalimage(this)
            % Calculate total signal image
                        
            if (this.masked)
                unmasked = zeros(this.xpixels*this.ypixels,this.channels);
                totindex = 1;
                for i = 1:length(this.mask)
                    if (this.mask(i))
                        % Insert the non-zero values back into the required
                        % locations. 
                        unmasked(i,:) = this.data(totindex,:);
                        totindex = totindex + 1;
                    end
                end
                totrows = sum(unmasked,2);
            else
                totrows = sum(this.data,2);
            end
            
            totalimage = ChiPicture(totrows,this.xpixels,this.ypixels);
            totalimage.log = vertcat(this.log,'Generate totalimage');
        end        
        
        %% xpixels : Width of image
        function xpixels = get.xpixels(this)
            % xpixels : Width of image
            
            xpixels = this.xpixels;
        end
        
        %% ypixels : Height of image
        function ypixels = get.ypixels(this)
            % ypixels : Height of image
            
            ypixels = this.ypixels;
        end
    end % methods
end % class ChiImage 

