classdef ChiSpectrum < ChiAbstractSpectrum
% ChiSpectrum Storage class for a single spectrum
% Copyright (c) 2014 Alex Henderson (alex.henderson@manchester.ac.uk)
    
    
    % ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    properties
        xvals            % Abscissa as a row vector
        data             % Contents of object as a 2D matrix, spectra in rows
        reversex = false % Should abscissa be plotted in decreasing order
        xlabelname = ''; % Text for abscissa label on plots
        xlabelunit = ''; % Text for the abscissa label unit on plots
        ylabelname = ''; % Text for ordinate label on plots
        ylabelunit = ''; % Text for the ordinate label unit on plots
        classmembership = [];   % An instance of ChiClassMembership
        filenames = {};         % Name of file opened, if appropriate
        history = ChiLogger();  % Log of data processing steps
        dynamicproperties; % Storage space for instance specific properties
    end
    
    properties (Dependent = true)
    end
    
    methods
        % ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
        function this = ChiSpectrum(xvals,data,reversex,xlabelname,xlabelunit,ylabelname,ylabelunit,classmembership,filenames,varargin)
            % Create an instance of ChiSpectrum with given parameters

            argposition = find(cellfun(@(x) isa(x,'ChiLogger') , varargin));
            if argposition
                this.history = varargin{argposition}.clone;
                varargin(argposition) = []; %#ok<NASGU>
            else
                this.history = ChiLogger();
            end
            
            if (nargin > 0) % Support calling with 0 arguments
                
                if exist('xvals','var')
                    this.xvals = xvals;
                end
                if exist('data','var')
                    this.data = data;
                end
                
                if (length(xvals) ~= length(data))
                    err = MException(['CHI:',mfilename,':DimensionalityError'], ...
                        'x and y data are different lengths');
                    throw(err);
                end
                
                if exist('reversex','var')
                    this.reversex = reversex;
                end
                if exist('xlabelname','var')
                    this.xlabelname = xlabelname;
                end
                if exist('xlabelunit','var')
                    this.xlabelunit = xlabelunit;
                end
                if exist('ylabelname','var')
                    this.ylabelname = ylabelname;                
                end
                if exist('ylabelunit','var')
                    this.ylabelunit = ylabelunit;
                end
                if exist('classmembership','var')
                    if isa(classmembership,'ChiClassMembership')
                        this.classmembership = classmembership.clone();
                    end
                end
                if exist('filenames','var')
                    this.filenames = filenames;
                end
                
                % Force to row vectors
                if ~isempty(this.xvals)
                    this.xvals = utilities.force2row(this.xvals);
                end
                if ~isempty(this.data)
                    this.data = utilities.force2row(this.data);
                end
                
                % TODO: Could check that xvals is always increasing and not
                % a jumble of random points (a monotonically increasing
                % vector). Perhaps later. 
                
                % Check the abscissa is increasing, 
                % otherwise flip xvals and data
                if ~isempty(this.xvals) && ~isempty(this.data)
                    if (this.xvals(1) > this.xvals(end))
                        this.xvals = fliplr(this.xvals);
                        this.data = fliplr(this.data);
                        this.reversex = true;
                    end
                end
            end 
            
            this.spectralcollectionclassname = 'ChiSpectralCollection';
            
            this.ontologyinfo = ChiOntologyInformation();
            this.ontologyinfo.term = 'spectrum';
            this.ontologyinfo.description = ['A plot of a measured ' ...
                'quantity against some experimental parameter. ' ...
                '[database_cross_reference: rsc:cb]'];
            this.ontologyinfo.uri = 'http://purl.obolibrary.org/obo/CHMO_0000800';
            this.ontologyinfo.isaccurate = true;            
            
        end
        
        % ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    end % methods
    
end