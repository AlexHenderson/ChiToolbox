function output = areax(this,lowx,highx)
% Generate ChiPicture of a proportion of spectral ranges using x values
% Copyright (c) 2014 Alex Henderson (alex.henderson@manchester.ac.uk)

    lowidx = indexat(this, lowx);
    highidx = indexat(this, highx);

    this.log = vertcat(this.log,['measurearea from ', num2str(lowx), ' to ', num2str(highx)]);
    output = this.areaindex(lowidx,highidx);
end
