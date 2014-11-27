function rangeimage = sumrange(this,fromxval,toxval)
% Calculate image over a given summed range
% Copyright (c) 2014 Alex Henderson (alex.henderson@manchester.ac.uk)

    if (~exist('toxval','var'))
        % only have a single x value so only use that position
        toxval = fromxval;
    end

    % Determine the index values of the xvalue limits
    fromidx = indexat(this, fromxval);
    toidx = indexat(this, toxval);
    this.history.add(['sumrange, from ', num2str(fromxval), ' to ', num2str(toxval)]);
    rangeimage = sumrangeidx(this,fromidx,toidx);
end        
