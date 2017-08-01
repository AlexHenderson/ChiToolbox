classdef ChiImage < ChiAbstractImage
% classdef ChiImage < handle & ChiSpectralCharacter & ChiSpatialCharacter
% ChiImage Storage class for hyperspectral images
% Copyright (c) 2014 Alex Henderson (alex.henderson@manchester.ac.uk)
    
    % matlab.mixin.Copyable only for >R2011a
    % Want compatibility with R2009a
    
    %% Properties
        properties  
            %% Basic properties
            xvals;  % abscissa as a row vector
            data;  % ordinate as a 2D array (unfolded matrix)
%             reversex@logical = false; % should abscissa be plotted increasing (false = default) or decreasing (true)
            reversex = false; % should abscissa be plotted increasing (false = default) or decreasing (true)
            xlabel = ''; % text for abscissa label on plots (default = empty)
            ylabel = ''; % text for ordinate label on plots (default = empty)
            mask;
            masked = false;
            filename = '';
            history;
        end

        properties %(SetAccess = protected)
            xpixels;    % Number of pixels in the x-direction (width)
            ypixels;    % Number of pixels in the y-direction (height)
            numpixels;  % Number of pixels in the image
        end          
        
        properties (Dependent = true)
        %% Calculated properties
            totalspectrum;  % sum of columns of data
            totalimage;     % sum of layers of data
        end
    
    %% Methods
    methods
        %% Constructor
        function this = ChiImage(xvals,data,reversex,xlabel,ylabel,xpixels,ypixels,masked,mask,filename)
            % Create an instance of ChiImage with given parameters
            
            if (nargin > 0) % Support calling with 0 arguments
                this.xvals = xvals;
                this.data = data;
                this.history = ChiLogger();
                
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
                                    this.filename = filename;
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
        
        %% clone : Make a copy of this image
        function output = clone(this)
            % Make a copy of this image
            output = ChiImage(this.xvals,this.data,this.reversex,this.xlabel,this.ylabel,this.xpixels,this.ypixels,this.masked,this.mask,this.filename);
            output.history = this.history.clone();
        end
        
        %% totalspectrum : Calculate total signal spectrum
        function totalspectrum = get.totalspectrum(this)
            % Calculate total signal spectrum
            
            totalspectrum = ChiSpectrum(this.xvals,sum(this.data),this.reversex,this.xlabel,this.ylabel);
        end        
        
        %% totalimage : Calculate total signal image
        function totalimage = get.totalimage(this)
            % Calculate total signal image
                        
            if this.masked
                unmasked = zeros(this.xpixels*this.ypixels, this.channels);
                totindex = 1;
                for i = 1:length(this.mask)
                    if this.mask(i)
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
        
        %% numpixels : Number of pixels in the image
        function numpixels = get.numpixels(this)
            % numpixels : Number of pixels in the image
            
            numpixels = this.ypixels * this.xpixels;
        end
    end % methods
end % class ChiImage 

