function warningnobacktrace(varargin)

% warningnobacktrace  Emits a warning without backtrace information
%
% Syntax
%   warningnobacktrace(warninginfo);
%
% Description
%   warningnobacktrace(warninginfo) reports a warning without listing the
%   backtrace information. Backtrace is a listing of the location of the
%   warning and the functions that lead to the problematic code.
%
% Copyright (c) 2017, Alex Henderson.
% Licenced under the GNU General Public License (GPL) version 3.
%
% See also 
%   warning error.

% Contact email: alex.henderson@manchester.ac.uk
% Licenced under the GNU General Public License (GPL) version 3
% http://www.gnu.org/copyleft/gpl.html
% Other licensing options are available, please contact Alex for details
% If you use this file in your work, please acknowledge the author(s) in
% your publications. 

% Version 1.0, August 2017
% The latest version of this file is available at:
% https://github.com/AlexHenderson/ChiToolbox


previousWarning = warning('backtrace','off');
warning(varargin{:});
warning(previousWarning);

end
