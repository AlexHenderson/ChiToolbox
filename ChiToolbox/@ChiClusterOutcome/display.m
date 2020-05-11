function varargout = display(varargin) %#ok<DISPLAY>

% display  Generates an image of the cluster data
%
% Syntax
%   display();
%   display('nofig');
%   display(____,'title',titletext);
%   display(____,'cmap',cmap);
%   handle = display(____);
%
% Description
%   display() generates an image of the cluster data.
%
%   display('nofig') shows the image in the currently active figure window,
%   or creates a new figure if none is available.
%
%   display(____,'title',titletext) shows titletext as a plot title.
% 
%   display(____,'cmap',cmap) uses the value of cmap to determine the
%   colours of the clusters. cmap can be the name of a MATLAB colormap for
%   example jet, a string containing the name of a MATLAB colormap for
%   example 'hot', or a three-column matrix of RGB triplets.
% 
%   handle = display(____) returns a handle to the figure.
%
% Copyright (c) 2019, Alex Henderson.
% Licenced under the GNU General Public License (GPL) version 3.
%
% See also 
%   disp show imagesc colormap ChiContinuousColormap.

% Contact email: alex.henderson@manchester.ac.uk
% Licenced under the GNU General Public License (GPL) version 3
% http://www.gnu.org/copyleft/gpl.html
% Other licensing options are available, please contact Alex for details
% If you use this file in your work, please acknowledge the author(s) in
% your publications. 

% The latest version of this file is available on Bitbucket
% https://bitbucket.org/AlexHenderson/chitoolbox


if nargout
    varargout = show(varargin{:});
else
    show(varargin{:});
end    

end
