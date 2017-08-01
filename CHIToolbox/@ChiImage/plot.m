function plot(this,varargin)

% plot  Plots spectra overlaid. 
%
% Syntax
%   plot();
%   plot('nofig');
%   plot(____,Function);
%   plot(____,'grouped',Function);
%   plot('force',____);
%
% Description
%   plot() creates a 2-D line plot of the spectra in the ChiImage in a new
%   figure window. Use the 'force' option if the number of spectra to be
%   plotted is greater than 1000. 
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
%   plot('force',____) forces the plot function to display a large number
%   of spectra using any of the other syntax variants. A hyperspectral
%   image can contain a very large number of spectra and this can create a
%   problem when plotting. If the number of spectra to be plotted is
%   greater than 500, a warning will be issued and no plot generated. In
%   such a case, using the 'force' option will ensure the plot function is
%   attempted, regardless of the consequences.
% 
%   Other parameters can be applied to customise the plot. See the MATLAB
%   plot function for more details. 
%
% Copyright (c) 2017, Alex Henderson.
% Licenced under the GNU General Public License (GPL) version 3.
%
% See also 
%   plot shadedErrorBar ChiImage ChiSpectralCollection.

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


%% Determine what the user asked for
plottype = 'normal';
forced = false;

argposition = find(cellfun(@(x) strcmpi(x, 'mean') , varargin));
if argposition
    plottype = 'mean';
end

argposition = find(cellfun(@(x) strcmpi(x, 'sum') , varargin));
if argposition
    plottype = 'sum';
end

argposition = find(cellfun(@(x) strcmpi(x, 'median') , varargin));
if argposition
    plottype = 'median';
end

argposition = find(cellfun(@(x) strcmpi(x, 'std') , varargin));
if argposition
    plottype = 'std';
end

argposition = find(cellfun(@(x) strcmpi(x, 'force') , varargin));
if argposition
    % Remove the 'force' flag
    varargin(argposition) = [];
    forced = true;
end

if (forced || (this.numpixels < 1001))
    % Not too many spectra, or the user has overridden the warning
    utilities.plotspectrum(this,varargin{:});
else
    % If we're asking for the mean, sum, median or std plots then the
    % number of actual plot lines is likely to be quite small, so just go
    % ahead. 
    % If the plottype is 'normal' we plot everything, regardless of whether
    % the 'grouped' flag is present or whether we have classmembership
    % information. Therefore warn the user. 
    
    if strcmpi(plottype,'normal')
        warning('backtrace','off');
        warning('This plot will generate %d lines. In order to plot more than 1000 lines, please reissue the command using the ''force'' flag.',this.numpixels);
        warning('backtrace','on');
    else
        utilities.plotspectrum(this,varargin{:});
    end
    
end
