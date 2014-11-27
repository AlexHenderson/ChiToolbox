classdef ChiSpectralCharacter < handle
% ChiSpectralCharacter Abstract class to define spectral characteristics
% Copyright (c) 2014 Alex Henderson (alex.henderson@manchester.ac.uk)
    
    properties (Abstract)
        xvals;  % abscissa as a row vector
        data;   % ordinate as a row vector
        reversex@logical; % should abscissa be plotted increasing or decreasing
        xlabel@char; % text for abscissa label on plots
        ylabel@char; % text for ordinate label on plots
    end
    
    properties (Dependent = true, SetAccess = protected)
        channels; % number of data points
    end
    
    methods
        function channels = get.channels(this)
            % Calculate number of channels
            channels = length(this.xvals);
        end
    end

    methods (Abstract)
        clone(this);
    end
end

