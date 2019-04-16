function output = applymask(this, mask)
% Remove unwanted pixels
% Copyright (c) 2014 Alex Henderson (alex.henderson@manchester.ac.uk)

    % Check mask is the right size
    if (numel(mask) ~= (this.xpixels * this.ypixels))
        err = MException('CHI:ChiImage:OutOfRange', ...
            'mask is wrong size');
        throw(err);
    end

    % TODO: Handle situation where the data is already masked. 

    % Clone this object
%            output = copy(this);
    output = clone(this);

    % Determine the dimensionality of the mask and make 1D
    mask = reshape(mask,(this.xpixels * this.ypixels), 1);
    output.mask = logical(mask);

    % Remove the pixels
    output.data = output.data(output.mask, :);
    output.masked = true;
%     out.log = vertcat(out.log,['applymask: ', num2str(mask)]);            
end
