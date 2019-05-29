function output = sumrangeidx(this,fromidx,toidx)
% Calculate the sum of a range of index values
% Copyright (c) 2014 Alex Henderson (alex.henderson@manchester.ac.uk)

    % Swap if 'from' is higher than 'to'
    [fromidx,toidx] = utilities.forceincreasing(fromidx,toidx);
    output = sum(this.data(fromidx:toidx));
end
