function varargout = plot(varargin)
    
% plot  Plots one or more spectra. Multiple spectra are overlaid. 
%
% Syntax
%   plot();
%   plot('nofig');
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
%   plot('nofig') plots the spectra in the currently active figure window,
%   or creates a new figure if none is available.
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

% This function first checks whether the data is centroided. If it is, then
% the data is cloned and stickified to prevent the plot function simply
% 'joining together' the tops of the peaks. Then it passes the plotting off
% to the plot function in the superclass.
    

    obj = clone(varargin{1});
    
    if obj.iscentroided
        % Centroided data work best in legacy mode
        varargin = horzcat(varargin,{'legacy'});
    end
    
    if nargout
        varargout{:} = plot@ChiSpectralCollection(obj,varargin{2:end});    
    else
        plot@ChiSpectralCollection(obj,varargin{2:end});
    end
        
end
