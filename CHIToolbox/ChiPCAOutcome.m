classdef ChiPCAOutcome
%ChiPCAOutcome
%   Copyright (c) 2014 Alex Henderson (alex.henderson@manchester.ac.uk)
    
    properties
        scores;
        loadings;
        pev; % percentage_explained_variance;
        variances;
        xvals;
        xpixels;    % Number of pixels in the x-direction (width)
        ypixels;    % Number of pixels in the y-direction (height)
        log;
    end
    
    methods
        %% Constructor
        function this = ChiPCAOutcome(scores,loadings,pev,xpixels,ypixels)
            % Create an instance of ChiPCAOutcome with given parameters
            
            % TODO: Rehash this to check the options regarding the
            % dimensionality of the input data. Need additional checking to
            % manage pathological conditions such as being passed 3D data
            % by accident with a divisible number of x/y pixels. What we
            % have here isn't too bad, but needs refactored. 

            if (nargin > 0) % Support calling with 0 arguments
                
                if (length(xvals) ~= length(data))
                    err = MException('CHI:ChiPCAOutcome:DimensionalityError', ...
                        'x and y data are different lengths');
                    throw(err);
                end                    
                
                this.xvals = xvals;
                this.data = data;
                this.log = cell(1);
                
                % Force to row vectors
                this.xvals = ChiForceToRow(this.xvals);
                this.data = ChiForceToRow(this.data);
                
                if (nargin > 2)
                    this.reversex = reversex;
                    if (nargin > 3)
                        this.xlabel = xlabel;
                        this.ylabel = ylabel;
                    end
                end
                
                % TODO: Could check that xvals is always increasing and not
                % a jumble of random points (a monotonically increasing
                % vector). Perhaps later. 
                
                % Check the abscissa is increasing, 
                % otherwise flip xvals and data
                if (this.xvals(1) > this.xvals(end))
                    this.xvals = fliplr(this.xvals);
                    this.data = fliplr(this.data);
                    this.reversex = true;
                end
            end 
        end
        
        
    end
    
end

