function picture = valueat(varargin)

% valueat  A ChiPicture of the y-values at a given x-value
%
% Syntax
%   picture = valueat(xvalue);
%
% Description
%   picture = valueat(xvalue) creates a ChiPicture generated from the
%   y-values at xvalue. xvalue is in x-axis units.
%
% Copyright (c) 2019, Alex Henderson.
% Licenced under the GNU General Public License (GPL) version 3.
%
% See also 
%   valueatidx area ChiPicture.

% Contact email: alex.henderson@manchester.ac.uk
% Licenced under the GNU General Public License (GPL) version 3
% http://www.gnu.org/copyleft/gpl.html
% Other licensing options are available, please contact Alex for details
% If you use this file in your work, please acknowledge the author(s) in
% your publications. 

% The latest version of this file is available on Bitbucket
% https://bitbucket.org/AlexHenderson/chitoolbox


    this = varargin{1};
    position = this.indexat(varargin{2});
    picture = this.valueatidx(position);
    picture.history.add(['Generated from x-value ', num2str(varargin{2})]);
    
end

