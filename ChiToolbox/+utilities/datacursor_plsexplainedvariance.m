function output_txt = datacursor_plsexplainedvariance(obj,event_obj) %#ok<INUSL>
% Display the position of the data cursor
% obj          Currently not used (empty)
% event_obj    Handle to event object
% output_txt   Data cursor text string (string or cell array of strings).

% Changed the labels to lowercase and the x output to 6 sf

linenumber = find(event_obj.Target.Parent.Children == event_obj.Target);
lineidx = length(event_obj.Target.Parent.Children) - linenumber + 1;

pos = get(event_obj,'Position');

switch (lineidx)

    case 1
        output_txt = {['comp (x) ',num2str(pos(1),6)],...
            [num2str(pos(2),4),'%']};
    case 2
        output_txt = {['comp (y) ',num2str(pos(1),6)],...
            [num2str(pos(2),4),'%']};
    case 3
        % This is the 95% cut-off line
        output_txt = {'95%'};
    otherwise
        output_txt = {''};
end
        
%     % If there is a Z-coordinate in the position, display it as well
%     if length(pos) > 2
%         output_txt{end+1} = ['z: ',num2str(pos(3),4)];
%     end
end
