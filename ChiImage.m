classdef ChiImage < handle
    %CHIIMAGE Storage class for hyperspectral images
    %   Detailed explanation goes here
    
    %% Properties
        properties  
            %% Basic properties
            xvals;  % abscissa as a row vector
            yvals;  % ordinate as a 2D array (matrix)
            reversex = false; % should abscissa be plotted increasing (false = default) or decreasing (true)
            xlabel = ''; % text for abscissa label on plots (default = empty)
            ylabel = ''; % text for ordinate label on plots (default = empty)
            xpixels;
            ypixels;
        end

        properties (Dependent = true, SetAccess = private)
        %% Calculated properties
            channels;       % number of data points
            totalspectrum;  % sum of columns of data
            totalimage;     % sum of layers of data
        end
    
    %% Methods
    methods
        %% Constructor
        function this = ChiImage(xvals,yvals,reversex,xlabel,ylabel,xpixels,ypixels)
            % Create an instance of ChiImage with given parameters
            
            if (nargin > 0) % Support calling with 0 arguments
                this.xvals = xvals;
                this.yvals = yvals;
                
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
                        end
                    end
                end
                % Reshape yvals into a 2D array
                
                [dims] = size(this.yvals);
                switch (length(dims))
                    case 1
                        % vector of intensities 
                        this.yvals = reshape(this.yvals,ypixels*xpixels,[]);
                    case 2
                        % 2D so probably don't need to reshape
                        this.yvals = reshape(this.yvals,ypixels*xpixels,[]);
                        % TODO: Check xpixels and ypixels are valid
                    case 3
                        % 3D data so unfold array
                        this.yvals = reshape(this.yvals,ypixels*xpixels,[]);
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
        
        %% totalspectrum : Calculate total signal spectrum
        function totalspectrum = get.totalspectrum(this)
            % Calculate total signal spectrum
            
            totalspectrum = ChiSpectrum(this.xvals,sum(this.yvals),this.reversex,this.xlabel,this.ylabel);
        end        
        
        %% totalimage : Calculate total signal image
        function totalimage = get.totalimage(this)
            % Calculate total signal image
            
            totvals = squeeze(sum(reshape(this.yvals,this.ypixels,this.xpixels,[]),3));
            totalimage = ChiPicture(totvals,this.xpixels,this.ypixels);
        end        
        
        %% summedrangeimagefromindexvals : Calculate image over a given summed range
        function rangeimage = summedrangeimagefromindexvals(this,fromidx,toidx)
            % Calculate image over a given summed range
            
            % Check for out of range values
            if (fromidx > this.channels) || (toidx > this.channels)
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
            [fromidx,toidx] = ChiForceIncreasing(fromidx,toidx);
            
            rangeimage = squeeze(sum(reshape(this.yvals(:,fromidx:toidx),this.ypixels,this.xpixels,[]),3));
            rangeimage = ChiPicture(rangeimage,this.xpixels,this.ypixels);
        end        
        
        %% summedrangeimagefromxvalues : Calculate image over a given summed range
        function rangeimage = summedrangeimagefromxvalues(this,fromxval,toxval)
            % Calculate image over a given summed range
            
            % Determine the index values of the xvalue limits
            [fromvalue,fromidx] = min(abs(this.xvals-fromxval));
            [tovalue,toidx] = min(abs(this.xvals-toxval));
            rangeimage = summedrangeimagefromindexvals(this,fromidx,toidx);
        end        
        
        %% spectrumat : Get spectrum at a given location in the image
        function spectrum = spectrumat(this,xpos,ypos)
            % Get spectrum at a given location in the image
            
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
            % UPDATE 27/10/2104: Now a handle class so may not matter. 
            
            y = reshape(this.yvals,this.ypixels,this.xpixels,[]);
            spectrum = squeeze(y(xpos,ypos,:));
            spectrum = ChiSpectrum(this.xvals,spectrum,this.reversex,this.xlabel,this.ylabel);

%             this.yvals=reshape(this.yvals,this.ypixels,this.xpixels,[]);
%             spectrum = squeeze(this.yvals(xpos,ypos,:));
%             spectrum = ChiSpectrum(this.xvals,spectrum,this.reversex,this.xlabel,this.ylabel);
%             this.yvals=reshape(this.yvals,this.ypixels*this.xpixels,[]);
        end
        
        %% removerangefromindexvals : Remove a spectral range using index values
        function output = removerangefromindexvals(this,fromidx,toidx)
            % Remove a spectral range using index values
            
            % Swap if 'from' is higher than 'to'
            [fromidx,toidx] = ChiForceIncreasing(fromidx,toidx);

            fromidx = fromidx-1;
            toidx = toidx+1;
            
            tempyvals = [this.yvals(:,1:fromidx),this.yvals(:,toidx:end)];
            tempxvals = [this.xvals(1:fromidx),this.xvals(toidx:end)];
            output = ChiImage(tempxvals,tempyvals,this.reversex,this.xlabel,this.ylabel,this.xpixels,this.ypixels);
        end
        
        %% removerangefromxvalues : Remove a spectral range using x values
        function output = removerangefromxvalues(this,fromxval,toxval)
            % Remove a spectral range using x values
            
            % Determine the index values of the xvalue limits
            [fromvalue,fromidx] = min(abs(this.xvals-fromxval));
            [tovalue,toidx] = min(abs(this.xvals-toxval));
            output = removerangefromindexvals(this,fromidx,toidx);
        end        
                
    end % methods
end % class ChiImage 

