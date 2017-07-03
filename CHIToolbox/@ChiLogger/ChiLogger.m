classdef ChiLogger < handle
% ChiLogger Logs changes to objects
% Copyright (c) 2014 Alex Henderson (alex.henderson@manchester.ac.uk)
    
    properties
        log;
    end
    
    methods
        function this = ChiLogger()
            % Create an instance of ChiLogger
            this.log = cell(1);
%             if (nargin > 0) % Support calling with 0 arguments
%                 this.log = cell(1);
%             end
        end
        
        function output = clone(this)
            % Create an instance of ChiLogger
            output = ChiLogger();
            output.log = this.log;
        end
        
    end
    
end

