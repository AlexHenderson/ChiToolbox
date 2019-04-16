function plot(this,varargin)

% plot  Plots one or more spectra. Multiple spectra are overlaid. 
%
% Syntax
%   plot();
%   plot('nofig');
%   plot(____,Function);
%   plot(____,'grouped',Function);
%
% Description
%   plot() creates a 2-D line plot of the ChiSpectralCollection in a new
%   figure window.
%
%   plot('nofig') plots the spectra in the currently active figure window,
%   or creates a new figure if none is available.
%
%   plot(____,Function) plots the spectra in a range of different ways
%   depending on the value of Function:
%     'mean' plots the mean of the spectra
%     'sum' plots the sum of the spectra
%     'median' plots the median of the spectra
%     'std' plots the mean of the spectra, with the standard deviation
%     of the spectra shown in a shaded region
% 
%   plot(____,'grouped',Function) plots the spectra in a range of different
%   ways depending on the value of Function:
%     'mean' plots the mean of the spectra in each class
%     'sum' plots the sum of the spectra in each class
%     'median' plots the median of the spectra in each class
%     'std' plots the mean of the spectra in each class, with the
%     standard deviation of the spectra shown in a shaded region
%
%   Other parameters can be applied to customise the plot. See the MATLAB
%   plot function for more details. 
%
% Copyright (c) 2017, Alex Henderson.
% Licenced under the GNU General Public License (GPL) version 3.
%
% See also 
%   plot shadedErrorBar ChiSpectrum ChiSpectralCollection.

% Contact email: alex.henderson@manchester.ac.uk
% Licenced under the GNU General Public License (GPL) version 3
% http://www.gnu.org/copyleft/gpl.html
% Other licensing options are available, please contact Alex for details
% If you use this file in your work, please acknowledge the author(s) in
% your publications. 

% Version 1.0, July 2017
% The latest version of this file is available on Bitbucket
% https://bitbucket.org/AlexHenderson/chitoolbox

% Passing the actual plotting functionality off to a separate function to
% co-locate the feature. 

    utilities.plotspectra(this,varargin{:});
    
end