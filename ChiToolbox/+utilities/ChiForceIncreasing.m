function [a,b] = ChiForceIncreasing(a,b)
%CHIFORCEINCREASING Orders two values as increasing
%   Orders two values such that the second is greater or equal to
%   the first
%   Copyright (c) 2014-2019 Alex Henderson (alex.henderson@manchester.ac.uk)

if (length(a) == 2)
    [a(1),a(2)] = ChiForceIncreasing(a(1),a(2));
end

if ~exist('b','var')
    return;
end

if (a > b)
    [a,b] = ChiSwap(a,b);
end

end

