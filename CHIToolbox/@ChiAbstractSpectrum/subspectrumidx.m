function output = subspectrumidx(this,fromidx,toidx)
% Extract part of the spectrum given a range of index values
% Copyright (c) 2014 Alex Henderson (alex.henderson@manchester.ac.uk)

    % Swap if 'from' is higher than 'to'
    [fromidx,toidx] = ChiForceIncreasing(fromidx,toidx);

    output = ChiSpectrum(this.xvals(fromidx:toidx),this.data(fromidx:toidx),this.reversex,this.xlabel,this.ylabel);
    this.history.add(['subspectrumidx, from:', num2str(fromidx), ' to:', num2str(toidx)]);
end
