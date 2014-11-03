classdef ChiCloneable < handle
%CHICLONEABLE : A base class for copy semantics 
%   matlab.mixin.Copyable only became available in R2011a (I think)
%   Need this functionality for R2009a
%   Copyright (c) 2014 Alex Henderson (alex.henderson@manchester.ac.uk)
    
    % Code taken from: 
    % https://groups.google.com/forum/#!topic/comp.soft-sys.matlab/0olkri5udPo
    
    properties
    end
    
    methods
        function newObj = clone(this)
            % Create an empty instance of the class
            newObj = eval(class(this));

            % copy non-dependent properties, by creating a meta object for the class of 'this'.
            mo = eval(['?',class(this)]);
            ndp = findobj([mo.Properties{:}],'Dependent',false);
            for idx = 1:length(ndp)
                newObj.(ndp(idx).Name) = this.(ndp(idx).Name);
            end
        end
    end
    
end

