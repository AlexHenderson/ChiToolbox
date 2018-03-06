function plotpcloading(this,pc,varargin)

% plotpcloading  Plots the principal component loading of your choice. 
%
% Syntax
%   plotpcloading(pc);
%   plotpcloading(pc,'nofig');
%
% Description
%   plotpcloading(pc) creates a 2-D bar chart of the principal component
%   pc in a new figure window.
%
%   plotpcloading(pc,'nofig') plots the loading in the currently active
%   figure window, or creates a new figure if none is available.
%
%   Other parameters can be applied to customise the plot. See the MATLAB
%   bar function for more details. 
%
% Copyright (c) 2017, Alex Henderson.
% Licenced under the GNU General Public License (GPL) version 3.
%
% See also 
%   bar plotloading plotscores plotpcscores plotexplainedvariance
%   plotpcexplainedvariance ChiSpectralPCAOutcome ChiSpectralCollection.

% Contact email: alex.henderson@manchester.ac.uk
% Licenced under the GNU General Public License (GPL) version 3
% http://www.gnu.org/copyleft/gpl.html
% Other licensing options are available, please contact Alex for details
% If you use this file in your work, please acknowledge the author(s) in
% your publications. 

% Version 1.0, July 2017
% The latest version of this file is available on Bitbucket
% https://bitbucket.org/AlexHenderson/Chitoolbox

this.PCAOutcome.plotloading(pc,varargin{:});

end
