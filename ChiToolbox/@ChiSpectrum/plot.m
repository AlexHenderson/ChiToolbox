function varargout = plot(this,varargin)

% plot  Plots the spectrum. 
%
% Syntax
%   plot();
%   plot('nofig');
%   plot(____,'axes',desiredaxes);
%   plot(____,'title',titletext);
%   handle = plot(____);
%
% Description
%   plot() creates a 2-D line plot of the ChiSpectrum object in a new
%   figure window.
%
%   plot('nofig') plots the spectrum in the currently active figure window,
%   or creates a new figure if none is available.
%
%   plotspectrum(____,'axes',desiredaxes) plots the spectrum in the
%   desiredaxes. Defaults to gca. 
% 
%   plot(____,'title',titletext) displays titletext as a plot title.
% 
%   handle = plot(____) returns a handle to the figure.
%
%   Other parameters can be applied to customise the plot. See the MATLAB
%   plot function for more details. 
%
% Copyright (c) 2017-2019, Alex Henderson.
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
        varargout{:} = utilities.plotspectrum(this,varargin{:});
    else
        utilities.plotspectrum(this,varargin{:});
    end
    
end
