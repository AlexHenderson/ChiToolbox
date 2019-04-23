function [a,b] = ChiForceDecreasing(a,b)
%CHIFORCEDECREASING Orders two values as decreasing
%   Orders two values such that the second is smaller or equal to the first
%   Copyright (c) 2014-2019 Alex Henderson (alex.henderson@manchester.ac.uk)


if (length(a) == 2)
    [a(1),a(2)] = ChiForceDecreasing(a(1),a(2));
end

if ~exist('b','var')
    return;
end

if (a < b)
    [a,b] = ChiSwap(a,b);
end

end

