function plotloadings(this,pc,varargin)

% plotloadings  Plots the principal component loading of your choice. 
%
% Syntax
%   plotloadings(pc);
%   plotloadings(pc,'nofig');
%
% Description
%   plotloadings(pc) creates a 2-D bar chart of the principal component
%   pc in a new figure window.
%
%   plotloadings(pc,'nofig') plots the loading in the currently active
%   figure window, or creates a new figure if none is available.
%
%   Other parameters can be applied to customise the plot. See the MATLAB
%   bar function for more details. 
%
% Copyright (c) 2017, Alex Henderson.
% Licenced under the GNU General Public License (GPL) version 3.
%
% See also 
%   bar imagepc plotexplainedvariance plotcumexplainedvariance
%   ChiImagePCAModel ChiImage.

% Contact email: alex.henderson@manchester.ac.uk
% Licenced under the GNU General Public License (GPL) version 3
% http://www.gnu.org/copyleft/gpl.html
% Other licensing options are available, please contact Alex for details
% If you use this file in your work, please acknowledge the author(s) in
% your publications. 

% Version 1.0, July 2017
% The latest version of this file is available at:
% https://github.com/AlexHenderson/ChiToolbox

% Simply a wrapper around the plotloading function

plotloading(this,pc,varargin{:})

end
