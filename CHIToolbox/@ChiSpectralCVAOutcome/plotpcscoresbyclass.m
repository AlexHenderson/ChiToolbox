function plotpcscoresbyclass(varargin)

% plotpcscoresbyclass  Plots principal component scores for each class separately. 
%
% Syntax
%   plotpcscoresbyclass(pcx,pcy);
%
% Description
%   plotpcscoresbyclass(pcx,pcy) creates a 2-D scatter plot of principal
%   component scores. pcx is the principal component to plot on the x-axis,
%   while pcy is the principal component to plot on the y-axis. A new
%   figure window is created for each class in addition to the overall
%   plot.
%
%   Other parameters can be applied to customise the plot. See the MATLAB
%   gscatter function for more details. 
%
% Copyright (c) 2018, Alex Henderson.
% Licenced under the GNU General Public License (GPL) version 3.
%
% See also 
%   plotscores gscatter plotloadings plotexplainedvariance plotpcloadings
%   plotpcexplainedvariance plotpccumexplainedvariance
%   ChiSpectralPCAOutcome ChiSpectralCollection.

% Contact email: alex.henderson@manchester.ac.uk
% Licenced under the GNU General Public License (GPL) version 3
% http://www.gnu.org/copyleft/gpl.html
% Other licensing options are available, please contact Alex for details
% If you use this file in your work, please acknowledge the author(s) in
% your publications. 

% Version 1.0, September 2018
% The latest version of this file is available on Bitbucket
% https://bitbucket.org/AlexHenderson/chitoolbox


this = varargin{1};
this.pca.plotscoresbyclass(varargin{2:end});

end