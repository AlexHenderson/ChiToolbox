classdef ChiSpectrum < ChiAbstractSpectrum
% ChiSpectrum Storage class for a single spectrum
% Copyright (c) 2014 Alex Henderson (alex.henderson@manchester.ac.uk)
    
    % matlab.mixin.Copyable only for >R2011a
    % Want compatibility with R2009a
    
    % ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    properties
        xvals;      % Abscissa as a row vector
        data;       % Contents of object as a 2D matrix, spectra in rows
        reversex;   % Should abscissa be plotted in decreasing order
        xlabelname = ''; % Text for abscissa label on plots
        xlabelunit = ''; % Text for the abscissa label unit on plots
        ylabelname = ''; % Text for ordinate label on plots
        ylabelunit = ''; % Text for the ordinate label unit on plots
        classmembership % An instance of ChiClassMembership
        filenames = {};    % Name of file opened, if appropriate
        history     % Log of data processing steps
    end
    
    properties (Dependent = true)
    end
    
    methods
        % ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
        function this = ChiSpectrum(xvals,data,reversex,xlabelname,xlabelunit,ylabelname,ylabelunit)
            % Create an instance of ChiSpectrum with given parameters
            
            if (nargin > 0) % Support calling with 0 arguments
                
                if (length(xvals) ~= length(data))
                    err = MException(['CHI:',mfilename,':DimensionalityError'], ...
                        'x and y data are different lengths');
                    throw(err);
                end                    
                
                this.xvals = xvals;
                this.data = data;
                this.reversex = 0;
                this.xlabelname = '';
                this.xlabelunit = '';
                this.ylabelname = '';                
                this.ylabelunit = '';                
                this.history = ChiLogger();
                
                % Force to row vectors
                this.xvals = ChiForceToRow(this.xvals);
                this.data = ChiForceToRow(this.data);
                
                if (nargin > 2)
                    this.reversex = reversex;
                    if (nargin > 3)
                        this.xlabelname = xlabelname;
                        this.xlabelunit = xlabelunit;
                        this.ylabelname = ylabelname;
                        this.ylabelunit = ylabelunit;
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
            
            this.ontologyinfo = ChiOntologyInformation();
            this.ontologyinfo.term = 'spectrum';
            this.ontologyinfo.description = ['A plot of a measured ' ...
                'quantity against some experimental parameter. ' ...
                '[database_cross_reference: rsc:cb]'];
            this.ontologyinfo.uri = 'http://purl.obolibrary.org/obo/CHMO_0000800';
            this.ontologyinfo.isaccurate = true;            
            
        end
        
        % ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
        function output = clone(this)
            % Make a copy of this spectrum
            output = ChiSpectrum(this.xvals,this.data,this.reversex,this.xlabelname,this.xlabelunit,this.ylabelname,this.xlabelunit);
            output.filenames = this.filenames;
            output.history = this.history.clone();
        end        
        
        % ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    end % methods
    
end