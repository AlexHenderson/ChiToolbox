function output = removerangeidx(this,fromidx,toidx)
% Remove a spectral range using index values
% Copyright (c) 2014 Alex Henderson (alex.henderson@manchester.ac.uk)

    % Swap if 'from' is higher than 'to'
    [fromidx,toidx] = ChiForceIncreasing(fromidx,toidx);

    fromidx = fromidx - 1;
    toidx = toidx + 1;

    tempdata = [this.data(:,1:fromidx),this.data(:,toidx:end)];
    tempxvals = [this.xvals(1:fromidx),this.xvals(toidx:end)];
    % TODO: copy/clone?
    output = ChiImage(tempxvals,tempdata,this.reversex,this.xlabel,this.ylabel,this.xpixels,this.ypixels,this.masked,this.mask);
    output.history.add(['removerangefromindexvals, from ', num2str(fromidx), ' to ', num2str(toidx)]);
    this.history.add(['removerangefromindexvals, from ', num2str(fromidx), ' to ', num2str(toidx)]);
end
