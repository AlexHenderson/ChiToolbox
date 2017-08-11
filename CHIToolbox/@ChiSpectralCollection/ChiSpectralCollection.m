classdef ChiSpectralCollection < ChiAbstractSpectralCollection
% ChiSpectralCollection Storage class for hyperspectral images
% Copyright (c) 2014 Alex Henderson (alex.henderson@manchester.ac.uk)
    
% ToDo: We need a mechanism of adding collections of spectra together. A
% collection could simply be a single spectrum or ChiSpectrum. We could
% interpolate these in the same manner as BiotofSpectrum. 


    % matlab.mixin.Copyable only for >R2011a
    % Want compatibility with R2009a
    
    %% Properties
        properties  
            %% Basic properties
            xvals;  % abscissa as a row vector
            data;  % ordinate as a 2D array (unfolded matrix)
            reversex = false; % should abscissa be plotted increasing (false = default) or decreasing (true)
            xlabel = ''; % text for abscissa label on plots (default = empty)
            ylabel = ''; % text for ordinate label on plots (default = empty)
            classmembership; % an instance of ChiClassMembership
            history;
        end

        properties (SetAccess = protected)
        end          
        
        properties (Dependent = true)
        %% Calculated properties
        end
    
    %% Methods
    methods
        %% Constructor
        function this = ChiSpectralCollection(xvals,data,reversex,xlabel,ylabel,varargin)
            % Create an instance of ChiImage with given parameters
            
            this.history = ChiLogger();
            if (nargin > 0) % Support calling with 0 arguments
                this.xvals = xvals;
                this.data = data;
                
                % Force x-values to row vector
                this.xvals = ChiForceToRow(this.xvals);

                % Force y-values to row vectors
                [rows,cols] = size(this.data);
                if (rows == cols)
                    utilities.warningnobacktrace('Data matrix is square. Assuming spectra are in rows.');
                else
                    if (rows == length(this.xvals))
                        this.data = this.data';
                    end
                end                      

                if (nargin > 2)
                    this.reversex = reversex;
                    if (nargin > 3)
                        this.xlabel = xlabel;
                        this.ylabel = ylabel;
                    end
                end
                % Reshape data into a 2D array
            end 
        end
        
        %% clone : Make a copy of this image
        function output = clone(this)
            % Make a copy of this image
            output = ChiSpectralCollection(this.xvals,this.data,this.reversex,this.xlabel,this.ylabel);
            output.classmembership = this.classmembership;
            output.history = this.history.clone();
        end
        
    end % methods
end % class ChiImage 

