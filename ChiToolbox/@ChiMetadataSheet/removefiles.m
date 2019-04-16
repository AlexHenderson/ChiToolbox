function obj = removefiles(varargin)

% removefiles  Removes all references to specific entries in these metadata
%
% Syntax
%   removefiles(toremove);
%   obj = removefiles(toremove);
%
% Description
%   removefiles(toremove) removes the entries specified in toremove from
%   this metadata collection. toremove can be a vector of logicals, or
%   index positions.
%
%   obj = removefiles(toremove) creates a clone of the metadata and applies
%   the changes to that version. The original metadata are not modified.
% 
% Copyright (c) 2019, Alex Henderson.
% Licenced under the GNU General Public License (GPL) version 3.
%
% See also 
%   ChiMetadataSheet ChiClassMembership.

% Contact email: alex.henderson@manchester.ac.uk
% Licenced under the GNU General Public License (GPL) version 3
% http://www.gnu.org/copyleft/gpl.html
% Other licensing options are available, please contact Alex for details
% If you use this file in your work, please acknowledge the author(s) in
% your publications. 

% Version 1.0, February 2019
% The latest version of this file is available on Bitbucket
% https://bitbucket.org/AlexHenderson/chitoolbox


this = varargin{1};

if (nargin ~= 2)
    err = MException(['CHI:',mfilename,':InputError'], ...
        'The parameter ''toremove'' is required.');
    throw(err);
end

toremove = varargin{2};

if (length(toremove) ~= this.numfiles)
    err = MException(['CHI:',mfilename,':InputError'], ...
        'The parameter ''toremove'' should be the same length as the number of files in this metadata sheet.');
    throw(err);
end

if ~(islogical(toremove) || isnumeric(toremove))
    err = MException(['CHI:',mfilename,':InputError'], ...
        'toremove must be an array of logicals, or index values.');
    throw(err);
end

% OK to proceed
    if nargout
        % New output requested so create a clone and call its version of
        % this function
        obj = clone(this);
        command = [mfilename, '(obj,varargin{2:end});'];
        eval(command);  
    else
        this.filenames(toremove) = [];
        this.acquisitiondate(toremove) = [];

        f = fields(this.filter);
        c = struct2cell(this.filter);
        for i = 1:length(c)
            c{i}(toremove) = [];
        end
        this.filter = cell2struct(c,f,1);

        for i = 1:length(this.classmemberships)
            this.classmemberships{i}.labels(toremove) = [];
        end

        entries = 1:length(toremove);
        entries = entries(toremove);
        entries = num2str(entries);

        this.history.add(['Removed files: ', entries]);
        
    end

end % function
