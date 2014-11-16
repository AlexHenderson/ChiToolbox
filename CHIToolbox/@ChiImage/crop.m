function output = crop(this, lowx,highx, lowy,highy)
% Generate a subset of the image using xy co-ordinates
% Copyright (c) 2014 Alex Henderson (alex.henderson@manchester.ac.uk)

    if ((lowx < 1) || (highx < 1) || (lowy < 1) || (highy < 1))
        err = MException('CHI:ChiImage:OutOfRange', ...
            'Requested range is invalid');
        throw(err);
    end

    % Swap if 'from' is higher than 'to'
    [lowx,highx] = ChiForceIncreasing(lowx,highx);
    % Swap if 'from' is higher than 'to'
    [lowy,highy] = ChiForceIncreasing(lowy,highy);

    % Check for out of range values
    if (lowx > this.xpixels) || (highx > this.xpixels)
        err = MException('CHI:ChiImage:OutOfRange', ...
            'Requested x range is too low/high');
        throw(err);
    end            
    if (lowy > this.ypixels) || (highy > this.ypixels)
        err = MException('CHI:ChiImage:OutOfRange', ...
            'Requested y range is too low/high');
        throw(err);
    end

    % Clone this object
%            output = copy(this);
    output = clone(this);

    % Remove the pixels
    if (~this.masked)
        output.data = reshape(output.data, this.xpixels, this.ypixels, []);
        output.data = output.data(lowy:highy, lowx:highx, :);
        [dims] = size(output.data);
        output.xpixels = dims(2);
        output.ypixels = dims(1);
        output.data = reshape(output.data, output.ypixels * output.xpixels, []);
    else
        output.mask = reshape(this.mask, this.xpixels, this.ypixels, []);
        output.mask = output.mask(lowy:highy, lowx:highx);
        if (all(all(output.mask)))
            % All pixels in this cropped region are unmasked in the
            % original. Therefore the output doesn't require a
            % mask. 
%                     output.data = reshape(output.data, this.xpixels, this.ypixels, []);
%                     output.data = output.data(lowy:highy, lowx:highx, :);
%                     [dims] = size(output.data);
%                     output.xpixels = dims(2);
%                     output.ypixels = dims(1);
%                     output.data = reshape(output.data, output.ypixels * output.xpixels, []);
%                     output.mask = reshape(output.mask, output.xpixels * output.ypixels);
%                     output.masked = false;

% We can't just reshape the data and identify the required pixels since the
% data isn't rectilinear. 

            % TODO: write code
            err = MException('CHI:ChiImage:TODO', ...
                'This code has yet to be written.');
            throw(err);
        else
            if (all(all(~output.mask)))
                % All pixels in this cropped region are masked in
                % the original. Therefore the output is empty. 
                err = MException('CHI:ChiImage:DimensionalityError', ...
                    'All requested pixels have been masked.');
                throw(err);
            else
                % Some pixels are masked and some are not. 
                % TODO: write code
                err = MException('CHI:ChiImage:TODO', ...
                    'This code has yet to be written.');
                throw(err);
            end
        end
    end 
    output.log = vertcat(output.log,['crop: x(',num2str(lowx),':',num2str(highx),') y:(' num2str(lowy),':',num2str(highy),')']);
end
