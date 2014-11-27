function out = subspectrumidx(this,from,to)
% Extract part of the spectrum given a range of index values
% Copyright (c) 2014 Alex Henderson (alex.henderson@manchester.ac.uk)

    % Swap if 'from' is higher than 'to'
    [from,to] = ChiForceIncreasing(from,to);
    out = ChiSpectrum(this.xvals(from:to),this.data(from:to),this.reversex,this.xlabel,this.ylabel);
    this.history.add(['subspectrumidx, from:', num2str(from), ' to:', num2str(to)]);
end
