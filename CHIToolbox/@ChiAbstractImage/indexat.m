function idx = indexat(this, xvalue)
% Index corresponding to the x value
% Copyright (c) 2014 Alex Henderson (alex.henderson@manchester.ac.uk)

    [dummy,idx] = min(abs(this.xvals-xvalue)); %#ok<ASGLU>
end
