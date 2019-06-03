function output = ChiMeasureArea(input,lowx,highx)

% ChiMeasureArea Measure area above a linear baseline using x values
%   Copyright (c) 2014 Alex Henderson (alex.henderson@manchester.ac.uk)

% See notes below

if (isa(input,'ChiSpectrum') || isa(input,'ChiImage'))

    % Swap if 'from' is higher than 'to'
    [lowx,highx] = utilities.forceincreasing(lowx,highx);
    
    lowidx = input.indexat(lowx);
    highidx = input.indexat(highx);
    
    if isa(input,'ChiImage')
        minvalue = min(input.data(:,lowidx:highidx),[],2);
        shifteddata = input.data - repmat(minvalue,1,size(input.data, 2));
        area = sum(shifteddata(:,lowidx:highidx),2);
        triangle = (abs(shifteddata(:,highidx) - shifteddata(:,lowidx)) * (highidx-lowidx + 1)) ./ 2;
        area = area - triangle;
        output = ChiPicture(area,input.xpixels,input.ypixels);
        output.history.add(['MeasureArea from ', num2str(lowx), ' to ', num2str(highx)]);
    end
    
    if isa(input,'ChiSpectrum')
        minvalue = min(input.data(lowidx:highidx));
        shifteddata = input.data - minvalue;
        area = sum(shifteddata(lowidx:highidx));
        triangle = (abs(shifteddata(highidx) - shifteddata(lowidx)) * (highidx-lowidx + 1)) ./ 2;
        area = area - triangle;
        output = area;
    end
    
end % class type check
   
end % function

%% Notes
% Code taken from measureare.m version 2. 
% Shift the curve so that, in the region we are measuring over, the lowest
% intensity is zero.
% We then sum this region. 
% Next we subtract a triangle defined by the difference in the intensity of
% the endpoints and the number of channels in the range.
