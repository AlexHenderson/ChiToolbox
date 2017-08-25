classdef ChiLogger < handle

% ChiLogger  Records changes to objects
% Copyright (c) 2017 Alex Henderson (alex.henderson@manchester.ac.uk)
    
    properties
        log;
    end
    
    methods
        % ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
        function this = ChiLogger()
            this.log = cell(1);
            this.log{1} = ['Created: ', datestr(now)]; 
        end
        
        % ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
        function output = clone(this)
            output = ChiLogger();
            output.log = this.log;
        end
        
        % ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    end
    
end

