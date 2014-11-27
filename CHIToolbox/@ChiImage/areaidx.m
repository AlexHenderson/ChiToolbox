function output = areaidx(this,lowidx,highidx)
% Generate ChiPicture of a proportion of spectral ranges using index values
% Copyright (c) 2014 Alex Henderson (alex.henderson@manchester.ac.uk)

    % Swap if 'from' is higher than 'to'
    [lowidx,highidx] = ChiForceIncreasing(lowidx,highidx);

    minvalue = min(this.data(:,lowidx:highidx),[],2);
    shifteddata = this.data - repmat(minvalue,1,size(this.data, 2));
    area = sum(shifteddata(:,lowidx:highidx),2);
    triangle = (abs(shifteddata(:,highidx) - shifteddata(:,lowidx)) * (highidx-lowidx + 1)) ./ 2;
    area = area - triangle;
    output = ChiPicture(area,this.xpixels,this.ypixels);
    output.log = vertcat(this.log,['areaindex: from ', num2str(lowidx), ' to ', num2str(highidx)]);
end
