function obj = select(this,varargin)

% select  Selects specfic spectra based on various criteria. 
%
% Syntax
%   select(list);
%   select('first', num);
%   select('last', num);
%   select('random', num);
%   newcollection = select(____);
%
% Description
%   select(list) where list is a logical vector, retains the spectra where
%   list is true. If list is a vector of numbers, the spectra at these
%   index values are retained. 
%
%   select('first', num) retains only the first num spectra. 
% 
%   select('last', num) retains only the last num spectra. 
%
%   select('random', num) retains num spectra, selected randomly.
%
%   newcollection = select(____) first create a clone of the collection and
%   selects the requested spectra from that. The original collection is
%   untouched. 
% 
% Notes
%   If only a single spectrum is retained, newcollection is still a
%   ChiSpectralCollection. To convert it to a ChiSpectrum use:
%     spectrum = collection.spectrumat(1);    
%
% Copyright (c) 2019, Alex Henderson.
% Licenced under the GNU General Public License (GPL) version 3.
%
% See also 
%   randperm ChiSpectralCollection ChiSpectrum.

% Contact email: alex.henderson@manchester.ac.uk
% Licenced under the GNU General Public License (GPL) version 3
% http://www.gnu.org/copyleft/gpl.html
% Other licensing options are available, please contact Alex for details
% If you use this file in your work, please acknowledge the author(s) in
% your publications. 

% Version 1.0, April 2019
% The latest version of this file is available on Bitbucket
% https://bitbucket.org/AlexHenderson/chitoolbox


    if nargout
        % New output requested so create a clone and call its version of
        % this function
        obj = clone(this);
        obj.select(varargin{:});
    else
        % Is any input provided?
        if isempty(varargin)
            err = MException(['CHI:',mfilename,':InputError'], ...
                'No information was provided on what should be selected.');
            throw(err);
        end
        
        %% How would the user like to apply their selection
        first = false;
        last = false;
        random = false;
        
        % Did the user specify 'first'?
        argposition = find(cellfun(@(x) strcmpi(x, 'first') , varargin));
        if argposition
            first = true;
            varargin(argposition) = [];
        end

        % Did the user specify 'last'?
        argposition = find(cellfun(@(x) strcmpi(x, 'last') , varargin));
        if argposition
            last = true;
            varargin(argposition) = [];
        end

        % Did the user specify 'random'?
        argposition = find(cellfun(@(x) strcmpi(x, 'random') , varargin));
        if argposition
            random = true;
            varargin(argposition) = [];
        end
        
        if (sum([first, last, random]) > 1)
            err = MException(['CHI:',mfilename,':InputError'], ...
                'Only one of ''first'', ''last'' or ''random'' can be selected.');
            throw(err);
        end
        
        
        %% Which spectra should be selected

        % Did the user provide a logical array?
        argposition = find(cellfun(@(x) islogical(x) , varargin));
        if argposition
            selection = ChiForceToColumn(varargin{argposition});
            if (length(selection) ~= this.numspectra)
                err = MException(['CHI:',mfilename,':InputError'], ...
                    'The selected list does not match the number of spectra.');
                throw(err);
            else
                this.data = this.data(selection,:);
                this.history.add(['selected ', num2str(sum(selection)), ' spectra']);
                if any([first,last,random])
                    utilities.warningnobacktrace('Additional restrictions (first|last|random) ignored.');
                end
                return
            end
        end
        
        % Did the user specify a single value?
        % Need to check for scalar before vector since a single value is
        % also a vector
        argposition = find(cellfun(@(x) isscalar(x) , varargin));
        if argposition
            num = varargin{argposition};
            if (num > this.numspectra)
                err = MException(['CHI:',mfilename,':InputError'], ...
                    'The number of spectra selected is larger than the number available.');
                throw(err);
            end                
            
            if first
                this.data = this.data(1:num,:);
                this.history.add(['selected first ', num2str(num), ' spectra']);
                return
            else
                if last
                    this.data = this.data(this.numspectra - num + 1:end,:);
                    this.history.add(['selected last ', num2str(num), ' spectra']);
                    return
                else
                    if random
                        selection = randperm(this.numspectra,num);
                        this.data = this.data(selection,:);
                        this.history.add(['randomly selected ', num2str(num), ' spectra']);
                        return
                    end
                end
            end
        end
                
            
        % Did the user specify a list of spectral index values?
        argposition = find(cellfun(@(x) isvector(x) , varargin));
        if argposition
            selection = varargin{argposition};
            if (length(selection) > this.numspectra)
                err = MException(['CHI:',mfilename,':InputError'], ...
                    'The number of spectra selected is larger than the number available.');
                throw(err);
            end                
            if (max(selection) > this.numspectra)
                err = MException(['CHI:',mfilename,':InputError'], ...
                    'One or more selected spectra are outside the range of possible values.');
                throw(err);
            end               
            
            this.data = this.data(selection,:);
            this.history.add(['selected ', num2str(selection), ' spectra']);
            if any([first,last,random])
                utilities.warningnobacktrace('Additional restrictions (first|last|random) ignored.');
            end
            return
        end
        
        %% We shouldn't get to here
        err = MException(['CHI:',mfilename,':InputError'], ...
            'An error occurred. Please check the help information for this function.');
        throw(err);


    end

end
