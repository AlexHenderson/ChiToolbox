function plot(this,varargin)
% Basic plot function
% Copyright (c) 2014 Alex Henderson (alex.henderson@manchester.ac.uk)

% Passing the actual plot functionality off to a separate function to
% co-locate the style across multiple classes. 

    utilities.plotspectrum(this,varargin{:});    

end
