function output = valueatidx(varargin)
    
% valueatidx  A scalar of the y-value at a given index position.
%
% Syntax
%   output = valueatidx(position);
%
% Description
%   output = valueatidx(position) creates a scalar generated from the
%   y-value at index position.
%
% Copyright (c) 2019, Alex Henderson.
% Licenced under the GNU General Public License (GPL) version 3.
%
% See also 
%   valueat area.

% Contact email: alex.henderson@manchester.ac.uk
% Licenced under the GNU General Public License (GPL) version 3
% http://www.gnu.org/copyleft/gpl.html
% Other licensing options are available, please contact Alex for details
% If you use this file in your work, please acknowledge the author(s) in
% your publications. 

% The latest version of this file is available at:
% https://github.com/AlexHenderson/ChiToolbox


    this = varargin{1};
    position = varargin{2};
    output = this.data(:,position);

end

