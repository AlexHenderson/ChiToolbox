function varargout = tock(varargin)

% tock  An augmented version of toc. 
%
% Syntax
%   [elapsed,seconds] = tock();
%   [elapsed,seconds] = tock(tstart);
%   [elapsed,seconds] = tock(____,'prepend',prependtext);
%   [elapsed,seconds] = tock(____,'append',appendtext);
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
%   [elapsed,seconds] = tock(____,'prepend',prependtext) prepends the
%   prependtext to the output string.
% 
%   [elapsed,seconds] = tock(____,'append',appendtext) appends the
%   appendtext to the output string.
% 
% Copyright (c) 2017-2020, Alex Henderson.
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

% Version 3.0, May 2020


%% Defaults
prependtext = 'Elapsed time: ';
appendtext = '.';

%% Manage arguments
argposition = find(cellfun(@(x) strcmpi(x, 'prepend') , varargin));
if argposition
    prependtext = [varargin{argposition + 1}, ' '];
    varargin(argposition + 1) = [];
    varargin(argposition) = [];
end

argposition = find(cellfun(@(x) strcmpi(x, 'append') , varargin));
if argposition
    appendtext = ['. ', varargin{argposition + 1}, ''];
    varargin(argposition + 1) = [];
    varargin(argposition) = []; %#ok<NASGU>
end

%% Other arguments
if exist('tstart','var')
    toc_output = toc(tstart);
else
    toc_output = toc();
end

%% Convert seconds into sensible duration units
elapsed = durationString(toc_output);

%% Determine outputs
switch nargout
    case 0
        disp([prependtext, elapsed, appendtext]);
    case 1
        varargout{1} = elapsed;
    case 2
        varargout{1} = elapsed;
        varargout{2} = toc_output;
    otherwise
        varargout{1} = elapsed;
        varargout{2} = toc_output;
        disp([prependtext, elapsed, appendtext]);
end
