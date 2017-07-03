function output = removerange(this,from,to)
% Remove a spectral range using x values
% Copyright (c) 2014 Alex Henderson (alex.henderson@manchester.ac.uk)

    % Swap if 'from' is higher than 'to'
    [from,to] = ChiForceIncreasing(from,to);

    % Determine the index values of the xvalue limits
    fromidx = this.indexat(from);
    toidx = this.indexat(to);
    this.history.add(['removerange, from:', num2str(from), ' to:', num2str(to)]);            
    output = this.removerangeidx(fromidx,toidx);
end        
