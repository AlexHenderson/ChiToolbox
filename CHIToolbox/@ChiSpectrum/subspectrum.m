function out = subspectrum(this,from,to)
% Extract part of the spectrum given a range of xvalues
% Copyright (c) 2014 Alex Henderson (alex.henderson@manchester.ac.uk)

    % Swap if 'from' is higher than 'to'
    [from,to] = ChiForceIncreasing(from,to);
    % Determine the index values of the xvalue limits
    fromidx = this.indexat(from);
    toidx = this.indexat(to);
    this.log = vertcat(this.log,['subspectrum, from:', num2str(from), ' to:', num2str(to)]);            
    out = subspectrumidx(this,fromidx,toidx);
end
