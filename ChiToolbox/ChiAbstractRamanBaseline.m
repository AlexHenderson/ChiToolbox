classdef ChiAbstractRamanBaseline < ChiBase

% ChiAbstractRamanBaseline  An abstract base class for all methods of subtracting Raman baselines
    
    methods (Abstract)
        % Subtract this baseline from the data
        obj = remove(this); 
    end
    
end
