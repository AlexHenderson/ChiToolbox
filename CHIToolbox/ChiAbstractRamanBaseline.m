classdef ChiAbstractRamanBaseline < handle

% ChiAbstractRamanBaseline  An abstract base class for all methods of subtracting Raman baselines
    
    methods (Abstract)
        % Make a deep copy of this object
        obj = clone(this);  
        
        % Subtract this baseline from the data
        obj = remove(this); 
    end
    
end
