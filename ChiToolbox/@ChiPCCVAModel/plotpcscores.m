function plotpcscores(this,varargin)

% plotpcscores  Plots principal component scores of your choice. 
%
% Syntax
%   plotpcscores(pcx,pcy);
%   plotpcscores(pcx,pcy,'nofig');
%
% Description
%   plotpcscores(pcx,pcy) creates a 2-D scatter plot of principal component
%   scores. pcx is the principal component number to plot on the x-axis,
%   while pcy is the principal component number to plot on the y-axis. A
%   new figure window is created.
%
%   plotpcscores(pcx,pcy,'nofig') plots the scores in the currently active
%   figure window, or creates a new figure if none is available.
%
%   Other parameters can be applied to customise the plot. See the MATLAB
%   scatter, or utilities.gscatter, functions for more details. 
%
% Notes
%   If the object has classmembership available, the scores will be plotted
%   in colours relating to their class using the utilities.gscatter
%   function.
%
% Copyright (c) 2017, Alex Henderson.
% Licenced under the GNU General Public License (GPL) version 3.
%
% See also 
%   scatter plotloadings plotexplainedvariance plotpcloadings
%   plotpcexplainedvariance plotpccumexplainedvariance utilities.gscatter
%   ChiPCAModel ChiSpectralCollection.


% Contact email: alex.henderson@manchester.ac.uk
% Licenced under the GNU General Public License (GPL) version 3
% http://www.gnu.org/copyleft/gpl.html
% Other licensing options are available, please contact Alex for details
% If you use this file in your work, please acknowledge the author(s) in
% your publications. 

% Version 1.0, July 2017
% The latest version of this file is available on Bitbucket
% https://bitbucket.org/AlexHenderson/Chitoolbox


this.pca.plotscores(varargin{:});

end

