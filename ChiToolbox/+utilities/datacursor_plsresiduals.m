function output_txt = datacursor_plsresiduals(obj,event_obj, varargin) %#ok<INUSL>
% Display the position of the data cursor
% obj          Currently not used (empty)
% event_obj    Handle to event object
% output_txt   Data cursor text string (string or cell array of strings).

% Changed the labels to lowercase and the x output to 6 sf


xcoordlabel = 'x';
ycoordlabel = 'y';

if ~isempty(varargin)
    xcoordlabel = varargin{1};
    ycoordlabel = varargin{2};
end

linenumber = find(event_obj.Target.Parent.Children == event_obj.Target);
% lineidx = length(event_obj.Target.Parent.Children) - linenumber + 1;

% linenumber is 1 for the xaxis line, so shouldn't generate a datatip
if linenumber ~= 1
    pos = get(event_obj,'Position');
    output_txt = {...
        [xcoordlabel, ': ', num2str(pos(1),6)], ...
        [ycoordlabel, ': ', num2str(pos(2),4)] ...
        };
    % xlabelprefix = obj.DataSource.Parent.XLabel.String;
    % ylabelprefix = obj.DataSource.Parent.YLabel.String;
    % output_txt = {[xlabelprefix, ': ', num2str(pos(1),6)],...
    %     [ylabelprefix, ': ' ,num2str(pos(2),4)]};

    % If there is a Z-coordinate in the position, display it as well
    if length(pos) > 2
        output_txt{end+1} = ['z: ',num2str(pos(3),4)];
    end
end