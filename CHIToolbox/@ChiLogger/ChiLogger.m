classdef ChiLogger < handle
% ChiLogger Logs changes to objects
% Copyright (c) 2014 Alex Henderson (alex.henderson@manchester.ac.uk)
    
    properties
        log@cell;
    end
    
    methods
        function this = ChiLogger()
            % Create an instance of ChiLogger
            if (nargin > 0) % Support calling with 0 arguments
                this.log = cell(1);
            end
        end
    end
    
end

