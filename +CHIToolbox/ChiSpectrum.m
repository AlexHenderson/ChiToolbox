classdef ChiSpectrum < handle & ChiCloneable
    %CHISPECTRUM Storage class for a single spectrum
%   Copyright (c) 2014 Alex Henderson (alex.henderson@manchester.ac.uk)
    
    % matlab.mixin.Copyable only for >R2011a
    % Want compatibility with R2009a
    
    %% Basic properties
    properties
        xvals;  % abscissa as a row vector
        yvals;  % ordinate as a row vector
        reversex = false; % should abscissa be plotted increasing (false = default) or decreasing (true)
        xlabel = ''; % text for abscissa label on plots (default = empty)
        ylabel = ''; % text for ordinate label on plots (default = empty)
    end
    
    %% Calculated properties
    properties (Dependent = true, SetAccess = private)
        channels; % number of data points
    end
    
    %% Methods
    methods
        %% Constructor
        function this = ChiSpectrum(xvals,yvals,reversex,xlabel,ylabel)
            % Create an instance of ChiSpectrum with given parameters
            
            if (nargin > 0) % Support calling with 0 arguments
                
                if (length(xvals) ~= length(yvals))
                    err = MException('CHI:ChiPicture:DimensionalityError', ...
                        'x and y data are different lengths');
                    throw(err);
                end                    
                
                this.xvals = xvals;
                this.yvals = yvals;
                
                % Force to row vectors
                this.xvals = ChiForceToRow(this.xvals);
                this.yvals = ChiForceToRow(this.yvals);
                
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
                % otherwise flip xvals and yvals
                if (this.xvals(1) > this.xvals(end))
                    this.xvals = fliplr(this.xvals);
                    this.yvals = fliplr(this.yvals);
                    this.reversex = true;
                end
            end 
        end
        
        %% delete : Destructor
        function delete(this)
            % Destructor
            
            % Nothing to do
        end
        
        %% channels : Calculate number of channels
        function channels = get.channels(this)
            % Calculate number of channels
            
            channels = length(this.xvals);
        end
        
        %% sum : Sum all values
        function total = sum(this)
            % Sum all values
            
            total = sum(this.yvals);
        end
        
        %% sumrangeindex : Calculate the sum of a range of index values
        function sumrangeindex = sumrangeindex(this,fromidx,toidx)
            % Calculate the sum of a range of index values
            
            % Swap if 'from' is higher than 'to'
            [fromidx,toidx] = ChiForceIncreasing(fromidx,toidx);
            sumrangeindex = sum(this.yvals(fromidx:toidx));
        end
        
        %% sumrangexvals : Calculate the sum of a range of xvalues
        function sumrangexvals = sumrangex(this,fromxval,toxval)
            % Calculate the sum of a range of xvalues
            
            % Swap if 'from' is higher than 'to'
            [fromxval,toxval] = ChiForceIncreasing(fromxval,toxval);
            % Determine the index values of the xvalue limits
            [fromvalue,fromidx] = min(abs(this.xvals-fromxval));
            [tovalue,toidx] = min(abs(this.xvals-toxval));
            sumrangexvals = sumrangeindex(this,fromidx,toidx);
        end
        
        %% subspectrumindex : Extract part of the spectrum given a range of index values
        function subspectrumindex = subspectrumindex(this,fromidx,toidx)
            % Extract part of the spectrum given a range of index values
            
            % Swap if 'from' is higher than 'to'
            [fromidx,toidx] = ChiForceIncreasing(fromidx,toidx);
            subspectrumindex = ChiSpectrum(this.xvals(fromidx:toidx),this.yvals(fromidx:toidx),this.reversex,this.xlabel,this.ylabel);
        end
        
        %% subspectrumxvals : Extract part of the spectrum given a range of xvalues
        function subspectrumxvals = subspectrumxvals(this,fromxval,toxval)
            % Extract part of the spectrum given a range of xvalues
            
            % Swap if 'from' is higher than 'to'
            [fromxval,toxval] = ChiForceIncreasing(fromxval,toxval);
            % Determine the index values of the xvalue limits
            [fromvalue,fromidx] = min(abs(this.xvals-fromxval));
            [tovalue,toidx] = min(abs(this.xvals-toxval));
            subspectrumxvals = subspectrumindex(this,fromidx,toidx);
        end
        
        %% removerangefromindexvals : Remove a spectral range using index values
        function output = removerangefromindexvals(this,fromidx,toidx)
            % Remove a spectral range using index values
            
            % Swap if 'from' is higher than 'to'
            [fromidx,toidx] = ChiForceIncreasing(fromidx,toidx);

            fromidx = fromidx-1;
            toidx = toidx+1;
            
            tempyvals = [this.yvals(1:fromidx),this.yvals(toidx:end)];
            tempxvals = [this.xvals(1:fromidx),this.xvals(toidx:end)];
            output = ChiSpectrum(tempxvals,tempyvals,this.reversex,this.xlabel,this.ylabel);        
        end
        
        %% removerangefromxvalues : Remove a spectral range using x values
        function output = removerangefromxvalues(this,fromxval,toxval)
            % Remove a spectral range using x values
            
            % Determine the index values of the xvalue limits
            [fromvalue,fromidx] = min(abs(this.xvals-fromxval));
            [tovalue,toidx] = min(abs(this.xvals-toxval));
            output = removerangefromindexvals(this,fromidx,toidx);
        end        
        
        %% plot : Basic plot function
        function plot(this,varargin)
            % Basic plot function
            
            plot(this.xvals,this.yvals,varargin{:});
            axis tight;
            if (this.reversex)
                set(gca,'XDir','reverse');
            end
            if (~isempty(this.xlabel))
                set(get(gca,'XLabel'),'String',this.xlabel);
            end
            if (~isempty(this.ylabel))
                set(get(gca,'YLabel'),'String',this.ylabel);
            end
        end

    end % methods
    
end