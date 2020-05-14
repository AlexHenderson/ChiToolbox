function plotexplained(varargin)

% plotexplainedvariance  Plots the percentage explained variance of both the data (X) block and the dependent variable (Y). 
%
% Syntax
%   plotexplainedvariance();
%   plotexplainedvariance(limit);
%   plotexplainedvariance(____,'nofig');
%
% Description
%   plotexplainedvariance() creates a 2-D line plot of the percentage
%   variance explained by each partial least squares component in both the
%   data (X) block and the dependent variable (Y). Up to 20 components are
%   plotted by default. A new figure window is generated.
%
%   plotexplainedvariance(limit) plots the percentage explained variance
%   with limit values being displayed.
%
%   plotexplainedvariance(____,'nofig') plots the data in the currently
%   active figure window, or creates a new figure if none is available.
%
%   Other parameters can be applied to customise the plot. See the MATLAB
%   plot function for more details. 
%
% Copyright (c) 2020, Alex Henderson.
% Licenced under the GNU General Public License (GPL) version 3.
%
% See also 
%   plot plotxscores plotweight plotcumexplainedvariance
%   ChiPLSModel ChiSpectralCollection.

% Contact email: alex.henderson@manchester.ac.uk
% Licenced under the GNU General Public License (GPL) version 3
% http://www.gnu.org/copyleft/gpl.html
% Other licensing options are available, please contact Alex for details
% If you use this file in your work, please acknowledge the author(s) in
% your publications. 

% Version 1.0, May 2020
% The latest version of this file is available on Bitbucket
% https://bitbucket.org/AlexHenderson/Chitoolbox


% Just a wrapper...

this = varargin{1};
this.plotexplainedvariance(varargin{2:end})

end
