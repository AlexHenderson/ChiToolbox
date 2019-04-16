function output = sumrange(this,from,to)
% Calculate the sum of a range of xvalues
% Copyright (c) 2014 Alex Henderson (alex.henderson@manchester.ac.uk)

    % Swap if 'from' is higher than 'to'
    [from,to] = ChiForceIncreasing(from,to);
    % Determine the index values of the xvalue limits
    fromidx = this.indexat(from);
    toidx = this.indexat(to);
    output = this.sumrangeidx(fromidx,toidx);
end
