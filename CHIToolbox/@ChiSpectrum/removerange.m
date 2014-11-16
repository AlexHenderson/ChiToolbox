function output = removerange(this,from,to)
% Remove a spectral range using x values
% Copyright (c) 2014 Alex Henderson (alex.henderson@manchester.ac.uk)

    % Determine the index values of the xvalue limits
    [fromvalue,fromidx] = min(abs(this.xvals-from));
    [tovalue,toidx] = min(abs(this.xvals-to));
    this.log = vertcat(this.log,['removerange, from:', num2str(from), ' to:', num2str(to)]);            
    output = removerangeidx(this,fromidx,toidx);
end        
