function obj = removespectra(this,varargin)

% removespectra  Removes one or more spectra from this collection
% use 'all' to remove all spectra

    if nargout
        % New output requested so create a clone and call its version of
        % this function
        obj = clone(this);
        obj.removespectra(varargin{:});
    else
        % Is any input provided?
        if isempty(varargin)
            err = MException(['CHI:',mfilename,':InputError'], ...
                'No list of spectra provided. If all spectra are to be removed, use myfile = %s(''all'');',functionname);
            throw(err);
        end
        
        % Did the user specify 'all'?
        argposition = find(cellfun(@(x) strcmpi(x, 'all') , varargin));
        if argposition
            varargin(argposition) = []; %#ok<NASGU>
            list = 1:this.numspectra;
        else
            list = varargin{1};
        end

        if islogical(list)
            % If the list is logical, we can assume everything is in order. 
            list = utilities.force2col(list);
            this.data(list,:) = [];
            if ~isempty(this.classmembership)
                this.classmembership.removeentries(list);
            end
            this.history.add(['removed ', num2str(sum(list)), ' spectra']);
        else
        
            % Did the user provide a list of spectra as a vector?
            if ~isvector(list)
                err = MException(['CHI:',mfilename,':InputError'], ...
                    'List of spectra should be a vector of spectrum numbers, or ''all''.');
                throw(err);
            end

            % Is the vector a list of numbers?
            if ~isnumeric(list)
                err = MException(['CHI:',mfilename,':InputError'], ...
                    'List of spectra should be a vector of spectrum numbers, or ''all''.');
                throw(err);
            end

            % Is the list of numbers simply a list of all numbers?
            if (length(unique(list)) == this.numspectra)
                err = MException(['CHI:',mfilename,':InputError'], ...
                    'If all spectra are to be removed, use myfile = %s(''all'');',functionname);
                throw(err);
            end

            % If we've got to here we can remove the unwanted spectra
            list = utilities.force2col(list);
            this.data(list,:) = [];
            if ~isempty(this.classmembership)
                this.classmembership.removeentries(list);
            end
            this.history.add(['removed ', num2str(length(list)), ' spectra']);
        end        
    end

end
