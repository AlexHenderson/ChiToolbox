function varargout = tock(tstart)

% tock  An augmented version of toc. 
%
% Syntax
%   [elapsed,seconds] = tock();
%   [elapsed,seconds] = tock(tstart);
%
% Description
%   [elapsed,seconds] = tock() is essentially the same as the built-in toc function,
%   reporting the time elapsed since the most recent call to tic. The
%   output elapsed is formatted into weeks, days, hours, minutes and
%   seconds. seconds is the number of seconds since the previous tic
%   command, equivalent of the toc output.
%
%   [elapsed,seconds] = tock(tstart) reports the time elapsed since the
%   specific tic command that generated tstart.
%
% Copyright (c) 2017-2018, Alex Henderson.
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

% Version 2.0, June 2018

if exist('tstart','var')
    toc_output = toc(tstart);
else
    toc_output = toc();
end

elapsed = durationString(toc_output);

switch nargout
    case 0
        disp(['Elapsed time: ', elapsed, '.']);
    case 1
        varargout{1} = elapsed;
    case 2
        varargout{1} = elapsed;
        varargout{2} = toc_output;
    otherwise
        varargout{1} = elapsed;
        varargout{2} = toc_output;
        disp(['Elapsed time: ', elapsed, '.']);
end
