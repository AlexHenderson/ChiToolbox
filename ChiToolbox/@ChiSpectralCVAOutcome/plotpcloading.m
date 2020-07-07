function plotpcloading(this,pc,varargin)

% plotpcloading  Plots the principal component loading of your choice. 
%
% Syntax
%   plotpcloading(pc);
%   plotpcloading(pc,'nofig');
%   plotpcloading(____,'bar');
%
% Description
%   plotpcloading(pc) creates a 2-D line chart of the principal component
%   pc in a new figure window.
%
%   plotpcloading(pc,'nofig') plots the loading in the currently active
%   figure window, or creates a new figure if none is available.
% 
%   plotpcloading(____,'bar') generates a bar plot, rather than a line plot.
%
%   Other parameters can be applied to customise the plot. See the MATLAB
%   plot/bar functions for more details. 
%
% Copyright (c) 2017-2018, Alex Henderson.
% Licenced under the GNU General Public License (GPL) version 3.
%
% See also 
%   plot bar plotscores plotexplainedvariance plotcumexplainedvariance
%   ChiSpectralPCAModel ChiSpectralCollection.

% Contact email: alex.henderson@manchester.ac.uk
% Licenced under the GNU General Public License (GPL) version 3
% http://www.gnu.org/copyleft/gpl.html
% Other licensing options are available, please contact Alex for details
% If you use this file in your work, please acknowledge the author(s) in
% your publications. 

% Version 2.0, September 2018
% The latest version of this file is available on Bitbucket
% https://bitbucket.org/AlexHenderson/chitoolbox

% Simply a wrapper around the plotloading function


this.pca.plotloading(pc,varargin{:});

end
