classdef ChiOntologyInformation
    
    properties
        term = [];  % The ontological term
        description = [];   % A human readable description for this ontological term
        uri = [];   % The permanent URI for this ontological term
        isaccurate = false; % Whether this is an accurate ontological term, or simply the closest available
    end
    
    properties (Dependent)
        isavailable     % Whether ontological information is available
    end
    
    % =====================================================================
    methods
    % =====================================================================
        
        function this = ChiOntologyInformation()

        end
        
        % ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
        % Is ontology information available for these data
        function isavailable = get.isavailable(this)
            if ~(   isempty(this.term) || ...
                    isempty(this.description) || ...
                    isempty(this.uri))
                isavailable = true;
            else
                isavailable = false;
            end
        end
        
        % ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    end
    
end
