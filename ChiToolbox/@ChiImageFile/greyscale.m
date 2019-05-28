function obj = greyscale(this)

% greyscale  Convert the image to greyscale.
%
% Syntax
%   grey = greyscale();
%
% Description
%   grey = greyscale() produces a ChiPicture of the greyscale version of
%   this image. 
% 
% Copyright (c) 2019, Alex Henderson.
% Licenced under the GNU General Public License (GPL) version 3.
%
% See also 
%   imshow ChiPicture.

% Contact email: alex.henderson@manchester.ac.uk
% Licenced under the GNU General Public License (GPL) version 3
% http://www.gnu.org/copyleft/gpl.html
% Other licensing options are available, please contact Alex for details
% If you use this file in your work, please acknowledge the author(s) in
% your publications. 

% The latest version of this file is available on Bitbucket
% https://bitbucket.org/AlexHenderson/chitoolbox
    
    
    obj = ChiPicture(rgb2gray(this.data),this.xpixels,this.ypixels);
    obj.grey = true;

end % function
