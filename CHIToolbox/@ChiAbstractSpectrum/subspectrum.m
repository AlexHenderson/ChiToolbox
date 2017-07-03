function output = subspectrum(this,from,to)
% Extract part of the spectrum given a range of xvalues
% Copyright (c) 2014 Alex Henderson (alex.henderson@manchester.ac.uk)

    % Swap if 'from' is higher than 'to'
    [from,to] = ChiForceIncreasing(from,to);
    % Determine the index values of the xvalue limits
    fromidx = this.indexat(from);
    toidx = this.indexat(to);
    output = subspectrumidx(this,fromidx,toidx);
    this.history.add(['subspectrum, from:', num2str(from), ' to:', num2str(to)]);            
end
