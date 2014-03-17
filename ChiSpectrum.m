classdef ChiSpectrum
    %CHISPECTRUM Storage class for a single spectrum
    %   Detailed explanation goes here
    
    %% Basic properties
    properties
        xvals;  % row
        yvals;  % row
        reversex = false;
        xlabel = '';
        ylabel = '';
    end
    
    %% Calculated properties
    properties (Dependent = true, SetAccess = private)
        channels;
    end
    
    %% Methods
    methods
        %% Constructor
        function this = ChiSpectrum(xvals,yvals,reversex,xlabel,ylabel)
            if (nargin > 0) % Support calling with 0 arguments
                this.xvals = xvals;
                this.yvals = yvals;
                
                % Force to row vectors
                [this.xvals] = ChiForceToRow(this.xvals);
                [this.yvals] = ChiForceToRow(this.yvals);
                
                if (nargin > 2)
                    this.reversex = reversex;
                    if (nargin > 3)
                        this.xlabel = xlabel;
                        this.ylabel = ylabel;
                    end
                end
            end 
        end
        
        %% channels : Calculate number of channels
        function channels = get.channels(this)
            channels = length(this.xvals);
        end
        
        %% sumrangeindex : Calculate the sum of a range of index values
        function sumrangeindex = sumrangeindex(this,fromidx,toidx)
            % Swap if 'from' is higher than 'to'
            [fromidx,toidx] = ChiForceIncreasing(fromidx,toidx);
            sumrangeindex = sum(this.yvals(fromidx:toidx));
        end
        
        %% sumrangexvals : Calculate the sum of a range of xvalues
        function sumrangexvals = sumrangex(this,fromxval,toxval)
            % Swap if 'from' is higher than 'to'
            [fromxval,toxval] = ChiForceIncreasing(fromxval,toxval);
            % Determine the index values of the xvalue limits
            [fromvalue,fromidx] = min(abs(this.xvals-fromxval));
            [tovalue,toidx] = min(abs(this.xvals-toxval));
            sumrangexvals = sumrangeindex(this,fromidx,toidx);
        end
        
        %% subspectrumindex : Extract part of the spectrum given a range of index values
        function subspectrumindex = subspectrumindex(this,fromidx,toidx)
            % Swap if 'from' is higher than 'to'
            [fromidx,toidx] = ChiForceIncreasing(fromidx,toidx);
            subspectrumindex = ChiSpectrum(this.xvals(fromidx:toidx),this.yvals(fromidx:toidx),this.reversex,this.xlabel,this.ylabel);
        end
        
        %% subspectrumxvals : Extract part of the spectrum given a range of xvalues
        function subspectrumxvals = subspectrumxvals(this,fromxval,toxval)
            % Swap if 'from' is higher than 'to'
            [fromxval,toxval] = ChiForceIncreasing(fromxval,toxval);
            % Determine the index values of the xvalue limits
            [fromvalue,fromidx] = min(abs(this.xvals-fromxval));
            [tovalue,toidx] = min(abs(this.xvals-toxval));
            subspectrumxvals = subspectrumindex(this,fromidx,toidx);
        end
        
        %% sum : Sum all values
        function total = sum(this)
            total = sum(this.yvals);
        end
        
        %% plot : Basic plot function
        function plot(this,varargin)
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