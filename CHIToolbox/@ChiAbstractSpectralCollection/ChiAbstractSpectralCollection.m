classdef (Abstract) ChiAbstractSpectralCollection < handle
% ChiAbstractSpectralCollection  Abstract class to define collections of spectra
% Copyright (c) 2017 Alex Henderson (alex.henderson@manchester.ac.uk)

% Here we manage the data as a 2D object

    properties (Abstract)
        xvals;  % abscissa as a row vector
        data;       % Contents of object as a 2D matrix, spectra in rows
        reversex; % should abscissa be plotted increasing or decreasing
                  % true means plot high to low
%         reversex@logical; % should abscissa be plotted increasing or decreasing
%         xlabel@char; % text for abscissa label on plots
%         ylabel@char; % text for ordinate label on plots
        xlabel; % text for abscissa label on plots
        ylabel; % text for ordinate label on plots
    end

    properties (Abstract, SetAccess = protected)
    end          

    properties (Dependent = true, SetAccess = protected)
    %% Calculated properties
        numchannels;    % Number of data points
        numspectra;     % Number of spectra
    end
    
    methods
        %% numchannels : Calculate number of data points in the spectra
        function numchannels = get.numchannels(this)
            % Calculate number of data points per spectrum
            numchannels = size(this.data,2);
        end
        %% numspectra : Calculate number of spectra in the collection
        function numspectra = get.numspectra(this)
            % Calculate number of spectra in this collection
            numspectra = size(this.data,1);
        end
    end
    
    methods (Abstract)
        clone(this);
    end
    
end

