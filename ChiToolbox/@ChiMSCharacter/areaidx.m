function output = areaidx(this,lowx,highx)

% areaidx  The area above a zero intensity baseline
%
% Syntax
%   values = areaidx(lowidx, highidx);
%
% Description
%   values = areaidx(lowidx, highidx) calculates the area under each
%   spectrum between the index limits provided in lowidx and highidx. No
%   baseline is removed.
%   The type of values is a scalar is the input is a spectrum, a vector if
%   the input is a spectral collection and a ChiPicture if the input is an
%   image.
%
% Copyright (c) 2017-2019, Alex Henderson.
% Licenced under the GNU General Public License (GPL) version 3.
%
% See also 
%   peakarea area

% Contact email: alex.henderson@manchester.ac.uk
% Licenced under the GNU General Public License (GPL) version 3
% http://www.gnu.org/copyleft/gpl.html
% Other licensing options are available, please contact Alex for details
% If you use this file in your work, please acknowledge the author(s) in
% your publications. 

% The latest version of this file is available on Bitbucket
% https://bitbucket.org/AlexHenderson/chitoolbox


    output = this.peakareaidx(lowx,highx);

end

