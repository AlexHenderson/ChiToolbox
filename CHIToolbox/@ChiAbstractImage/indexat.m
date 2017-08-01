function idx = indexat(this, xvalue)
% Index corresponding to the x value
% Copyright (c) 2014 Alex Henderson (alex.henderson@manchester.ac.uk)

    if (numel(xvalue) > 1)
        idx = zeros(size(xvalue));
        for i = 1:length(xvalue)
            [dummy,idx(i)] = min(abs(this.xvals - xvalue(i))); %#ok<ASGLU>
        end
    else
        [dummy,idx] = min(abs(this.xvals - xvalue)); %#ok<ASGLU>
    end
    
end
