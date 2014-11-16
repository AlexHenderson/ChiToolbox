function out = sumrangeidx(this,from,to)
% Calculate the sum of a range of index values
% Copyright (c) 2014 Alex Henderson (alex.henderson@manchester.ac.uk)

    % Swap if 'from' is higher than 'to'
    [from,to] = ChiForceIncreasing(from,to);
    out = sum(this.data(from:to));
end
