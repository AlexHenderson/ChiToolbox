function varargout = plotloadings(cv,varargin)

% plotloadings  Plots the canonical variate loading of your choice. 
%
% Syntax
%   plotloadings(cv);
%   plotloadings(cv,'nofig');
%   plotloadings(____,'legacy');
%   plotloadings(____,'bar');
%   handle = plotloadings(____);
%
% Description
%   plotloadings(cv) creates a 2-D line chart of the canonical variate cv in
%   a new figure window.
%
%   plotloadings(cv,'nofig') plots the loading in the currently active
%   figure window, or creates a new figure if none is available.
%
%   plotloadings(____,'legacy') plots the loading using the legacy method,
%   where segments are joined by a straight line.
% 
%   plotloadings(____,'bar') generates a bar plot rather than a line plot.
%
%   handle = plotloadings(____) returns a handle to the figure.
%
%   Other parameters can be applied to customise the plot. See the MATLAB
%   plot/bar functions for more details. 
%
% Copyright (c) 2017-2021, Alex Henderson.
% Licenced under the GNU General Public License (GPL) version 3.
%
% See also 
%   plot bar plotscores plotexplainedvariance plotcumexplainedvariance
%   plotpcscores plotpcloading plotpcexplainedvariance
%   plotpccumexplainedvariance ChiPCCVAModel ChiSpectralCollection.

% Contact email: alex.henderson@manchester.ac.uk
% Licenced under the GNU General Public License (GPL) version 3
% http://www.gnu.org/copyleft/gpl.html
% Other licensing options are available, please contact Alex for details
% If you use this file in your work, please acknowledge the author(s) in
% your publications. 

% Version 2.0, April 2021
% The latest version of this file is available at:
% https://github.com/AlexHenderson/ChiToolbox

    
handle = plotloading(cv,varargin{:});

if nargout
    varargout{1} = handle;
end

end
