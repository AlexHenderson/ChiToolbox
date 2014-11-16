function output = removerangeidx(this,from,to)
% Remove a spectral range using index values
% Copyright (c) 2014 Alex Henderson (alex.henderson@manchester.ac.uk)

    % Swap if 'from' is higher than 'to'
    [from,to] = ChiForceIncreasing(from,to);

    from = from-1;
    to = to+1;

    tempdata = [this.data(:,1:from),this.data(:,to:end)];
    tempxvals = [this.xvals(1:from),this.xvals(to:end)];
    % TODO: copy/clone?
    output = ChiImage(tempxvals,tempdata,this.reversex,this.xlabel,this.ylabel,this.xpixels,this.ypixels,this.masked,this.mask);
    output.log = vertcat(this.log,['removerangefromindexvals, from ', num2str(from), ' to ', num2str(to)]);
end
