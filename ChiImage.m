classdef ChiImage < handle & ChiCloneable
%CHIIMAGE Storage class for hyperspectral images
%   Copyright (c) 2014 Alex Henderson (alex.henderson@manchester.ac.uk)
    
    % matlab.mixin.Copyable only for >R2011a
    % Want compatibility with R2009a
    
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
            mask@logical;
            masked@logical = false;
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
        function this = ChiImage(xvals,yvals,reversex,xlabel,ylabel,xpixels,ypixels,masked,mask)
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
                            if (nargin > 7)
                                this.masked = masked;
                                this.mask = mask;
                            end
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
                        this.yvals = reshape(this.yvals,this.ypixels*this.xpixels,[]);
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
            
            totrows = sum(this.yvals,2);
            
            if (this.masked)
                unmasked = zeros(size(totrows));
                totindex = 1;
                for i = 1:length(this.mask)
                    if (this.mask(i))
                        % Insert the non-zero values back into the required
                        % locations. 
                        unmasked(i) = totrows(totindex);
                        totindex = totindex + 1;
                    end
                end
                totrows = unmasked;
            end
            
            totalimage = ChiPicture(totrows,this.xpixels,this.ypixels);
        end        
        
        %% summedrangeimagefromindexvals : Calculate image over a given summed range
        function rangeimage = summedrangeimagefromindexvals(this,fromidx,toidx)
            % Calculate image over a given summed range
            
            if (~exist('toidx','var'))
                % only have a single index value so only use that position
                toidx = fromidx;
            end
            
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
            
            totrows = sum(this.yvals(:,fromidx:toidx),2);
            
            if (this.masked)
                unmasked = zeros(size(totrows));
                totindex = 1;
                for i = 1:length(this.mask)
                    if (this.mask(i))
                        % Insert the non-zero values back into the required
                        % locations. 
                        unmasked(i) = totrows(totindex);
                        totindex = totindex + 1;
                    end
                end
                totrows = unmasked;
            end
            
            rangeimage = ChiPicture(totrows,this.xpixels,this.ypixels);
        end        
        
        %% summedrangeimagefromxvalues : Calculate image over a given summed range
        function rangeimage = summedrangeimagefromxvalues(this,fromxval,toxval)
            % Calculate image over a given summed range
            
            if (~exist('toxval','var'))
                % only have a single x value so only use that position
                toxval = fromxval;
            end
            
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
            
            if (this.masked)
                this.mask = reshape(this.mask, this.ypixels, this.xpixels);
                if (this.mask(ypos,xpos) == false)
                    % This is a pixel we've rejected so return zeros
                    spectrumdata=zeros(1,this.channels());
                end
            else
                y = reshape(this.yvals,this.ypixels,this.xpixels,[]);
                spectrumdata = squeeze(y(xpos,ypos,:));
            end
            
            spectrum = ChiSpectrum(this.xvals,spectrumdata,this.reversex,this.xlabel,this.ylabel);

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
            % TODO: copy/clone?
            output = ChiImage(tempxvals,tempyvals,this.reversex,this.xlabel,this.ylabel,this.xpixels,this.ypixels,this.masked,this.mask);
        end
        
        %% removerangefromxvalues : Remove a spectral range using x values
        function output = removerangefromxvalues(this,fromxval,toxval)
            % Remove a spectral range using x values
            
            % Determine the index values of the xvalue limits
            [fromvalue,fromidx] = min(abs(this.xvals-fromxval));
            [tovalue,toidx] = min(abs(this.xvals-toxval));
            output = removerangefromindexvals(this,fromidx,toidx);
        end
        
        %% denoise : Denoise using PCA
        
        % Split out as a standalone function: ChiDenoise
        
%         function output = denoise(this,numpcs)
%             % Denoise using PCA
%             
%             % Clone this object
% %            output = copy(this);
%             output = clone(this);
%             
%             % TODO: Check reuseability of the PCA code (licence etc.)
%             [scores, loadings] = alex_pca(this.yvals, numpcs, 'nipals');
% 
%             denoised=scores(:,1:numpcs)*loadings(:,1:numpcs)';
%             denoised=denoised+repmat(mean(this.yvals),size(denoised,1),1);
%             
%             output.yvals = denoised;            
%         end
        
        %% applymask : Remove unwanted pixels
        function output = applymask(this, mask)
            % Remove unwanted pixels
            
            % Check mask is the right size
            if(numel(mask) ~= (this.xpixels * this.ypixels))
                err = MException('CHI:ChiImage:OutOfRange', ...
                    'mask is wrong size');
                throw(err);
            end

            % TODO: Handle situation where the data is already masked. 
            
            % Clone this object
%            output = copy(this);
            output = clone(this);
            
            % Determine the dimensionality of the mask and make 1D
            output.mask = logical(reshape(mask,(this.xpixels * this.ypixels), 1));

            % Remove the pixels
            output.yvals = this.yvals(output.mask, :);
            output.masked = true;
        end
        
        %% crop : Crop image to produce a smaller subset
        function output = crop(this, lowx,highx, lowy,highy)
            % Generate a subset of the image using xy co-ordinates
            
            if ((lowx < 1) || (highx < 1) || (lowy < 1) || (highy < 1))
                err = MException('CHI:ChiImage:OutOfRange', ...
                    'Requested range is invalid');
                throw(err);
            end
            
            % Swap if 'from' is higher than 'to'
            [lowx,highx] = ChiForceIncreasing(lowx,highx);
            % Swap if 'from' is higher than 'to'
            [lowy,highy] = ChiForceIncreasing(lowy,highy);

            % Check for out of range values
            if (lowx > this.xpixels) || (highx > this.xpixels)
                err = MException('CHI:ChiImage:OutOfRange', ...
                    'Requested x range is too low/high');
                throw(err);
            end            
            if (lowy > this.ypixels) || (highy > this.ypixels)
                err = MException('CHI:ChiImage:OutOfRange', ...
                    'Requested y range is too low/high');
                throw(err);
            end
            
            % Clone this object
%            output = copy(this);
            output = clone(this);

            % Remove the pixels
            if (~this.masked)
                output.yvals = reshape(output.yvals, this.xpixels, this.ypixels, []);
                output.yvals = output.yvals(lowy:highy, lowx:highx, :);
                [dims] = size(output.yvals);
                output.xpixels = dims(2);
                output.ypixels = dims(1);
                output.yvals = reshape(output.yvals, output.ypixels * output.xpixels, []);
            else
                output.mask = reshape(this.mask, this.xpixels, this.ypixels, []);
                output.mask = output.mask(lowy:highy, lowx:highx);
                if (all(all(output.mask)))
                    % All pixels in this cropped region are unmasked in the
                    % original. Therefore the output doesn't require a
                    % mask. 
%                     output.yvals = reshape(output.yvals, this.xpixels, this.ypixels, []);
%                     output.yvals = output.yvals(lowy:highy, lowx:highx, :);
%                     [dims] = size(output.yvals);
%                     output.xpixels = dims(2);
%                     output.ypixels = dims(1);
%                     output.yvals = reshape(output.yvals, output.ypixels * output.xpixels, []);
%                     output.mask = reshape(output.mask, output.xpixels * output.ypixels);
%                     output.masked = false;
                       
% We can't just reshape the data and identify the required pixels since the
% data isn't rectilinear. 

                    % TODO: write code
                    err = MException('CHI:ChiImage:TODO', ...
                        'This code has yet to be written.');
                    throw(err);
                else
                    if (all(all(~output.mask)))
                        % All pixels in this cropped region are masked in
                        % the original. Therefore the output is empty. 
                        err = MException('CHI:ChiImage:DimensionalityError', ...
                            'All requested pixels have been masked.');
                        throw(err);
                    else
                        % Some pixels are masked and some are not. 
                        % TODO: write code
                        err = MException('CHI:ChiImage:TODO', ...
                            'This code has yet to be written.');
                        throw(err);
                    end
                end
            end 
        end
        
        %% ratioxvals : Generate ChiPicture of a ratio of spectral ranges using xvalues
        function output = ratioxvals(this,numerator,denominator)
            % Generate ChiPicture of a ratio of spectral ranges using xvalues
            
            dims = size(numerator);
            switch(length(dims))
                case 1
                    % Single x value
                    [numeratorvalue,numeratoridx] = min(abs(this.xvals-numerator));
                case 2
                    % Range of x values to sum over
                    [numeratorvalue1,numeratoridx1] = min(abs(this.xvals-numerator(1)));
                    [numeratorvalue2,numeratoridx2] = min(abs(this.xvals-numerator(2)));
                    numeratoridx = [numeratoridx1, numeratoridx2];
                otherwise
                    % Error
                    err = MException('CHI:ChiImage:DimensionalityError', ...
                        'Numerator range is not a single value or simple range.');
                    throw(err);
            end
            
            dims = size(denominator);
            switch(length(dims))
                case 1
                    % Single x value
                    [denominatorvalue,denominatoridx] = min(abs(this.xvals-denominator));
                case 2
                    % Range of x values to sum over
                    [denominatorvalue1,denominatoridx1] = min(abs(this.xvals-denominator(1)));
                    [denominatorvalue2,denominatoridx2] = min(abs(this.xvals-denominator(2)));
                    denominatoridx = [denominatoridx1, denominatoridx2];
                otherwise
                    % Error
                    err = MException('CHI:ChiImage:DimensionalityError', ...
                        'Denominator range is not a single value or simple range.');
                    throw(err);
            end
            
            output = ratioindex(this,numeratoridx,denominatoridx);
        end % ratioxvals
        
        %% ratioindex : Generate ChiPicture of a ratio of spectral ranges using index values
        function output = ratioindex(this,numerator,denominator)
            % Generate ChiPicture of a ratio of spectral ranges using index values
            
            dims = size(numerator);
            switch(length(dims))
                case 1
                    % Single index value
                    numerator_data = this.yvals(:,numerator);
                case 2
                    % Range of index values to sum over
                    numerator_data = sum(this.yvals(:,numerator(1):numerator(2)));
                otherwise
                    % Error
                    err = MException('CHI:ChiImage:DimensionalityError', ...
                        'Numerator range is not a single value or simple range.');
                    throw(err);
            end
            
            dims = size(denominator);
            switch(length(dims))
                case 1
                    % Single index value
                    denominator_data = this.yvals(:,denominator);
                case 2
                    % Range of index values to sum over
                    denominator_data = sum(this.yvals(:,denominator(1):denominator(2)));
                otherwise
                    % Error
                    err = MException('CHI:ChiImage:DimensionalityError', ...
                        'Denominator range is not a single value or simple range.');
                    throw(err);
            end
            
            the_ratio = numerator_data ./ denominator_data;

            if (this.masked)
                unmasked = zeros(this.ypixels,this.xpixels);
                totindex = 1;
                for i = 1:length(this.mask)
                    if (this.mask(i))
                        % Insert the non-zero values back into the required
                        % locations. 
                        unmasked(i) = the_ratio(totindex);
                        totindex = totindex + 1;
                    end
                end
                the_ratio = unmasked;
            end
            
            output = ChiPicture(the_ratio,this.xpixels,this.ypixels);
            
        end % ratioindex        

        %% proportionxvals : Generate ChiPicture of a proportion of spectral ranges using xvalues
        function output = proportionxvals(this,numerator,denominator)
            % Generate ChiPicture of a proportion of spectral ranges using xvalues
            
            dims = size(numerator);
            switch(length(dims))
                case 1
                    % Single x value
                    [numeratorvalue,numeratoridx] = min(abs(this.xvals-numerator));
                case 2
                    % Range of x values to sum over
                    [numeratorvalue1,numeratoridx1] = min(abs(this.xvals-numerator(1)));
                    [numeratorvalue2,numeratoridx2] = min(abs(this.xvals-numerator(2)));
                    numeratoridx = [numeratoridx1, numeratoridx2];
                otherwise
                    % Error
                    err = MException('CHI:ChiImage:DimensionalityError', ...
                        'Numerator range is not a single value or simple range.');
                    throw(err);
            end
            
            dims = size(denominator);
            switch(length(dims))
                case 1
                    % Single x value
                    [denominatorvalue,denominatoridx] = min(abs(this.xvals-denominator));
                case 2
                    % Range of x values to sum over
                    [denominatorvalue1,denominatoridx1] = min(abs(this.xvals-denominator(1)));
                    [denominatorvalue2,denominatoridx2] = min(abs(this.xvals-denominator(2)));
                    denominatoridx = [denominatoridx1, denominatoridx2];
                otherwise
                    % Error
                    err = MException('CHI:ChiImage:DimensionalityError', ...
                        'Denominator range is not a single value or simple range.');
                    throw(err);
            end
            
            output = proportionindex(this,numeratoridx,denominatoridx);
        end % proportionxvals
        
        %% proportionindex : Generate ChiPicture of a proportion of spectral ranges using index values
        function output = proportionindex(this,numerator,denominator)
            % Generate ChiPicture of a proportion of spectral ranges using index values
            
            dims = size(numerator);
            switch(length(dims))
                case 1
                    % Single index value
                    numerator_data = this.yvals(:,numerator);
                case 2
                    % Range of index values to sum over
                    numerator_data = sum(this.yvals(:,numerator(1):numerator(2)));
                otherwise
                    % Error
                    err = MException('CHI:ChiImage:DimensionalityError', ...
                        'Numerator range is not a single value or simple range.');
                    throw(err);
            end
            
            dims = size(denominator);
            switch(length(dims))
                case 1
                    % Single index value
                    denominator_data = this.yvals(:,denominator);
                case 2
                    % Range of index values to sum over
                    denominator_data = sum(this.yvals(:,denominator(1):denominator(2)));
                otherwise
                    % Error
                    err = MException('CHI:ChiImage:DimensionalityError', ...
                        'Denominator range is not a single value or simple range.');
                    throw(err);
            end
            
            the_proportion = numerator_data ./ (numerator_data + denominator_data);

            if (this.masked)
                unmasked = zeros(this.ypixels,this.xpixels);
                totindex = 1;
                for i = 1:length(this.mask)
                    if (this.mask(i))
                        % Insert the non-zero values back into the required
                        % locations. 
                        unmasked(i) = the_proportion(totindex);
                        totindex = totindex + 1;
                    end
                end
                the_proportion = unmasked;
            end
            
            output = ChiPicture(the_proportion,this.xpixels,this.ypixels);
            
        end % proportionindex        


    end % methods
end % class ChiImage 

