function output_txt = datacursor_6sf(obj,event_obj) %#ok<INUSL>
% Display the position of the data cursor
% obj          Currently not used (empty)
% event_obj    Handle to event object
% output_txt   Data cursor text string (string or cell array of strings).

% Changed the labels to lowercase and the x output to 6 sf

pos = get(event_obj,'Position');
output_txt = {['x: ',num2str(pos(1),6)],...
    ['y: ',num2str(pos(2),4)]};

% If there is a Z-coordinate in the position, display it as well
if length(pos) > 2
    output_txt{end+1} = ['z: ',num2str(pos(3),4)];
end
