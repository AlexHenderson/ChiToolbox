classdef ChiPicture < handle & ChiSpatialCharacter
% CHIPICTURE Storage class for 2D images (not hyperspectral images)
% Copyright (c) 2014 Alex Henderson (alex.henderson@manchester.ac.uk)
    
    % matlab.mixin.Copyable only for >R2011a
    % Want compatibility with R2009a
    
    %% Properties
        %% Basic properties
        properties
            data;       % Contents of object as a 2D matrix
            history@ChiLogger;
        end
    
        properties (SetAccess = protected)
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
                this.history = ChiLogger();
                switch (nargin)
                    case 1
                        % Only have the data
                        [dims]=size(data);
                        switch (length(dims))
                            case 2
                                % A 2D matrix so determine the dimensionality directly from the data
                                this.xpixels = dims(2);
                                this.ypixels = dims(1);
                                this.data = reshape(data,this.ypixels,this.xpixels);
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
                                    this.data = reshape(data,this.ypixels,this.xpixels);
                                end
                            case 2
                                % A 2D matrix so determine the dimensionality directly from the data
                                this.xpixels = dims(2);
                                this.ypixels = dims(1);
                                this.data = reshape(data,this.ypixels,this.xpixels);
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
                                this.xpixels = dims(2);
                                this.ypixels = dims(1);
                                this.data = reshape(data,this.ypixels,this.xpixels);
                            else
                                % Can't rely on the information so throw an
                                % error
                                err = MException('CHI:ChiPicture:DimensionalityError', ...
                                    'Data is not 2D and its length is not divisible by xpixels and ypixels');
                                throw(err);
                            end
                        else
                            this.xpixels = xpixels;
                            this.ypixels = ypixels;
                            this.data = reshape(data,this.ypixels,this.xpixels);
                        end
                    otherwise
                        err = MException('CHI:ChiPicture:UsageError', ...
                            'Too many input variables');
                        throw(err);
                end
            end
        end
        
        %% clone
        function output = clone(this)
            % Make a copy of this picture
            output = ChiPicture(this.data,this.xpixels,this.ypixels);
            output.history = this.history;
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
end % class 

