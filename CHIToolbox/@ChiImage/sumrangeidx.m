function rangeimage = sumrangeidx(this,fromidx,toidx)
% Calculate image over a given summed range
% Copyright (c) 2014 Alex Henderson (alex.henderson@manchester.ac.uk)

    if (~exist('toidx','var'))
        % only have a single index value so only use that position
        toidx = fromidx;
    end

    % Check for out of range values
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

    totrows = sum(this.data(:,fromidx:toidx),2);

    if (this.masked)
        unmasked = zeros(size(totrows));
        totindex = 1;
        for i = 1:length(this.mask)
            if (this.mask(i))
                % Insert the non-zero values back into the required
                % locations. 
                unmasked(i) = totrows(totindex);
                totindex = totindex + 1;
            end
        end
        totrows = unmasked;
    end

    rangeimage = ChiPicture(totrows,this.xpixels,this.ypixels);
    rangeimage.log = vertcat(this.log,['summedrangeimagefromindexvals, from ', num2str(fromidx), ' to ', num2str(toidx)]);
end        
