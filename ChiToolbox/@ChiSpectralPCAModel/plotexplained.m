function plotexplained(varargin)

% plotexplained  Plots the percentage explained variance of the principal components. 
%
% Syntax
%   plotexplained();
%   plotexplained(limitpcs);
%   plotexplained(____,'nofig');
%
% Description
%   plotexplained() creates a 2-D line plot of the percentage
%   variance explained by each principal component. Up to 20 principal
%   components are plotted by default. A new figure window is generated.
%
%   plotexplained(limitpcs) plots the percentage explained variance
%   with limitpcs values being displayed.
%
%   plotexplained(____,'nofig') plots the data in the currently
%   active figure window, or creates a new figure if none is available.
%
%   Other parameters can be applied to customise the plot. See the MATLAB
%   plot function for more details. 
%
% Copyright (c) 2018, Alex Henderson.
% Licenced under the GNU General Public License (GPL) version 3.
%
% See also 
%   plot plotscores plotloading plotcumexplainedvariance
%   ChiSpectralPCAModel ChiSpectralCollection.

% Contact email: alex.henderson@manchester.ac.uk
% Licenced under the GNU General Public License (GPL) version 3
% http://www.gnu.org/copyleft/gpl.html
% Other licensing options are available, please contact Alex for details
% If you use this file in your work, please acknowledge the author(s) in
% your publications. 

% Version 1.0, June 2018
% The latest version of this file is available on Bitbucket
% https://bitbucket.org/AlexHenderson/Chitoolbox


% Just a wrapper...

this = varargin{1};
this.plotexplainedvariance(varargin{2:end})

end
