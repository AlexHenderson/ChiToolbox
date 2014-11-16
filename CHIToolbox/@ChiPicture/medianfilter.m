function output = medianfilter(this,degree)
% medianfilter Median filter

    % Set a suitable default
    if (~exist('degree','var'))
        degree = 3;
    end

    % Clone this object
    output = clone(this);

    output.data = medfilt2(output.data, [degree,degree]);
    output.log = vertcat(this.log,['medianfilter: degree(', num2str(degree), ')']);
end
