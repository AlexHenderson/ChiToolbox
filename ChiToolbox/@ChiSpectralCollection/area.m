function output = area(this,lowx,highx)

% area  The area under a linear baseline
%
% Syntax
%   values = area(lowx, highx);
%
% Description
%   values = area(lowx, highx) calculates the area under each spectrum
%   between the limits provided in lowx and highx in x-axis units. A linear
%   baseline is removed.
%
% Copyright (c) 2017-2018, Alex Henderson.
% Licenced under the GNU General Public License (GPL) version 3.
%
% See also 
%   areaidx

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

    this.history.add(['measured area from ', num2str(lowx), ' to ', num2str(highx), ' x-axis units']);
    output = this.areaidx(lowidx,highidx);
end
