function varargout = segmentplot(varargin)

% segmentplot  plots the spectra as a series of segments. 
%
% Syntax
%   segmentplot();
%   segmentplot(____,'nofig');
%   segmentplot(____,'axes',desiredaxes);
%   segmentplot(____,'title',titletext);
%   handle = segmentplot(____);
%
% Description
%   segmentplot() creates a 2-D line plot of the ChiSpectralCollection
%   object in a new figure window. Lines are plotted in segments.
%
%   segmentplot(____,'nofig') plots the segments of the spectra in the
%   currently active figure window, or creates a new figure if none is
%   available.
%
%   segmentplot(____,'axes',desiredaxes) plots the segments of the spectra
%   in the desiredaxes. Defaults to gca.
% 
%   segmentplot(____,'title',titletext) displays titletext as a plot title.
% 
%   handle = segmentplot(____) returns a handle to the figure.
%
% Notes
%   Segments are generated when part of the spectrum is removed. Examples
%   of functions that generate segments include removerange and keeprange.
% 
%   Other parameters can be applied to customise the plot. See the MATLAB
%   plot function for more details. 
%
% Copyright (c) 2021, Alex Henderson.
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

% The latest version of this file is available on Bitbucket
% https://bitbucket.org/AlexHenderson/chitoolbox

% Passing the actual plotting functionality off to a separate function to
% co-locate the feature. 


    if nargout
        varargout{:} = utilities.segmentplotspectra(varargin{:});
    else
        utilities.segmentplotspectra(varargin{:});
    end
    
end
