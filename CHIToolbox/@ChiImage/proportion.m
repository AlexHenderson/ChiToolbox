function output = proportion(this,numerator,denominator)
% Generate ChiPicture of a proportion of spectral ranges using xvalues
% Copyright (c) 2014 Alex Henderson (alex.henderson@manchester.ac.uk)

    if isscalar(numerator)
        % Single x value
        numeratoridx = this.data(:,numerator);
    else
        if (isvector(numerator) && (length(numerator) == 2))
            % Range of x values to sum over
            numeratoridx1 = indexat(this, numerator(1));
            numeratoridx2 = indexat(this, numerator(2));
            numeratoridx = [numeratoridx1, numeratoridx2];
        else
            % Error
            err = MException('CHI:ChiImage:DimensionalityError', ...
                'Numerator range is not a single value or simple range.');
            throw(err);
        end
    end

    if isscalar(denominator)
        % Single x value
        denominatoridx = indexat(this, denominator);
    else
        if (isvector(denominator) && (length(denominator) == 2))
            % Range of x values to sum over
            denominatoridx1 = indexat(this, denominator(1));
            denominatoridx2 = indexat(this, denominator(2));
            denominatoridx = [denominatoridx1, denominatoridx2];
        else
            % Error
            err = MException('CHI:ChiImage:DimensionalityError', ...
                'Numerator range is not a single value or simple range.');
            throw(err);
        end
    end

    this.history.add(['proportionxvals, ', num2str(numerator), ' / ', num2str(denominator)]);
    output = proportionidx(this,numeratoridx,denominatoridx);
end % proportionxvals
