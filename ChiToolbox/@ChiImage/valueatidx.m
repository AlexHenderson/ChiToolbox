function picture = valueatidx(varargin)
    
% valueatidx  A ChiPicture of the y-values at a given index position.
%
% Syntax
%   picture = valueatidx(position);
%
% Description
%   picture = valueatidx(position) creates a ChiPicture generated from the
%   y-values at index position. 
%
% Copyright (c) 2019, Alex Henderson.
% Licenced under the GNU General Public License (GPL) version 3.
%
% See also 
%   valueat area ChiPicture.

% Contact email: alex.henderson@manchester.ac.uk
% Licenced under the GNU General Public License (GPL) version 3
% http://www.gnu.org/copyleft/gpl.html
% Other licensing options are available, please contact Alex for details
% If you use this file in your work, please acknowledge the author(s) in
% your publications. 

% The latest version of this file is available on Bitbucket
% https://bitbucket.org/AlexHenderson/chitoolbox


    this = varargin{1};
    position = varargin{2};
    picture = ChiPicture(this.data(:,position),this.xpixels,this.ypixels);
    picture.history.add(this.history);
    picture.history.add(['Generated from position ', num2str(position)]);

end

