classdef (Abstract) ChiAbstractSpectrum < handle
% ChiAbstractSpectrum  Abstract class to define spectral characteristics
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
        numspectra = 1; % number of rows of data
    end
    
    properties (Dependent = true, SetAccess = protected)
        numchannels;    % number of data points
    end

    methods % ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
        % numchannels
        function numchannels = get.numchannels(this)
            % Calculate number of channels
            numchannels = length(this.data);
        end

        % Name of variable
        function name = variablename(this) %#ok<MANU>
            name = utilities.callingline();
            
%             expr = '';
% 
%     [start_idx, end_idx, extents, matches, tokens, names, splits] = regexp(str, expr);
% 
%     monthword=tokens{1,1}{1};
%     day=tokens{1,1}{2};
            
            
            
            
        end
    end
    
    methods (Abstract)
        clone(this);
    end
    
end

