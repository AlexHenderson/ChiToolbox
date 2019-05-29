function [a,b] = ChiSwap(a,b)
%CHISWAP Swaps two values
%   Copyright (c) 2014 Alex Henderson (alex.henderson@manchester.ac.uk)

%   For integers see here:
%   http://blogs.mathworks.com/loren/2006/10/25/cute-tricks-in-matlab-adapted-from-other-languages/#3

temp = a;
a = b;
b = temp;

end
