function output = ratioidx(this,numerator,denominator)
% Generate ChiPicture of a ratio of spectral ranges using index values
% Copyright (c) 2014 Alex Henderson (alex.henderson@manchester.ac.uk)

    if isscalar(numerator)
        % Single x value
        numerator_data = this.data(:,numerator);
    else
        if (isvector(numerator) && (length(numerator) == 2))
            % Range of x values to sum over
            numerator_data = sum(this.data(:,numerator(1):numerator(2)),2);
        else
            % Error
            err = MException('CHI:ChiImage:DimensionalityError', ...
                'Numerator range is not a single value or simple range.');
            throw(err);
        end
    end

    if isscalar(denominator)
        % Single x value
        denominator_data = this.data(:,denominator);
    else
        if (isvector(denominator) && (length(denominator) == 2))
            % Range of x values to sum over
            denominator_data = sum(this.data(:,denominator(1):denominator(2)),2);
        else
            % Error
            err = MException('CHI:ChiImage:DimensionalityError', ...
                'Numerator range is not a single value or simple range.');
            throw(err);
        end
    end

    the_ratio = numerator_data ./ denominator_data;

    if this.masked
        unmasked = zeros(this.ypixels,this.xpixels);
        totindex = 1;
        for i = 1:length(this.mask)
            if (this.mask(i))
                % Insert the non-zero values back into the required
                % locations. 
                unmasked(i) = the_ratio(totindex);
                totindex = totindex + 1;
            end
        end
        the_ratio = unmasked;
    end

    output = ChiPicture(the_ratio,this.xpixels,this.ypixels);
    output.history.add(['ratioindex, ', num2str(numerator), ' / ', num2str(denominator)]);
    this.history.add(['ratioindex, ', num2str(numerator), ' / ', num2str(denominator)]);

end % ratioindex        
