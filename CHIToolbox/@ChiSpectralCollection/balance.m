function [obj] = balance(this,varargin)

% balance classes
% default is to undersample

if isempty(this.classmembership)
    err = MException(['CHI:',mfilename,':IOError'], ...
        'No class membership avilable');
    throw(err);
end

% Check whether we're creating a new balanced object, or balancing in situ
if nargout
    obj = this.clone();
    obj.history.add('Created from a clone')
    eval(['obj.',mfilename]);
else
    % Balance this object
    
    % Look for a valid method. A bit of overkill at the moment, but this
    % will probably expand to other methods
    
    balancingMethod = 'undersample';
    
    if nargin
        argposition = find(cellfun(@(x) strcmpi(x, 'undersample') , varargin));
        if argposition
            balancingMethod = 'undersample';
        end
    end

    switch balancingMethod
        case 'undersample'
            chosen = utilities.undersample(this.classmembership.labels);
            this.classmembership.labels = this.classmembership.labels(chosen,:);
            this.data = this.data(chosen,:);
            this.classmembership.history.add('undersampled')
            this.history.add('undersampled')
        otherwise
            err = MException(['CHI:',mfilename,':IOError'], ...
                ['Balancing method ''',varargin{argposition},''' not understood.']);
            throw(err);
    end            
    
end
