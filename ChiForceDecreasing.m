function [a,b] = ChiForceDecreasing(a,b)
%CHIFORCEDECREASING Orders two values as decreasing
%   Orders two values such that the second is smaller or equal to the first

if(a < b)
    [a,b]=ChiSwap(a,b);
end

end

