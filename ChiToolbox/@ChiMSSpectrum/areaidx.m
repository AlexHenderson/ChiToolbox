function output = areaidx(varargin)

% areaidx  The area above a zero intensity baseline
%
% Syntax
%   value = areaidx(lowidx, highidx);
%
% Description
%   value = areaidx(lowidx, highidx) calculates the area under the spectrum
%   between the index limits provided in lowidx and highidx. No baseline is
%   removed.
% 
% Copyright (c) 2017-2019, Alex Henderson.
% Licenced under the GNU General Public License (GPL) version 3.
%
% See also 
%   peakarea peakareaidx area

% Contact email: alex.henderson@manchester.ac.uk
% Licenced under the GNU General Public License (GPL) version 3
% http://www.gnu.org/copyleft/gpl.html
% Other licensing options are available, please contact Alex for details
% If you use this file in your work, please acknowledge the author(s) in
% your publications. 

% The latest version of this file is available at:
% https://github.com/AlexHenderson/ChiToolbox


output = areaidx@ChiMSCharacter(varargin{:});

end % function areaidx
