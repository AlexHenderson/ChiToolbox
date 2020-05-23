function output_txt = datacursor_scores_6sf(obj,event_obj,varargin)
% Display data cursor position in a data tip
% obj          Currently not used
% event_obj    Handle to event object
% output_txt   Data tip text, returned as a character vector or a cell array of character vectors

pos = event_obj.Position;

% The children of the figure are composed of patches that are rendered at
% the same time. These correspond to the coloured groups. 
% We can use this to determine which class a given point is a member of. 
% Patches are rendered in reverse order, so first class last. Therefore
% need to count from the end to determine which patch a point lies in. 
patchnumber = find(event_obj.Target.Parent.Children == event_obj.Target);
patchidx = length(event_obj.Target.Parent.Children) - patchnumber + 1;

chiobj = varargin{1};
plotinfo = varargin{2};

if ~isfield(plotinfo,'sigfigs')
    plotinfo.sigfigs = 6;
end

% Try to identify the data points. MATLAB doesn't seem to have a way of
% doing this. All the points in a scatter plot are drawn as a patch,
% depending on their colour. 
matchingxpoints = find(plotinfo.xdata == pos(1));
matchingypoints = find(plotinfo.ydata == pos(2));
matching = intersect(matchingxpoints,matchingypoints);

% Hopefully there will be only a single point matching these coordinates

%********* Define the content of the data tip here *********%

% Display the x and y values:
output_txt = {[plotinfo.xpointlabel,formatValue(pos(1),event_obj,plotinfo)],...
              [plotinfo.ypointlabel,formatValue(pos(2),event_obj,plotinfo)]};

% If there is a z value, display it:
if length(pos) > 2
    output_txt{end+1} = ['plotinfo.zpointlabel',formatValue(pos(3),event_obj,plotinfo)];
end

% Add the spectrum number(s)
for i = 1:length(matching)
    output_txt{end+1} = ['spectrum', formatText(event_obj,utilities.tostring(matching(i)))];
end

% If the data point is labelled, show the label
if ~isempty(chiobj.classmembership)
    output_txt{end+1} = ['label', formatText(event_obj,utilities.tostring(chiobj.classmembership.labelat(patchidx)))];
end

end % function datacursor_scores_6sf

%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
function formattedValue = formatValue(value,event_obj,plotinfo)
% If you do not want TeX formatting in the data tip, uncomment the line below.
event_obj.Interpreter = 'none';
if strcmpi(event_obj.Interpreter,'tex')
    valueFormat = ' \color[rgb]{0 0.6 1}\bf';
    removeValueFormat = '\color[rgb]{.25 .25 .25}\rm';
else
    valueFormat = ': ';
    removeValueFormat = '';
end
formattedValue = [valueFormat num2str(value,plotinfo.sigfigs) removeValueFormat];

end % function formatValue
%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

function formattedText = formatText(event_obj,text)
% If you do not want TeX formatting in the data tip, uncomment the line below.
event_obj.Interpreter = 'none';
if strcmpi(event_obj.Interpreter,'tex')
    valueFormat = ' \color[rgb]{0 0.6 1}\bf';
    removeValueFormat = '\color[rgb]{.25 .25 .25}\rm';
else
    valueFormat = ': ';
    removeValueFormat = '';
end
formattedText = [valueFormat text removeValueFormat];

end % function formattedText