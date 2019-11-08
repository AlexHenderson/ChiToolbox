function obj = transform(varargin)
    %TRANSFORM Summary of this function goes here

if ~isa(varargin{2},'ChiImageTransform')
    error('Not a transform object');
end


    this = varargin{1};

    if nargout
        obj = this.clone();
        % Not a great approach, but quite generic. 
        % Prevents errors if the function name changes. 
        command = [mfilename, '(obj,varargin{2:end});'];
        eval(command);  
    else

        tform = varargin{2};
        this.data = imtransform(this.data, tform.transform, 'XData',[1, tform.xpixels],'YData',[1, tform.ypixels]); %#ok<DIMTRNS>
        this.xpixels = tform.xpixels;
        this.ypixels = tform.ypixels;
        this.history.add('From an image transform process')
        this.history.add(['Source image: ', this.filenames{1}]);
    end

end % function
