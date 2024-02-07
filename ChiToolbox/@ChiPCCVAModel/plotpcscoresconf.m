function plotpcscoresconf(this,pcx,pcy,varargin)

% plotpcscoresconf  Plots principal component scores with confidence ellipses. 
%
% Syntax
%   plotpcscoresconf(pcx,pcy);
%   plotpcscoresconf(pcx,pcy,percentconf);
%   plotpcscoresconf(____,'nofig');
%
% Description
%   plotpcscoresconf(pcx,pcy) creates a 2-D scatter plot of principal
%   component scores. pcx is the principal component number to plot on the
%   x-axis, while pcy is the principal component number to plot on the
%   y-axis. Ellipses are drawn for all classes at 95% conficence. A new
%   figure window is created.
%
%   plotpcscoresconf(pcx,pcy,percentconf) Principal component scores are
%   plotted with ellipses at percentconf. A new figure window is created.
%
%   plotpcscoresconf(____,'nofig') plots the scores in the currently active
%   figure window, or creates a new figure if none is available.
%
%   Other parameters can be applied to customise the plot. See the MATLAB
%   scatter, or utilities.gscatter, functions for more details. 
%
% Copyright (c) 2017-2019, Alex Henderson.
% Licenced under the GNU General Public License (GPL) version 3.
%
% See also 
%   scatter plotscores plotloadings plotexplainedvariance
%   utilities.gscatter plotcumexplainedvariance ChiPCAModel
%   ChiSpectralCollection.


% Contact email: alex.henderson@manchester.ac.uk
% Licenced under the GNU General Public License (GPL) version 3
% http://www.gnu.org/copyleft/gpl.html
% Other licensing options are available, please contact Alex for details
% If you use this file in your work, please acknowledge the author(s) in
% your publications. 

% The latest version of this file is available at:
% https://github.com/AlexHenderson/ChiToolbox


this.pca.plotscoresconf(pcx,pcy,varargin{:});

end
