function varargout = plot(varargin)

% plot  Plots the spectrum. 
%
% Syntax
%   plot();
%   plot(____,'nofig');
%   plot(____,'legacy');
%   plot(____,'axes',desiredaxes);
%   plot(____,'title',titletext);
%   handle = plot(____);
%
% Description
%   plot() creates a 2-D line plot of the ChiSpectrum object in a new
%   figure window.
%
%   plot(____,'nofig') plots the spectrum in the currently active figure window,
%   or creates a new figure if none is available.
%
%   plot(____,'legacy') plots the spectrum using the legacy method, where
%   segments are joined by a straight line. 
%
%   plot(____,'axes',desiredaxes) plots the spectrum in the
%   desiredaxes. Defaults to gca. 
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
%   plot ChiSpectrum ChiSpectralCollection.

% Contact email: alex.henderson@manchester.ac.uk
% Licenced under the GNU General Public License (GPL) version 3
% http://www.gnu.org/copyleft/gpl.html
% Other licensing options are available, please contact Alex for details
% If you use this file in your work, please acknowledge the author(s) in
% your publications. 

% The latest version of this file is available on Bitbucket
% https://bitbucket.org/AlexHenderson/chitoolbox


%% Grab this
this = varargin{1};

%% Do we want a legacy plot?
legacy = false;
argposition = find(cellfun(@(x) strcmpi(x, 'legacy') , varargin));
if argposition
    legacy = true;
    % Remove the parameter from the argument list
    varargin(argposition) = [];
end

%% Do the plotting
% Passing the actual plotting functionality off to a separate function to
% co-locate the feature. 

if this.iscentroided
    legacy = true;
end

if legacy
    retval = utilities.plotspectrum(varargin{:},'legacy');
else
    retval = utilities.plotspectrumsegmented(varargin{:},'linearity','quadratic');
end

%% Manage return values
if nargout
    varargout{:} = retval;
end

end % function
