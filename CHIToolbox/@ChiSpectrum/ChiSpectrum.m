classdef ChiSpectrum < handle & ChiSpectralCharacter
% CHISPECTRUM Storage class for a single spectrum
% Copyright (c) 2014 Alex Henderson (alex.henderson@manchester.ac.uk)
    
    % matlab.mixin.Copyable only for >R2011a
    % Want compatibility with R2009a
    
    %% Basic properties
    properties
        xvals;  % abscissa as a row vector
        data;  % ordinate as a row vector
        reversex@logical = false; % should abscissa be plotted increasing (false = default) or decreasing (true)
        xlabel@char = ''; % text for abscissa label on plots (default = empty)
        ylabel@char = ''; % text for ordinate label on plots (default = empty)
        history@ChiLogger;
    end
    
    %% Methods
    methods
        %% Constructor
        function this = ChiSpectrum(xvals,data,reversex,xlabel,ylabel)
            % Create an instance of ChiSpectrum with given parameters
            
            if (nargin > 0) % Support calling with 0 arguments
                
                if (length(xvals) ~= length(data))
                    err = MException('CHI:ChiSpectrum:DimensionalityError', ...
                        'x and y data are different lengths');
                    throw(err);
                end                    
                
                this.xvals = xvals;
                this.data = data;
                this.history = ChiLogger();
                
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
        
        %% clone : Make a copy of this spectrum
        function output = clone(this)
            % Make a copy of this spectrum
            output = ChiSpectrum(this.xvals,this.data,this.reversex,this.xlabel,this.ylabel);
            output.history = this.history;
        end
    end % methods
    
end