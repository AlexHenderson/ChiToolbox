function output_txt = datacursor(obj,event_obj,chiobj,cursorinfo) %#ok<INUSL>

% datacursor  Determines the text to place on the data cursor of a plot. 
%
% Syntax
%   output_txt = datacursor(obj,event_obj,chiobj,cursorinfo);
%   obj          Currently not used (empty)
%   event_obj    Handle to event object
%   chiobj       An object of the ChiToolbox
%   cursorinfo   A struct containing useful information from the plotspectrum routine
%   output_txt   Data cursor text string (string or cell array of strings).
%
% This is an internal function called by plotspectrum. It cannot be run
% outside of the datacursormode display mechanism. 
%
% Copyright (c) 2017, Alex Henderson.
% Licenced under the GNU General Public License (GPL) version 3.
%
% See also 
%   plot datacursormode plotspectrum.

% Contact email: alex.henderson@manchester.ac.uk
% Licenced under the GNU General Public License (GPL) version 3
% http://www.gnu.org/copyleft/gpl.html
% Other licensing options are available, please contact Alex for details
% If you use this file in your work, please acknowledge the author(s) in
% your publications. 

% Version 1.0, August 2017
% The latest version of this file is available on Bitbucket
% https://bitbucket.org/AlexHenderson/chitoolbox


%% Position of cursor in x/y space (not pixels)
pos = get(event_obj,'Position');
xpos = pos(1);
ypos = pos(2);

%% Which line has been chosen
% First find the target line in the list of all lines. 
% The lines appear to be drawn in reverse order, so count from the end. 
linenumber = find(event_obj.Target.Parent.Children == event_obj.Target);
lineidx = length(event_obj.Target.Parent.Children) - linenumber + 1;

% If the data was plotted grouped, the order the lines are plotted is
% different. Therefore we need to map the line number back to the order of
% plotting.
% Could also look into the possibility of using
% event_obj.Target.DisplayName, but this pulls the text from the legend, so
% if the legend doesn't exist, the text isn't available.
if cursorinfo.grouped
    if strcmpi(cursorinfo.plotfunction, 'std')
        % The std plot has 4 graphics objects per 'line', so bounce to the
        % first one
        lineidx = ceil(lineidx/4);
    end
    lineidx = cursorinfo.plottedId(lineidx);
end

%% Build the data cursor text
% Coordinates
output_txt = {['x: ', num2str(xpos,6)],...
              ['y: ', num2str(ypos,4)]};

% A blank line
output_txt{end+1} = '';

% Either we have an observation (spectrum) number or a summary function name          
if strcmpi(cursorinfo.plotfunction, 'none')
    output_txt{end+1} = ['Observation: ', num2str(lineidx)];
else
    % We have a summary plot, so no observation number
    output_txt{end+1} = ['Function: ', cursorinfo.plotfunction];
end

% If we have class info, we should use it
if ~isempty(chiobj.classmembership)
    % We have class info
    if strcmpi(cursorinfo.plotfunction, 'none')
        % No summary, so list all class entries
        output_txt{end+1} = ['Class: ', chiobj.classmembership.labels{lineidx}];
    else
        % This is a summary, so only list the unique classes
        output_txt{end+1} = ['Class: ', chiobj.classmembership.uniquelabels{lineidx}];
    end
end    
