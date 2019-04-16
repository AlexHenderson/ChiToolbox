function output = secondderiv(wavenumber, intensity, smoothing_pts)

% Calculates the second derivative of intensity values
%
%   Usage: output = secondderiv(wavenumber, intensity, smoothing_pts);
%   Where
%       wavenumber - vector of wavenumbers (x values)
%       intensity  - matrix of intensities (y values in COLUMNS)
%       smoothing_pts - number of points to smooth data by. This MUST be
%           an odd number and should be quite small - 3, 5, 7 etc
%       output - matrix of second derivative data (in columns)
%
% This calculates a second derivative while performing a Savitzky-Golay
% smooth at the same time. The data should be smoothed to prevent noise in
% the data from swamping the result. The smoothing_pts value determines the
% degree of smoothing - a bigger value mean more smoothing. 
% 
% Note that smoothing means you lose points from either end of the data.
% For example; if you have a 7 point smooth you will lose 3 points from
% either end of the data. Here these points have been set to zero so that
% the length of the output is the same as the length of the input. 
%
%   (c) Alex Henderson Dec 2007
%

if rem(smoothing_pts,2) == 0
    error('smoothing_pts must be an odd number');
end

N = 4;                 % Order of polynomial fit
F = smoothing_pts;     % Window length
[b,g] = sgolay(N,F);   % Calculate S-G coefficients

x=wavenumber;
% transpose because dot product (later) uses rows
y=intensity';

dx = (x(end)-x(1))/length(x);

HalfWin  = ((F+1)/2) -1;

SG2=zeros(size(y));
[rows,cols]=size(y);
for r = 1:rows
    for n = (F+1)/2 : cols-(F+1)/2,
        % 2nd differential
        SG2(r,n) = 2*dot(g(:,3)', y(r, n - HalfWin : n + HalfWin))';
    end
end

SG2 = SG2/(dx*dx);    % Turn differential into 2nd derivative

% turn back to columns
output = SG2';
