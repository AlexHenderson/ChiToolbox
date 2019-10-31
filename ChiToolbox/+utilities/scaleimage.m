function output = scaleimage(input)

% Scales an image so that the maximum value and minimum values are set to
% the upper adjacent value and lower adjacent values respectively.
%
% Usage: output = scaleimage(input);
%
% Copyright (c) Alex Henderson 2008-2012
% version 2.0

% version 2 October 2012, Alex Henderson, 
%   added reshaping facility to return data to
%   original dimensions

% For some reason 'summary' sometimes doesn't work 
% s = summary(input);
% iqr = s.p75 - s.p25;
% uadj = s.p75 + 1.5*iqr;
% ladj = s.p25 - 1.5*iqr;

[dims]=size(input);

inputvector = reshape(input, 1,[]);
myiqr = iqr(inputvector);
percentiles = prctile(inputvector,[25 75]);
uadj = percentiles(2) + 1.5*myiqr;
ladj = percentiles(1) - 1.5*myiqr;

output = input;
output(output < ladj) = ladj;
output(output > uadj) = uadj;
%output(output < ladj) = 0;
%output(output > uadj) = 0;

%output = smoothc(output,1,1);

output=reshape(output,dims);
