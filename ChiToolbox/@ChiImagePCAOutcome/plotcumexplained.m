function plotcumexplained(varargin)

% plotcumexplained Plots cumulative percentage explained variance
%
% Syntax
%   plotcumexplained();
%   plotcumexplained(limitpcs);
%   plotcumexplained(____,'nofig');
%
% Description
%   plotcumexplained() creates a 2-D plot of the cumulative
%   percentage variance explained by each principal component. Up to 20
%   principal components are plotted by default. A line indicates the
%   position of 95% explained variance. A new figure window is generated.
%
%   plotcumexplained(limitpcs) plots the cumulative percentage
%   explained variance with limitpcs values being displayed.
%
%   plotcumexplained(____,'nofig') plots the data in the currently
%   active figure window, or creates a new figure if none is available.
%
%   Other parameters can be applied to customise the plot. See the MATLAB
%   plot function for more details. 
%
% Copyright (c) 2018, Alex Henderson.
% Licenced under the GNU General Public License (GPL) version 3.
%
% See also 
%   plot plotscores plotloading plotexplainedvariance
%   ChiImagePCAOutcome ChiImage.

% Contact email: alex.henderson@manchester.ac.uk
% Licenced under the GNU General Public License (GPL) version 3
% http://www.gnu.org/copyleft/gpl.html
% Other licensing options are available, please contact Alex for details
% If you use this file in your work, please acknowledge the author(s) in
% your publications. 

% Version 1.0, June 2018
% The latest version of this file is available on Bitbucket
% https://bitbucket.org/AlexHenderson/chitoolbox


% Just a wrapper...

this = varargin{1};
this.plotcumexplainedvariance(varargin{2:end})

end
