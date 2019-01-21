function output = areaidx(varargin)

% areaidx  The area above a zero intensity baseline
%
% Syntax
%   values = areaidx(lowidx, highidx);
%
% Description
%   values = areaidx(lowidx, highidx) calculates the area under each
%   spectrum between the index limits provided in lowidx and highidx. No
%   baseline is removed.
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

% The latest version of this file is available on Bitbucket
% https://bitbucket.org/AlexHenderson/chitoolbox


output = areaidx@ChiMassSpecCharacter(varargin{:});

end % function areaidx
