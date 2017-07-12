function output = spectrumat(this,xpos,ypos)
% Get spectrum at a given location in the image
% Copyright (c) 2014 Alex Henderson (alex.henderson@manchester.ac.uk)

    % Handle error where xpos and/or ypos are outside image
    if (xpos > this.xpixels) || (ypos > this.ypixels)
        err = MException('CHI:ChiImage:OutOfRange', ...
            'Requested location is outside image');
        throw(err);
    end            

    if (xpos < 1) || (ypos < 1)
        err = MException('CHI:ChiImage:OutOfRange', ...
            'Requested location is invalid');
        throw(err);
    end            

    % TODO: test whether this approach creates a temporary object.
    % If so use the commented out version for large data. This
    % gives a warning, about handles, but since we're reshaping and
    % then reshaping back to the original there is no problem. 
    % UPDATE 27/10/2104: Now a handle class so it may not matter. 

    if this.masked
        this.mask = reshape(this.mask, this.ypixels, this.xpixels);
        if (this.mask(ypos,xpos) == false)
            % This is a pixel we've rejected so return zeros
            spectrumdata = zeros(1,this.channels());
        end
    else
        y = reshape(this.data,this.ypixels,this.xpixels,[]);
        spectrumdata = squeeze(y(ypos,xpos,:));
    end

    output = ChiSpectrum(this.xvals,spectrumdata,this.reversex,this.xlabel,this.ylabel);
    output.history.add(['spectrumat, x=', num2str(xpos), ', y=', num2str(ypos)]);
    this.history.add(['spectrumat, x=', num2str(xpos), ', y=', num2str(ypos)]);

end