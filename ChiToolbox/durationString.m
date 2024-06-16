function [str,vals,txt] = durationString(secs)

% durationString  A formatted version of a time duration. 
%
% Syntax
%   str = durationString(secs);
%   [str,vals] = durationString(secs);
%   [str,vals,txt] = durationString(secs);
%
% Description
%   str = durationString(secs) returns a character string with the
%   duration in seconds, broken down into weeks, days, hours, minutes
%   and seconds. Longer periods are omitted if the duration does not
%   require them.
%
%   [str,vals] = durationString(secs) returns vals, a structure
%   containing the duration periods.
%
%   [str,vals,txt] = durationString(secs) returns txt, a structure
%   containing the duration titles. 
%
% Notes
%   This can be used in conjunction with the built-in toc function to
%   format the output. See tock.m for a wrapper function.
%
% Examples
%   str = durationString(5000000)
%   str =
%   57 days, 20 hours, 53 minutes, 20 seconds
%
%   str = durationString(5000)
%   str =
%   1 hour, 23 minutes, 20 seconds
%
%   str = durationString(toc)   % where toc is 62 seconds
%   str =
%   1 minute, 2 seconds
% 
% Copyright (c) 2017-2024, Alex Henderson.
% Licenced under the GNU Lesser General Public License (LGPL) version 3.
%
% See also 
%   tic, toc, duration (>=R2014b), tock.

% Contact email: alex.henderson@manchester.ac.uk
% Licenced under the GNU Lesser General Public License (LGPL) version 3
% http://www.gnu.org/licenses/lgpl.html
% Other licensing options are available, please contact Alex for details
% If you use this file in your work, please acknowledge the author(s) in
% your publications. 

% Version 2.0, June 2024
% Converted to duration calculation
% Dropped weeks
% Version 1.0, November 2017


%% Calculate the durations
numdays = floor(days(duration(0,0,secs)));
numhours = floor(hours(duration(0,0,secs) - days(numdays)));
nummins = floor(minutes(duration(0,0,secs) - days(numdays) - hours(numhours)));
numsecs = (seconds(duration(0,0,secs) - days(numdays) - hours(numhours) - minutes(nummins)));

%% Tidy up the text
dayStr = 'days';
hourStr = 'hours';
minStr = 'minutes';
secStr = 'seconds';

if (numdays == 1)
    dayStr = 'day';
end

if (numhours == 1)
    hourStr = 'hour';
end

if (nummins == 1)
    minStr = 'minute';
end

if (numsecs == 1)
    secStr = 'second';
end

%% Generate the output
if numdays
    [str,errormessage] = sprintf('%d %s, %d %s, %d %s, %g %s',...
        numdays,dayStr,numhours,hourStr,nummins,minStr,numsecs,secStr);
else
    if numhours
        [str,errormessage] = sprintf('%d %s, %d %s, %g %s',...
            numhours,hourStr,nummins,minStr,numsecs,secStr);
    else
        if nummins
            [str,errormessage] = sprintf('%d %s, %g %s',...
                nummins,minStr,numsecs,secStr);
        else
            [str,errormessage] = sprintf('%g %s',numsecs,secStr);
        end
    end
end

%% Check for errors
if ~isempty(errormessage)
    ex = MException('tock:formatting',errormessage);
    throw(ex);
end

%% Gather output
vals.days = numdays;
vals.hours = numhours;
vals.mins = nummins;
vals.secs = numsecs;

txt.days = dayStr;
txt.hours = hourStr;
txt.mins = minStr;
txt.secs = secStr;

end
