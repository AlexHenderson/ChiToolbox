function output = medianfilter(this,degree)

% medianfilter Median filter

    % Set a suitable default
    if ~exist('degree','var')
        degree = 3;
    end

    % Clone this object
    output = clone(this);

    output.data = medfilt2(output.data, [degree,degree]);
    output.history.add(['medianfilter: degree(', num2str(degree), ')']);
    this.history.add(['medianfilter: degree(', num2str(degree), ')']);
end
