function varargout = colors(varargin)

% colors  Generates an image of the cluster data
%
% Syntax
%   colors();
%   colors('cmap',cmap);
%   handle = colors(____);
%
% Description
%   colors() generates a colormap to display the clusters.
%
%   colors('cmap',cmap) uses the value of cmap to determine the colors
%   of the clusters. cmap can be the name of a MATLAB colormap for example
%   jet, a string containing the name of a MATLAB colormap for example
%   'hot', or a three-column matrix of RGB triplets.
% 
%   handle = colors(____) returns a handle to the figure.
%
% Copyright (c) 2020, Alex Henderson.
% Licenced under the GNU General Public License (GPL) version 3.
%
% See also 
%   colormap ChiContinuousColormap.

% Contact email: alex.henderson@manchester.ac.uk
% Licenced under the GNU General Public License (GPL) version 3
% http://www.gnu.org/copyleft/gpl.html
% Other licensing options are available, please contact Alex for details
% If you use this file in your work, please acknowledge the author(s) in
% your publications. 

% The latest version of this file is available on Bitbucket
% https://bitbucket.org/AlexHenderson/chitoolbox


% Just a wrapper around colours.m

    this = varargin{1};
    if nargout
        varargout{:} = this.colours(varargin{2:end});
    else
        this.colours(varargin{2:end});
    end
 
end
