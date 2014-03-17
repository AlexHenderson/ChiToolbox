classdef ChiImage
    %CHIIMAGE Storage class for hyperspectral images
    %   Detailed explanation goes here
    
    %% Properties
        properties  
            %% Basic properties
            xvals;
            yvals;  % stored as 2D array
            reversex = false;
            xlabel = '';
            ylabel = '';
            xpixels;
            ypixels;
        end

        properties (Dependent = true, SetAccess = private)
        %% Calculated properties
            channels;
            totalspectrum;
            totalimage;
        end
    
    %% Methods
    methods
        %% Constructor
        function this = ChiImage(xvals,yvals,reversex,xlabel,ylabel,xpixels,ypixels)
            if (nargin > 0) % Support calling with 0 arguments
                this.xvals = xvals;
                this.yvals = yvals;
                if (nargin > 2)
                    this.reversex = reversex;
                    if (nargin > 3)
                        this.xlabel = xlabel;
                        this.ylabel = ylabel;
                        if (nargin > 5)
                            this.xpixels = xpixels;
                            this.ypixels = ypixels;
                        end
                    end
                end
                % Reshape yvals into a 2D array
                this.yvals = reshape(this.yvals,ypixels*xpixels,[]);
            end 
            
%             % Manage the dimensionality
%             % Could determine the xpixels and ypixels values from the yvals,
%             % but leave that until later
%             [dims] = size(yvals);
%             if (length(dims) > 3)
%                 error('too many dimensions');
%             end
%             switch (length(dims))
%                 case 1  % vector of values
%                     if (this.xpixels 
%                     this.yvals = reshape(this.yvals,ypixels*xpixels,[]);
%                 case 2  % 2D array
%                     this.yvals = reshape(this.yvals,ypixels*xpixels,[]);
%                 case 3  % hypercube
%                     this.yvals = reshape(this.yvals,ypixels*xpixels,[]);
%             end
        end
        
        %% channels : Calculate number of channels
        function channels = get.channels(this)
            channels = length(this.xvals);
        end
        
        %% totalspectrum : Calculate total signal spectrum
        function totalspectrum = get.totalspectrum(this)
            totalspectrum = ChiSpectrum(this.xvals,sum(this.yvals),this.reversex,this.xlabel,this.ylabel);
        end        
        
        %% totalimage : Calculate total signal image
        function totalimage = get.totalimage(this)
            totvals = squeeze(sum(reshape(this.yvals,this.ypixels,this.xpixels,[]),3));
            totalimage = ChiPicture(totvals,this.xpixels,this.ypixels);
        end        
        
        %% summedrangeimagefromindexvals : Calculate image over a given summed range
        function rangeimage = summedrangeimagefromindexvals(this,fromidx,toidx)
            % Check for out of range values
            if (fromidx > channels) || (toidx > channels)
                err = MException('CHI:ChiImage:OutOfRange', ...
                    'Requested range is too high');
                throw(err);
            end            

            if (fromidx < 1) || (toidx < 1)
                err = MException('CHI:ChiImage:OutOfRange', ...
                    'Requested range is invalid');
                throw(err);
            end            

            % Swap if 'from' is higher than 'to'
            if (fromidx > toidx)
                temp = fromidx;
                fromidx = toidx;
                toidx = temp;
            end
            
            rangeimage = squeeze(sum(reshape(this.yvals(:,fromidx:toidx),this.ypixels,this.xpixels,[]),3));
            rangeimage = ChiPicture(rangeimage,this.xpixels,this.ypixels);
        end        
        
        %% summedrangeimagefromxvalues : Calculate image over a given summed range
        function rangeimage = summedrangeimagefromxvalues(this,fromxval,toxval)
            % Determine the index values of the xvalue limits
            [fromvalue,fromidx] = min(abs(this.xvals-fromxval));
            [tovalue,toidx] = min(abs(this.xvals-toxval));
            rangeimage = sumrangeindex(this,fromidx,toidx);
        end        
        
        %% spectrumat : Get spectrum at a given location in the image
        function spectrum = spectrumat(this,xpos,ypos)
            % Handle error where xpos and/or ypos are outside image
            if (xpos > this.xpixels) || (ypos > this.ypixels)
                err = MException('CHI:ChiImage:OutOfRange', ...
                    'Requested location is outside image');
                throw(err);
            end            

            if (xpos < 1) || (ypos < 1)
                err = MException('CHI:ChiImage:OutOfRange', ...
                    'Requested location is invalid');
                throw(err);
            end            
            
            % TODO: test whether this approach creates a temporary object.
            % If so use the commented out version for large data. This
            % gives a warning, about handles, but since we're reshaping and
            % then reshaping back to the original there is no problem. 
            
            y = reshape(this.yvals,this.ypixels,this.xpixels,[]);
            spectrum = squeeze(y(xpos,ypos,:));
            spectrum = ChiSpectrum(this.xvals,spectrum,this.reversex,this.xlabel,this.ylabel);

%             this.yvals=reshape(this.yvals,this.ypixels,this.xpixels,[]);
%             spectrum = squeeze(this.yvals(xpos,ypos,:));
%             spectrum = ChiSpectrum(this.xvals,spectrum,this.reversex,this.xlabel,this.ylabel);
%             this.yvals=reshape(this.yvals,this.ypixels*this.xpixels,[]);
        end
        
        
    end
end

