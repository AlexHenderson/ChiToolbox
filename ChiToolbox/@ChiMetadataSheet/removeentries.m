function obj = removeentries(this,varargin)

% removeentries  Removes one or more entries from this metadata collection
% use 'all' to remove all entries
% accepts, 'all', a vector of entry numbers, a logical mask

    if nargout
        % New output requested so create a clone and call its version of
        % this function
        obj = clone(this);
        obj.removeentries(varargin{:});
    else
        % Is any input provided?
        if isempty(varargin)
            err = MException(['CHI:',mfilename,':InputError'], ...
                'No list of entries provided. If all entries are to be removed, use mymetadata = %s(''all'');',functionname);
            throw(err);
        end
        
        % Did the user specify 'all'?
        argposition = find(cellfun(@(x) strcmpi(x, 'all') , varargin));
        if argposition
            varargin(argposition) = []; %#ok<NASGU>
            list = 1:this.numfiles;
        else
            list = varargin{1};
        end

        if ~isvector(list)
            err = MException(['CHI:',mfilename,':InputError'], ...
                'List of entries should be a vector of spectrum numbers, or ''all''.');
            throw(err);
        end
        
        list = utilities.force2col(list);
        
        if islogical(list)
            templist = transpose(1:this.numfiles);
            list = templist(list);
        else
            if ~isnumeric(list)
                err = MException(['CHI:',mfilename,':InputError'], ...
                    'List of spectra should be a vector of spectrum numbers, a logical mask, or ''all''.');
                throw(err);
            end
        end

        % If we've got to here we can remove the unwanted entries
        
        keeplist = transpose(1:this.numfiles);
        keeplist(list) = [];
        this.filenames = this.filenames(keeplist,:);
        this.acquisitiondate = this.acquisitiondate(keeplist,:);

        % Filters are more complicated
        filternames = fieldnames(this.filter);
        for i = 1:length(filternames)
            name = filternames{i};
            f = this.filter.(name);
            this.filter.(name) = f(keeplist);
        end
        
        if ~isempty(this.classmemberships)
            for i = 1:length(this.classmemberships)
                this.classmemberships{i}.removeentries(list);
            end
        end
        this.history.add(['removed ', num2str(length(list)), ' entries']);
    end

end % function removeentries
