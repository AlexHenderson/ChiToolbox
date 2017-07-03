classdef ChiAbstractSpectrum < handle
% ChiAbstractSpectrum Abstract class to define spectral characteristics
% Copyright (c) 2014 Alex Henderson (alex.henderson@manchester.ac.uk)
    
    properties (Abstract)
        xvals;  % abscissa as a row vector
        data;   % ordinate as a row vector
        reversex; % should abscissa be plotted increasing or decreasing
                  % true means plot high to low
%         reversex@logical; % should abscissa be plotted increasing or decreasing
%         xlabel@char; % text for abscissa label on plots
%         ylabel@char; % text for ordinate label on plots
        xlabel; % text for abscissa label on plots
        ylabel; % text for ordinate label on plots
    end
    
    properties
        numSpectra = 1; % number of rows of data
    end
    
    properties (Dependent = true, SetAccess = protected)
        numChannels;    % number of data points
    end

    methods % ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
        % numChannels
        function numChannels = get.numChannels(this)
            % Calculate number of channels
            numChannels = length(this.data);
        end
    end
    
    methods (Abstract)
        clone(this);
    end
end

