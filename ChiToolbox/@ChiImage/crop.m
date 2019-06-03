function obj = crop(varargin)
% Generate a subset of the image using xy co-ordinates
% Copyright (c) 2014-2018 Alex Henderson (alex.henderson@manchester.ac.uk)


this = varargin{1};

if nargout
    obj = this.clone();
    % Not a great approach, but quite generic. 
    % Prevents errors if the function name changes. 
    command = [mfilename, '(obj,varargin{2:end});']; 
    eval(command);  
else
    % We are expecting to modify this object in situ

    lowx = varargin{2};
    highx = varargin{3};
    lowy = varargin{4};
    highy = varargin{5};
    
    if ((lowx < 1) || (highx < 1) || (lowy < 1) || (highy < 1))
        err = MException(['CHI:',mfilename,':OutOfRange'], ...
            'Requested range is invalid');
        throw(err);
    end

    % Swap if 'from' is higher than 'to'
    [lowx,highx] = utilities.forceincreasing(lowx,highx);
    % Swap if 'from' is higher than 'to'
    [lowy,highy] = utilities.forceincreasing(lowy,highy);

    % Check for out of range values
    if (lowx > this.xpixels) || (highx > this.xpixels)
        err = MException(['CHI:',mfilename,':OutOfRange'], ...
            'Requested x range is too low/high');
        throw(err);
    end            
    if (lowy > this.ypixels) || (highy > this.ypixels)
        err = MException(['CHI:',mfilename,':OutOfRange'], ...
            'Requested y range is too low/high');
        throw(err);
    end

    % Remove the pixels
    if ~this.masked
        this.data = reshape(this.data, this.xpixels, this.ypixels, []);
        this.data = this.data(lowy:highy, lowx:highx, :);
        [dims] = size(this.data);
        this.xpixels = dims(2);
        this.ypixels = dims(1);
        this.data = reshape(this.data, this.ypixels * this.xpixels, []);
    else
        this.mask = reshape(this.mask, this.xpixels, this.ypixels, []);
        this.mask = this.mask(lowy:highy, lowx:highx);
        if all(all(this.mask))
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
            err = MException(['CHI:',mfilename,':ToDo'], ...
                'This code has yet to be completed.');
            throw(err);
        else
            if all(all(~this.mask))
                % All pixels in this cropped region are masked in
                % the original. Therefore the output is empty. 
                err = MException(['CHI:',mfilename,':DimensionalityError'], ...
                    'All requested pixels have been masked.');
                throw(err);
            else
                % Some pixels are masked and some are not. 
                % TODO: write code
                err = MException(['CHI:',mfilename,':ToDo'], ...
                    'This code has yet to be written.');
                throw(err);
            end
        end
    end 
    this.history.add(['crop: x(',num2str(lowx),':',num2str(highx),') y:(' num2str(lowy),':',num2str(highy),')']);
    this.history.add(['crop: x(',num2str(lowx),':',num2str(highx),') y:(' num2str(lowy),':',num2str(highy),')']);
end
