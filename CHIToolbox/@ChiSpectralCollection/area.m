function output = area(this,lowx,highx)
% Generate ChiPicture of a proportion of spectral ranges using x values
% Copyright (c) 2014 Alex Henderson (alex.henderson@manchester.ac.uk)

    lowidx = indexat(this, lowx);
    highidx = indexat(this, highx);

    this.history.add(['measurearea from ', num2str(lowx), ' to ', num2str(highx)]);
    output = this.areaidx(lowidx,highidx);
end
