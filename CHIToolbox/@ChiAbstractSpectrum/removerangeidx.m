function output = removerangeidx(this,fromidx,toidx)
% Remove a spectral range using index values
% Copyright (c) 2014 Alex Henderson (alex.henderson@manchester.ac.uk)

    % Swap if 'from' is higher than 'to'
    [fromidx,toidx] = ChiForceIncreasing(fromidx,toidx);

    % We will not actually be removing the range, but keeping the parts of
    % the spectrum that are not within the range. Therefore, we need to
    % step the limits out by one.
    fromidx = fromidx - 1;
    toidx = toidx + 1;

    tempdata = [this.data(1:fromidx),this.data(toidx:end)];
    tempxvals = [this.xvals(1:fromidx),this.xvals(toidx:end)];
    output = ChiSpectrum(tempxvals,tempdata,this.reversex,this.xlabel,this.ylabel);        
    this.history.add(['removerangeidx, from:', num2str(fromidx), ' to:', num2str(toidx)]);            
end
