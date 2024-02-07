function varargout = plot(varargin)

% plot  Plots one or more spectra. Multiple spectra are overlaid. 
%
% Syntax
%   plot();
%   plot(____,'nofig');
%   plot(____,'legacy');
%   plot(____,'axes',desiredaxes);
%   plot(____,Function);
%   plot(____,'grouped',Function);
%   plot(____,'title',titletext);
%   handle = plot(____);
%
% Description
%   plot() creates a 2-D line plot of the ChiSpectralCollection in a new
%   figure window.
%
%   plot(____,'nofig') plots the spectra in the currently active figure window,
%   or creates a new figure if none is available.
%
%   plot(____,'legacy') plots the spectra using the legacy method (not
%   segmented).
%
%   plotspectra(____,'axes',desiredaxes) plots the spectra in the
%   desiredaxes. Defaults to gca. 
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
%   plot(____,'title',titletext) displays titletext as a plot title.
% 
%   handle = plot(____) returns a handle to the figure.
%
%   Other parameters can be applied to customise the plot. See the MATLAB
%   plot function for more details. 
%
% Copyright (c) 2017-2021, Alex Henderson.
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

% The latest version of this file is available at:
% https://github.com/AlexHenderson/ChiToolbox

    
%% Do we want a legacy plot?
legacy = false;
argposition = find(cellfun(@(x) strcmpi(x, 'legacy') , varargin));
if argposition
    legacy = true;
    % Remove the parameter from the argument list
    varargin(argposition) = [];
end

%% Centroided data work best in legacy mode
if varargin{1}.iscentroided
    % Centroided data work best in legacy mode
    legacy = true;
end

%% Do the plotting
% Passing the actual plotting functionality off to a separate function to
% co-locate the feature. 
if legacy
    retval = utilities.plotspectra(varargin{:});
else
    retval = utilities.plotspectrasegmented(varargin{:},'linearity','quadratic');
end

%% Manage return values
if nargout
    varargout{:} = retval;
end

end % function
