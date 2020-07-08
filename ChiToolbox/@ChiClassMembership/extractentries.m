function obj = extractentries(this,varargin)

% extractentries  Extracts selected entries from the list of class labels. 
%
% Syntax
%   extractentries(list);
%   obj = extractentries(list);
%
% Description
%   extractentries(list) extracts list items from the class memberships.
%   list is a vector of label index values. Note that the entries remain in
%   the order they appeared in the source, regardless of the list order. 
% 
%   obj = extractentries(list) clones the object before extracting entries. 
%
% Copyright (c) 2020, Alex Henderson.
% Licenced under the GNU General Public License (GPL) version 3.
%
% See also 
%   ChiMetadataSheet removeentries

% Contact email: alex.henderson@manchester.ac.uk
% Licenced under the GNU General Public License (GPL) version 3
% http://www.gnu.org/copyleft/gpl.html
% Other licensing options are available, please contact Alex for details
% If you use this file in your work, please acknowledge the author(s) in
% your publications. 

% The latest version of this file is available on Bitbucket
% https://bitbucket.org/AlexHenderson/chitoolbox


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
                'No list of entries provided.');
            throw(err);
        end

        list = varargin{1};

        % Did the user provide a list of spectra as a vector?
        if isvector(list)
            if (max(list) > this.numentries)
                err = MException(['CHI:',mfilename,':InputError'], ...
                    ['List contains one or more index numbers in excess of number of entries (', utilities.tostring(this.numentries), ')']);
                throw(err);
            end
            if (min(list) < 1)
                err = MException(['CHI:',mfilename,':InputError'], ...
                    ['List must be values between 1 and the number of entries (', utilities.tostring(this.numentries), ')']);
                throw(err);
            end
        else
            % Not sure what we have been given, so throw an error
            err = MException(['CHI:',mfilename,':InputError'], ...
                'List of entries should be a vector of numbers.');
            throw(err);
        end

        % If we've got to here we can remove the unwanted spectra
        list = utilities.force2col(list);

        idx = 1:this.numentries;
        idx(list) = [];
        
        this.labels(idx,:) = [];
        this.history.add(['extracted ', utilities.tostring(length(list)), ' entries']);
    end

end
