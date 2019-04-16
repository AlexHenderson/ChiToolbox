function [input] = meancenter(input)

%
% Mean centers a collection of spectra.
% 
% usage: [output] = meancenter(input)
% where: 
%       input
%           a collection of spectra in rows
%       output
%           the mean centered version of input
%
% Copyright (c) February 2007 Alex Henderson
%

cols = size(input,2);       % number of columns in input data set [1,1]
inputmean = mean(input);    % mean of each column [1,cols]

for col = 1:cols
    input(:,col) = input(:,col) - inputmean(col);
end
