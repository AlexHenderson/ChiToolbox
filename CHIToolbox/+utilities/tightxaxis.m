function tightxaxis()
%XAXISTIGHT Summary of this function goes here
%   Detailed explanation goes here

% Taken from
% https://uk.mathworks.com/matlabcentral/answers/295700-how-to-use-the-tight-function-for-just-one-axis

    currentY = ylim(gca);   % retrieve auto y-limits
    axis tight;             % set tight range
    ylim(gca,currentY)      % restore y limits 

end
