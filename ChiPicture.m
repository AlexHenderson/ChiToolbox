classdef ChiPicture
    %CHIPICTURE Storage class for 2D images (not hyperspectral images)
    %   Detailed explanation goes here
    
    %% Properties
        %% Basic properties
        properties
            data;
            xpixels;
            ypixels;
        end
    
    %% Methods
    methods        
        %% Constructor
        function this = ChiPicture(data,xpixels,ypixels)
            if (nargin > 0) % Support calling with 0 arguments
                this.data = data;
                if (nargin > 1)
                    this.xpixels = xpixels;
                    this.ypixels = ypixels;
                else
                    % TODO: determine the number of pixels if not given
                end                
            end 
        end
        
        %% getat : Get value at a location in the image
        function value = getat(this,xpos,ypos)
            
            if (xpos > this.xpixels) || (ypos > this.ypixels)
                err = MException('CHI:ChiPicture:OutOfRange', ...
                    'Requested location is outside image');
                throw(err);
            end            

            if (xpos < 1) || (ypos < 1)
                err = MException('CHI:ChiPicture:OutOfRange', ...
                    'Requested location is invalid');
                throw(err);
            end            
            
            value = this.data(xpos,ypos);
        end
        
        %% imagesc : Basic imagesc function
        function imagesc(this,varargin)
            imagesc(this.data,varargin{:});
            axis image;
            axis off;
        end        
        
    end    
end

