function plot(this,varargin)

% plot  Plots one, or more, spectra. Multiple spectra are overlaid. 
%
% Syntax
%   plot();
%   plot('nofig');
%
% Description
%   plot() creates a 2-D line plot of the ChiSpectralCollection object in a
%   new figure window.
%
%   plot('nofig') plots the spectrum in the currently active figure window,
%   or creates a new figure if none is available.
%
%   Other parameters can be applied to customise the plot. See the MATLAB
%   plot function for more details. 
%
% Copyright (c) 2017, Alex Henderson.
% Licenced under the GNU General Public License (GPL) version 3.
%
% See also 
%   plot ChiSpectrum ChiSpectralCollection.

% Contact email: alex.henderson@manchester.ac.uk
% Licenced under the GNU General Public License (GPL) version 3
% http://www.gnu.org/copyleft/gpl.html
% Other licensing options are available, please contact Alex for details
% If you use this file in your work, please acknowledge the author(s) in
% your publications. 

% Version 1.0, July 2017
% The latest version of this file is available on Bitbucket
% https://bitbucket.org/AlexHenderson/agilent-file-formats

% Passing the actual plotting functionality off to a separate function to
% co-locate the feature. 

    utilities.plotspectrum(this,varargin{:});
    
end
