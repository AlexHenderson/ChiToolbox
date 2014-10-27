classdef ChiPicture < handle
    %CHIPICTURE Storage class for 2D images (not hyperspectral images)
    %   Detailed explanation goes here
    
    %% Properties
        %% Basic properties
        properties
            data;       % Contents of object
            xpixels;    % Number of pixels in the x-direction (width)
            ypixels;    % Number of pixels in the y-direction (height)
        end
    
    %% Methods
    methods        
        %% Constructor
        function this = ChiPicture(data,xpixels,ypixels)
            % Create an instance of ChiPicture with given parameters
            
            % TODO: Rehash this to check the options regarding the
            % dimensionality of the input data. Need additional checking to
            % manage pathological conditions such as being passed 3D data
            % by accident with a divisible number of x/y pixels. What we
            % have here isn't too bad, but needs refactored. 

            if (nargin > 0) % Support calling with 0 arguments
                switch (nargin)
                    case 1
                        % Only have the data
                        [dims]=size(data);
                        switch (dims)
                            case 2
                                % A 2D matrix so determine the dimensionality directly from the data
                                this.data = data;
                                this.xpixels = dims(2);
                                this.ypixels = dims(1);
                            otherwise
                                % Too many or too few dimensions. 
                                err = MException('CHI:ChiPicture:DimensionalityError', ...
                                    'Data is not 2D and is missing x and y dimensions');
                                throw(err);
                        end
                    case 2
                        % Have the data and the number of xpixels
                        [dims]=size(data);
                        switch (dims)
                            case 1
                                % We have a list of numbers and the number of
                                % xpixels. Calculate the ypixels.
                                if (rem(length(data),xpixels))
                                    % Didn't divide exactly so throw an
                                    % error
                                    err = MException('CHI:ChiPicture:DimensionalityError', ...
                                        'Data is not 2D and its length is not divisible by xpixels');
                                    throw(err);
                                else
                                    this.xpixels = xpixels;
                                    this.ypixels = length(data) / ypixels;
                                    this.data = reshape(data,xpixels,ypixels);
                                end
                            case 2
                                % A 2D matrix so determine the dimensionality directly from the data
                                this.data = data;
                                this.xpixels = dims(2);
                                this.ypixels = dims(1);
                            otherwise
                                % Too many dimensions
                                err = MException('CHI:ChiPicture:DimensionalityError', ...
                                    'Data is not 1D or 2D');
                                throw(err);
                        end
                    case 3
                        % We should have everything we need. Double check we've
                        % been told the correct information. 
                        if (numel(data) ~= (xpixels*ypixels))
                            % We've been given the wrong information
                            % regarding the number of data points. 
                            
                            if (length(size(data)) == 2)
                                % Just determine the dimensionality from
                                % the data and send a warning
                                warning('CHI:ChiPicture:DimensionalityIssue',...
                                    'xpixels and ypixels do not describe the data correctly. Determining dimensions automatically');
                                dims = size(data);
                                this.data = data;
                                this.xpixels = dims(2);
                                this.ypixels = dims(1);
                            else
                                % Can't rely on the information so throw an
                                % error
                                err = MException('CHI:ChiPicture:DimensionalityError', ...
                                    'Data is not 2D and its length is not divisible by xpixels and ypixels');
                                throw(err);
                            end
                        else
                            this.data = data;
                            this.xpixels = xpixels;
                            this.ypixels = ypixels;
                        end
                    otherwise
                        err = MException('CHI:ChiPicture:UsageError', ...
                            'Too many input variables');
                        throw(err);
                end
            end
        end
        
        %% getat : Get value at a location in the image
        function value = getat(this,xpos,ypos)
            % Get value at a location in the image
            
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
            % Basic imagesc function
            
            imagesc(this.data,varargin{:});
            axis image;
            axis off;
        end        
        
    end    
end

