function plotweights(this,varargin)

% plotweight  Plots the partial least squares component weight of your choice. 
%
% Syntax
%   plotweight(comp);
%   plotweight(comp,'nofig');
%   plotweight(____,'bar');
%
% Description
%   plotweight(comp) creates a 2-D line chart of the partial least squares
%   component weight in a new figure window. Percentage explained variance
%   of this component in the data block is shown in parentheses. 
%
%   plotweight(comp,'nofig') plots the component weight in the currently
%   active figure window, or creates a new figure if none is available.
% 
%   plotweight(____,'bar') generates a bar plot, rather than a line plot.
%
%   Other parameters can be applied to customise the plot. See the MATLAB
%   plot/bar functions for more details. 
%
% Copyright (c) 2020, Alex Henderson.
% Licenced under the GNU General Public License (GPL) version 3.
%
% See also 
%   plot bar plotxscores plotexplainedvariance plotcumexplainedvariance
%   ChiPLSModel ChiSpectralCollection.

% Contact email: alex.henderson@manchester.ac.uk
% Licenced under the GNU General Public License (GPL) version 3
% http://www.gnu.org/copyleft/gpl.html
% Other licensing options are available, please contact Alex for details
% If you use this file in your work, please acknowledge the author(s) in
% your publications. 

% Version 1.0, May 2020
% The latest version of this file is available at:
% https://github.com/AlexHenderson/ChiToolbox

% Simply a wrapper around the plotweight function


plotweight(this,varargin{:})

end

