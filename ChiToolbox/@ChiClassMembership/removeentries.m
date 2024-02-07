function obj = removeentries(this,varargin)

% removeentries  Removes selected entries from the list of class labels. 
%
% Syntax
%   removeentries(list);
%   obj = removeentries(list);
%   [____] = removeentries('all');
%
% Description
%   removeentries(list) removes list items from the class memberships. list
%   can be a vector of logical the same length as the number of existing
%   membership labels, or a vector of label index values. 
% 
%   obj = removeentries(list) clones the object before removing entries. 
%
%   [____] = removeentries('all') removes all entries. 
%
% Copyright (c) 2018-2019, Alex Henderson.
% Licenced under the GNU General Public License (GPL) version 3.
%
% See also 
%   ChiMetadataSheet extractentries

% Contact email: alex.henderson@manchester.ac.uk
% Licenced under the GNU General Public License (GPL) version 3
% http://www.gnu.org/copyleft/gpl.html
% Other licensing options are available, please contact Alex for details
% If you use this file in your work, please acknowledge the author(s) in
% your publications. 

% The latest version of this file is available at:
% https://github.com/AlexHenderson/ChiToolbox


    if nargout
        obj = clone(this);
        command = [mfilename, '(obj,varargin{:});'];
        eval(command);  
    else
        % Do we have any entries to remove?
        if ~(this.numentries)
            return
        end

        % Is any input provided?
        if isempty(varargin)
            err = MException(['CHI:',mfilename,':InputError'], ...
                'No list of entries provided. If all ids are to be removed, use myfile = %s(''all'');',functionname);
            throw(err);
        end

        % Did the user specify 'all'?
        argposition = find(cellfun(@(x) strcmpi(x, 'all') , varargin));
        if argposition
            varargin(argposition) = []; %#ok<NASGU>
            list = 1:this.numentries;
        else
            list = varargin{1};
        end

        if islogical(list)
            if (length(list) ~= this.numentries)
                err = MException(['CHI:',mfilename,':InputError'], ...
                    'List of logical values should equal the number of membership entries.');
                throw(err);
            end                
        else
            % Did the user provide a list of spectra as a vector?
            if isvector(list)
                if (max(list) > this.numentries)
                    err = MException(['CHI:',mfilename,':InputError'], ...
                        'List has entry index number in excess of number of entries.');
                    throw(err);
                end
            else
                % Not sure what we have been given, so throw an error
                err = MException(['CHI:',mfilename,':InputError'], ...
                    'List of entries should be a vector of numbers, logicals, or ''all''.');
                throw(err);
            end
        end

        % If we've got to here we can remove the unwanted spectra
        list = utilities.force2col(list);
        this.labels(list,:) = [];
        this.history.add(['removed ', num2str(length(list)), ' entries']);
    end

end
