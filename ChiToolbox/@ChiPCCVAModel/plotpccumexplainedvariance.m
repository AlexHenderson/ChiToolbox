function plotpccumexplainedvariance(this,varargin)

% plotpccumexplainedvariance Plots cumulative percentage explained variance of the principal components
%
% Syntax
%   plotpccumexplainedvariance();
%   plotpccumexplainedvariance(limitpcs);
%   plotpccumexplainedvariance(____,'nofig');
%
% Description
%   plotpccumexplainedvariance() creates a 2-D plot of the cumulative
%   percentage variance explained by each principal component. Up to 20
%   principal components are plotted by default. A line indicates the
%   position of 95% explained variance. A new figure window is generated.
%
%   plotpccumexplainedvariance(limitpcs) plots the cumulative percentage
%   explained variance with limitpcs values being displayed.
%
%   plotpccumexplainedvariance(____,'nofig') plots the data in the
%   currently active figure window, or creates a new figure if none is
%   available.
%
%   Other parameters can be applied to customise the plot. See the MATLAB
%   plot function for more details. 
%
% Copyright (c) 2017, Alex Henderson.
% Licenced under the GNU General Public License (GPL) version 3.
%
% See also 
%   plot plotscores plotloading plotexplainedvariance plotpcscores
%   plotpcloading plotpcexplainedvariance ChiPCAModel
%   ChiSpectralCollection.

% Contact email: alex.henderson@manchester.ac.uk
% Licenced under the GNU General Public License (GPL) version 3
% http://www.gnu.org/copyleft/gpl.html
% Other licensing options are available, please contact Alex for details
% If you use this file in your work, please acknowledge the author(s) in
% your publications. 

% Version 1.0, July 2017
% The latest version of this file is available at:
% https://github.com/AlexHenderson/ChiToolbox

this.pca.plotcumexplainedvariance(varargin{:});

end
