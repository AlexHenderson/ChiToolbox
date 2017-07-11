function display(this,varargin) %#ok<DISPLAY>
% display Basic display function

% Passing the actual plotting functionality off to a separate function to
% co-locate the feature. 

    utilities.plotspectrum(this,varargin{:});
    
end
