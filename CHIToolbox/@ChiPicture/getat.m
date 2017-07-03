function output = getat(this,xpos,ypos)
% getat Get value at a location in the image

    if (xpos > this.xpixels) || (ypos > this.ypixels)
        err = MException('CHI:ChiPicture:OutOfRange', ...
            'Requested location is outside image');
        throw(err);
    end            

    if (xpos < 1) || (ypos < 1)
        err = MException('CHI:ChiPicture:OutOfRange', ...
            'Requested location is invalid');
        throw(err);
    end            

    output = this.data(xpos,ypos);
end
        
