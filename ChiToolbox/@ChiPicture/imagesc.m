function imagesc(varargin)

% imagesc  Displays the data as an image that uses the full range of colors in the colormap
%
% Syntax
%   imagesc();
%   imagesc(Name,Value);
%   handle = imagesc(____);
%
% Description
%   imagesc() displays the data as an image that uses the full range of
%   colors in the colormap
% 
%   imagesc(Name,Value) applies the Name/Value pairs to the image. See the
%   help for MATLAB's help on imagesc for more details. 
%
%   handle = imagesc(____) returns a handle to this figure.
% 
% Notes
%   If the data is bimodal, the ChiBimodalColormap is used. Otherwise, if
%   the parula colormap is available it is used. If parula is not available
%   the ChiSequentialColormap is used. 
% 
% Copyright (c) 2018-2019, Alex Henderson.
% Licenced under the GNU General Public License (GPL) version 3.
%
% See also 
%   imagesc parula ChiBimodalColormap ChiSequentialColormap.

% Contact email: alex.henderson@manchester.ac.uk
% Licenced under the GNU General Public License (GPL) version 3
% http://www.gnu.org/copyleft/gpl.html
% Other licensing options are available, please contact Alex for details
% If you use this file in your work, please acknowledge the author(s) in
% your publications. 

% The latest version of this file is available on Bitbucket
% https://bitbucket.org/AlexHenderson/chitoolbox


    this = varargin{1};
    
    imagesc(this.data,varargin{2:end});
    
    if this.bimodal
        colormap(ChiBimodalColormap());
    else        
        if exist('parula.m','file')
            colormap(parula);
        else
            colormap(ChiSequentialColormap());
        end
    end
    axis image;
    axis off;
end        
