classdef (Abstract) ChiAbstractSpectralCollection < ChiBase
    
% ChiAbstractSpectralCollection  Abstract class to define collections of spectra
% Copyright (c) 2017 Alex Henderson (alex.henderson@manchester.ac.uk)

% Here we manage the data as a 2D object

    properties (Abstract)
        xvals;      % Abscissa as a row vector
        data;       % Contents of object as a 2D matrix, spectra in rows
        reversex;   % Should abscissa be plotted in decreasing order
        xlabelname; % Text for abscissa label on plots
        xlabelunit; % Text for the abscissa label unit on plots
        ylabelname; % Text for ordinate label on plots
        ylabelunit; % Text for the ordinate label unit on plots
        dynamicproperties; % Storage space for instance specific properties
    end

    properties
        spectrumclassname;  % The name of the class if a single spectrum is selected
    end

    properties
        % The definition of this data using ontological descriptors (see ChiOntologyInformation).
        ontologyinfo
    end    
    
    properties (Dependent = true, SetAccess = protected)
        numchannels;    % Number of data points
        numspectra;     % Number of spectra
        xlabel          % Composition of the xlabelname and the xlabelunit
        ylabel          % Composition of the ylabelname and the ylabelunit
        
    end
    
    % =====================================================================
    methods
    % =====================================================================
        % numchannels : Calculate number of data points in the spectra
        function numchannels = get.numchannels(this)
            % Calculate number of data points per spectrum
            numchannels = size(this.data,2);
        end
        
        % ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
        % numspectra : Calculate number of spectra in the collection
        function numspectra = get.numspectra(this)
            % Calculate number of spectra in this collection
            numspectra = size(this.data,1);
        end
        
        % ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
        function xlabel = get.xlabel(this)
            if isempty(this.xlabelunit)
                xlabel = this.xlabelname;
            else
                xlabel = [this.xlabelname, ' (', this.xlabelunit, ')'];
            end                
        end
        
        % ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
        function ylabel = get.ylabel(this)
            if isempty(this.ylabelunit)
                ylabel = this.ylabelname;
            else
                ylabel = [this.ylabelname, ' (', this.ylabelunit, ')'];
            end                
        end
        
        % ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
        function result = issparse(this)
        % Determine whether the data is stored as a sparse matrix
            result = issparse(this.data);
        end
        
        % ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
        function result = isfull(this)
        % Determine whether the data is stored as a full (dense) matrix
            result = ~issparse(this.data);
        end
        
        % ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
        
    end
    
end
