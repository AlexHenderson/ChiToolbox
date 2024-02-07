function output = valueat(varargin)

% valueat  A scalar of the y-value at a given x-value
%
% Syntax
%   output = valueat(xvalue);
%
% Description
%   output = valueat(xvalue) creates a scalar generated from the y-value
%   at xvalue. xvalue is in x-axis units.
%
% Copyright (c) 2019, Alex Henderson.
% Licenced under the GNU General Public License (GPL) version 3.
%
% See also 
%   valueatidx area.

% Contact email: alex.henderson@manchester.ac.uk
% Licenced under the GNU General Public License (GPL) version 3
% http://www.gnu.org/copyleft/gpl.html
% Other licensing options are available, please contact Alex for details
% If you use this file in your work, please acknowledge the author(s) in
% your publications. 

% The latest version of this file is available at:
% https://github.com/AlexHenderson/ChiToolbox


    this = varargin{1};
    position = this.indexat(varargin{2});
    output = this.valueatidx(position);
    
end

