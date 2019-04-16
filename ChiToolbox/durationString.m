function [str,vals,txt] = durationString(seconds)

% durationString  A formatted version of a time duration. 
%
% Syntax
%   str = durationString(seconds);
%   [str,vals] = durationString(seconds);
%   [str,vals,txt] = durationString(seconds);
%
% Description
%   str = durationString(seconds) returns a character string with the
%   duration in seconds, broken down into weeks, days, hours, minutes
%   and seconds. Longer periods are omitted if the duration does not
%   require them.
%
%   [str,vals] = durationString(seconds) returns vals, a structure
%   containing the duration periods.
%
%   [str,vals,txt] = durationString(seconds) returns txt, a structure
%   containing the duration titles. 
%
% Notes
%   This can be used in conjunction with the built-in toc function to format
%   the output. See tock.m for a wrapper function. 
%
% Examples
%   str = durationString(5000000)
%   str =
%   8 weeks, 1 day, 20 hours, 53 minutes, 20 seconds
%
%   str = durationString(5000)
%   str =
%   1 hour, 23 minutes, 20 seconds
%
%   str = durationString(toc)   % where toc is 62 seconds
%   str =
%   1 minute, 2 seconds
% 
% Copyright (c) 2017, Alex Henderson.
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

% Version 1.0, November 2017


%% Calculate the durations
weeks = floor(seconds / (60*60*24*7));
leaving = rem(seconds, (60*60*24*7));

days = floor(leaving / (60*60*24));
leaving = rem(leaving, (60*60*24));

hours = floor(leaving / (60*60));
leaving = rem(leaving, (60*60));

mins = floor(leaving / (60));
secs = rem(leaving, (60));

%% Tidy up the text
weekStr = 'weeks';
dayStr = 'days';
hourStr = 'hours';
minStr = 'minutes';
secStr = 'seconds';

if (weeks == 1)
    weekStr = 'week';
end

if (days == 1)
    dayStr = 'day';
end

if (hours == 1)
    hourStr = 'hour';
end

if (mins == 1)
    minStr = 'minute';
end

if (secs == 1)
    secStr = 'second';
end

%% Generate the output
if weeks
    [str,errormessage] = sprintf('%d %s, %d %s, %d %s, %d %s, %g %s',...
        weeks,weekStr,days,dayStr,hours,hourStr,mins,minStr,secs,secStr);
else
    if days
        [str,errormessage] = sprintf('%d %s, %d %s, %d %s, %g %s',...
            days,dayStr,hours,hourStr,mins,minStr,secs,secStr);
    else
        if hours
            [str,errormessage] = sprintf('%d %s, %d %s, %g %s',...
                hours,hourStr,mins,minStr,secs,secStr);
        else
            if mins
                [str,errormessage] = sprintf('%d %s, %g %s',...
                    mins,minStr,secs,secStr);
            else
                [str,errormessage] = sprintf('%g %s',secs,secStr);
            end
        end
    end
end

%% Check for errors
if ~isempty(errormessage)
    ex = MException('tock:formatting',errormessage);
    throw(ex);
end

%% Gather output
vals.weeks = weeks;
vals.days = days;
vals.hours = hours;
vals.mins = mins;
vals.secs = secs;

txt.weeks = weekStr;
txt.days = dayStr;
txt.hours = hourStr;
txt.mins = minStr;
txt.secs = secStr;

end
