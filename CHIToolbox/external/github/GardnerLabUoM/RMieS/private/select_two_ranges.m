function [WNout Yout] = select_two_ranges(WN , Y , min1 , max1 , min2 , max2);

% Usage: [WNout Yout] = select_two_ranges(WN , Y , min1 , max1 , min2 , max2);
% 
% If you dont enter the min and max's, the defaults will be used:
%     min1 = 800;
%     max1 = 1800;
%     min2 = 2500;
%     max2 = 3700;
%
% Input:-
%    - WN - Wavenumber vector
%    - Y - data matrix in ROWS
%    - min1 - low range of the first section
%    - max1 - upper range of the first section
%    - min2 - lower range of the second section
%    - max2 - upper range of the second section
%
%    BTW: the following should be true:
%       min1 < max1 < min2 < max2
%
% Output:-
%    - WNout - New wavenumber vector which corresponds to the sections u
%    chose
%    - Yout - your data in the ranges you wanted
%
%
% Written by Paul Bassan, University of Manchester. 13/11/09


%% Set the defaults if needbe

if nargin == 2
    min1 = 800;
    max1 = 1800;
    min2 = 2500;
    max2 = 3700;
end

%% Set up error messages

if length(WN) == size(Y,1)
    error('~~~~ Your data has to be in rows ~~~~')
end

N = [min1;max1;min2;max2];
N1 = sort(N,1);

if sum(abs(N-N1)) ~= 0
    error('You entered the ranges wrong, read help. Type: doc select_two_ranges')
end

%% The region selections

[a1 a2] = find_value_min_max(WN , min1, max1);
[b1 b2] = find_value_min_max(WN , min2, max2);

indices = [ [a1:a2]' ; [b1:b2]' ];

WNout = WN(indices);

Yout = Y(:,indices);







end










