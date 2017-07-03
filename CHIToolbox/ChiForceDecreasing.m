function [a,b] = ChiForceDecreasing(a,b)
%CHIFORCEDECREASING Orders two values as decreasing
%   Orders two values such that the second is smaller or equal to the first
%   Copyright (c) 2014 Alex Henderson (alex.henderson@manchester.ac.uk)

if (a < b)
    [a,b] = ChiSwap(a,b);
end

end

