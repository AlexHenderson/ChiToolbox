function varargout = tock(tstart)

% tock  An augmented version of toc. 
%
% Syntax
%   elapsed = tock();
%   elapsed = tock(tstart);
%
% Description
%   elapsed = tock() is essentially the same as the built-in toc function,
%   reporting the time elapsed since the most recent call to tic. The
%   output is formatted into weeks, days, hours, minutes and seconds.
%
%   elapsed = tock(tstart) reports the time elapsed since the specific tic
%   command that generated tstart.
%
% Copyright (c) 2017, Alex Henderson.
% Licenced under the GNU Lesser General Public License (LGPL) version 3.
%
% See also 
%   tic, toc, durationString.

% Contact email: alex.henderson@manchester.ac.uk
% Licenced under the GNU Lesser General Public License (LGPL) version 3
% http://www.gnu.org/licenses/lgpl.html
% Other licensing options are available, please contact Alex for details
% If you use this file in your work, please acknowledge the author(s) in
% your publications. 

% Version 1.0, November 2017

if exist('tstart','var')
    elapsed = durationString(toc(tstart));
else
    elapsed = durationString(toc());
end

if (nargout > 0)
    varargout{1} = elapsed;
else
    disp(['Elapsed time is ', elapsed, '.']);
end
