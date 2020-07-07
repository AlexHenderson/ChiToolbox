function plotpcexplainedvariance(this,varargin)

% plotpcexplainedvariance  Plots the percentage explained variance of the principal components. 
%
% Syntax
%   plotpcexplainedvariance();
%   plotpcexplainedvariance(limitpcs);
%   plotpcexplainedvariance(____,'nofig');
%
% Description
%   plotpcexplainedvariance() creates a 2-D line plot of the percentage
%   variance explained by each principal component. Up to 20 principal
%   components are plotted by default. A new figure window is generated.
%
%   plotpcexplainedvariance(limitpcs) plots the percentage explained variance
%   with limitpcs values being displayed.
%
%   plotpcexplainedvariance(____,'nofig') plots the data in the currently
%   active figure window, or creates a new figure if none is available.
%
%   Other parameters can be applied to customise the plot. See the MATLAB
%   plot function for more details. 
%
% Copyright (c) 2017, Alex Henderson.
% Licenced under the GNU General Public License (GPL) version 3.
%
% See also 
%   plot plotscores plotloading plotcumexplainedvariance plotpcscores
%   plotpcloading plotpccumexplainedvariance ChiSpectralPCAModel
%   ChiSpectralCollection.

% Contact email: alex.henderson@manchester.ac.uk
% Licenced under the GNU General Public License (GPL) version 3
% http://www.gnu.org/copyleft/gpl.html
% Other licensing options are available, please contact Alex for details
% If you use this file in your work, please acknowledge the author(s) in
% your publications. 

% Version 1.0, July 2017
% The latest version of this file is available on Bitbucket
% https://bitbucket.org/AlexHenderson/Chitoolbox

this.pca.plotexplainedvariance(varargin{:});

end
