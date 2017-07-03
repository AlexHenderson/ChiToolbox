function output = sumrange(this,from,to)
% Calculate intensities over a given summed range
% Copyright (c) 2014 Alex Henderson (alex.henderson@manchester.ac.uk)

    if ~exist('to','var')
        % only have a single x value so only use that position
        to = from;
    end

    % Determine the index values of the xvalue limits
    fromidx = indexat(this, from);
    toidx = indexat(this, to);
    this.history.add(['sumrange, from ', num2str(from), ' to ', num2str(to)]);
    output = sumrangeidx(this,fromidx,toidx);
end        
