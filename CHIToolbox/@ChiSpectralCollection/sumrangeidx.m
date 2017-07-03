function output = sumrangeidx(this,fromidx,toidx)
% Calculate intensities over a given summed range
% Copyright (c) 2014 Alex Henderson (alex.henderson@manchester.ac.uk)

    if ~exist('toidx','var')
        % only have a single index value so only use that position
        toidx = fromidx;
    end

    % Check for out-of-range values
    if (fromidx > this.channels) || (toidx > this.channels)
        err = MException('CHI:ChiImage:OutOfRange', ...
            'Requested range is too high');
        throw(err);
    end            

    if (fromidx < 1) || (toidx < 1)
        err = MException('CHI:ChiImage:OutOfRange', ...
            'Requested range is invalid');
        throw(err);
    end            

    % Swap if 'from' is higher than 'to'
    [fromidx,toidx] = ChiForceIncreasing(fromidx,toidx);

    output = sum(this.data(:,fromidx:toidx),2);

end        
