function [WNout Yout] = select_one_range(WN , Y , min1 , max1);

% Usage: [WNout Yout] = select_one_range(WN , Y , min1 , max1 );
% 
% Input:-
%    - WN - Wavenumber vector
%    - Y - data matrix in ROWS
%    - min1 - low range of the first section
%    - max1 - upper range of the first section
%
%    BTW: the following should be true:
%       min1 < max1
%
% Output:-
%    - WNout - New wavenumber vector which corresponds to the sections u
%    chose
%    - Yout - your data in the range you wanted
%
%
% Written by Paul Bassan, University of Manchester. 20/05/10



%% Set up error messages

if length(WN) == size(Y,1)
    error('~~~~ Your data has to be in rows ~~~~')
end


if min1 > max1
    error('You entered the ranges wrong, read help. Type: doc select_two_ranges')
end

%% The region selections

[a1 a2] = find_value_min_max(WN , min1, max1);


indices = [a1:a2]' ;

WNout = WN(indices);

Yout = Y(:,indices);







end










