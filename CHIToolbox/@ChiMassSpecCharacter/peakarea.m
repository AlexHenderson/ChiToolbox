function output = peakarea(this,lowx,highx)

% area  The area above a zero intensity baseline
%
% Syntax
%   values = area(lowx, highx);
%
% Description
%   values = area(lowx, highx) calculates the area under each spectrum
%   between the limits provided in lowx and highx in x-axis units. No
%   baseline is removed.
%   The type of values is a scalar if the input is a spectrum, a vector if
%   the input is a spectral collection and a ChiPicture if the input is an
%   image.
%
% Copyright (c) 2017-2019, Alex Henderson.
% Licenced under the GNU General Public License (GPL) version 3.
%
% See also 
%   ChiSpectralCollection.areaidx

% Contact email: alex.henderson@manchester.ac.uk
% Licenced under the GNU General Public License (GPL) version 3
% http://www.gnu.org/copyleft/gpl.html
% Other licensing options are available, please contact Alex for details
% If you use this file in your work, please acknowledge the author(s) in
% your publications. 

% The latest version of this file is available on Bitbucket
% https://bitbucket.org/AlexHenderson/chitoolbox


    lowidx = indexat(this, lowx);
    highidx = indexat(this, highx);

    this.history.add(['measured area (without baseline) from ', num2str(lowx), ' to ', num2str(highx), ' x-axis units']);
    output = this.peakareaidx(lowidx,highidx);
end
