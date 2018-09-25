function result = centroid(vector, startchannel, endchannel)

%
% Calculates the centroid of a vector range.
% Version 1.0
%
% syntax: result = centroid(vector, startchannel, endchannel);
%
% Takes:
%       A column vector (m x 1, where m is the number of points)
%       The channel at which we start looking for the centroid
%       The channel at which we stop looking for the centroid
%
% Returns:
%       The channel number of the centroid. This value refers to an offset
%       in the original vector and will fall between startchannel and
%       endchannel. 
%
% Notes:
%       Here the centroid is defined as the channel at which the sum of
%       this and the previous channels becomes greater than the total
%       area/2. If the first n channels sum to exactly half the total area
%       then the next channel is identified as the centroid. 
%
% Alex Henderson, February 2007
%

halfarea = sum(vector(startchannel:endchannel))/2;

result = startchannel - round((endchannel - startchannel) / 2); % midpoint
summer = 0;
for channel = startchannel:endchannel
    summer = summer + vector(channel);
    if(summer > halfarea)   % default to high side of exact centre
        result = channel;
        break;
    end
end
        