function [a,b] = ChiForceIncreasing(a,b)
%CHIFORCEINCREASING Orders two values as increasing
%   Orders two values such that the second is greater or equal to
%   the first

if(a > b)
    [a,b]=ChiSwap(a,b);
end

end

