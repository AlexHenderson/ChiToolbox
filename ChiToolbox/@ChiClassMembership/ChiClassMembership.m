classdef ChiClassMembership < ChiBase

% ChiClassMembership Creates a class membership list for categorical variables
%
% Usage:
%   classes = ChiClassMembership(title,listofclassmemberships);
%   classes = ChiClassMembership(title,label1,count1,label2,count2,...);
%
% Where:
%   title: name of this class membership list
%   listofclassmemberships: numeric list or cell array of strings where
%   each entry is an indicator of class membership
%   label(n), counts(n): names and counts of these names are given in
%   pairs. label can be numeric or character strings and need not be of a
%   the same length (use cells). The label/count pairs should reflect the
%   structure of the data set they will be used to describe.
%
% Examples:
%       classes = ChiClassMembership('listing', [4,2,7,6,2,7,3,5,5,4]);
%       classes = ChiClassMembership('people', 'alice',3, 'bob',6, 'charlie',5);
%       classes = ChiClassMembership('id_numbers', 205,3, 192,6, 227,5);
%
%   Copyright (c) 2017, Alex Henderson 
%   Contact email: alex.henderson@manchester.ac.uk
%   Licenced under the GNU General Public License (GPL) version 3
%   http://www.gnu.org/copyleft/gpl.html
%   Other licensing options are available, please contact Alex for details
%   If you use this file in your work, please acknowledge the author(s) in
%   your publications. 
%
% Version 1.0 June 2017

    properties
        title@char;
        labels;
        history
    end
    
    %% Calculated properties
    properties (Dependent = true)
        uniquelabels;
        numuniquelabels;
        labelids;       % index values of unique labels
        labelcounts;    % how many of each label are there        
        numentries;
    end
    
    %% Methods
    methods
        % ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
        %% Constructor
        function this = ChiClassMembership(title,varargin)
            
            this.history = ChiLogger();
            
            if (nargin > 0) % Support calling with 0 arguments
                this.title = title;
                if (nargin == 2)
                    % We have a list of class labels, one per instance
                    if ischar(varargin{1})
                        this.labels = char(varargin{1});
                    else
                        this.labels = varargin{1};
                    end
                    this.labels = ChiForceToColumn(this.labels);
                    
                    if islogical(this.labels)
                        % Replace the logical values with a pseudo-logical
                        % list of the titles and 'not' titles. 
                        notTitle = ['(not) ', this.title];
                        tempLabels = cell(this.numentries,1);
                        tempLabels(this.labels) = {title};
                        tempLabels(~this.labels) = {notTitle};
                        this.labels = tempLabels;
                    end
                    
                else
                    % We must have pairs of labels and their number 
                    % Expecting structure like...  'alice',3, 'bob',6, 'charlie',5;
                    % or...              205,3, 192,6, 227,5;
                    
                    % Check we have pairs of values
                    if (rem(nargin-1,2) == 1)
                        err = MException(['CHI:',mfilename,':IOError'], ...
                            'Class labels and membership counts must be in pairs');
                        throw(err);
                    end
                    
                    classes = reshape(varargin,2,[]);
                    classes = classes';

                    numclasses = size(classes,1);
                    numlabels = sum(cell2mat(classes(:,2)));

                    this.labels = cell(numlabels,1);
                    start = 1;
                    for i = 1:numclasses
                        % If the class label is a number, 
                        % convert it to a string
                        label = num2str(classes{i,1});
                        % How many of this label are there?
                        count = classes{i,2};
                        
                        % Generate a list of this class label
                        entries = repmat(label,count,1);
                        cells = cellstr(entries);
                        
                        % Place these labels into the master list
                        stop = start + count - 1;
                        this.labels(start:stop) = cells;
                        start = stop + 1;
                    end
                end
            end        
        end 
        
        % ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
        %% Determine some properties
        function output = get.uniquelabels(this)
            [output] = unique(this.labels,'stable');
        end
        
        % ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
        function output = get.numuniquelabels(this)
            [output] = length(this.uniquelabels);
        end
        
        % ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
        function output = get.labelids(this)
            [dummy,dummy,output] = unique(this.labels,'stable'); %#ok<ASGLU>
        end
        
        % ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
        function output = get.labelcounts(this)
            % Wish to keep the classes in the order they are supplied by
            % the user. However, in order to easily count the classes we
            % need to sort them. Therefore count the sorted classes and map
            % these back to the unsorted list of unique classes. 

            % Convert all labels to lowercase and remove leading and trailing whitespace
            if ~isnumeric(this.labels)
                tidylabels = lower(strtrim(this.labels));
            else
                tidylabels = this.labels;
            end
            
            % Generate a list of unique labels in the order originally
            % supplied
            [uniquestablesortedlabels] = unique(tidylabels, 'rows','stable');

            % Sort the labels
            [sortedlabels] = sortrows(tidylabels);

            % Find the first and last entry locations
            [uniquesortedlabels, labelrangefirst] = unique(sortedlabels, 'rows', 'first'); %#ok<ASGLU>
            [uniquesortedlabels, labelrangelast] = unique(sortedlabels, 'rows', 'last');

            % Count how many occurences of each label there are
            sortedcounts = (labelrangelast - labelrangefirst) + 1;

            % Map the counts to the original label order
            output = zeros(length(sortedcounts),1);
            for i = 1:length(sortedcounts)
                if ~isnumeric(this.labels)
                    output(i) = sortedcounts(strcmp(uniquesortedlabels,uniquestablesortedlabels{i}));
                else
                    output(i) = sortedcounts(uniquesortedlabels == uniquestablesortedlabels(i));
                end
            end
            
        end
        
        % ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
        function output = get.numentries(this)
            [output] = length(this.labels);
        end
        
        % ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
        function obj = removeentries(this,varargin)
            if nargout
                % New output requested so create a clone and call its version of
                % this function
                obj = clone(this);
                obj.removeids(varargin{:});
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

                % Did the user provide a list of spectra as a vector?
                if ~isvector(list)
                    err = MException(['CHI:',mfilename,':InputError'], ...
                        'List of entries should be a vector of numbers, or ''all''.');
                    throw(err);
                end

                % Is the vector a list of numbers?
                if ~isnumeric(list)
                    err = MException(['CHI:',mfilename,':InputError'], ...
                        'List of entries should be a vector of numbers, or ''all''.');
                    throw(err);
                end

                % Is the list of numbers simply a list of all numbers?
                if (length(unique(list)) == this.numentries)
                    err = MException(['CHI:',mfilename,':InputError'], ...
                        'If all entries are to be removed, use myfile = %s(''all'');',functionname);
                    throw(err);
                end

                % Is the list of numbers simply a list of all numbers?
                if (length(unique(list)) > this.numentries)
                    err = MException(['CHI:',mfilename,':InputError'], ...
                        'If all entries are to be removed, use myfile = %s(''all'');',functionname);
                    throw(err);
                end
                
                % If we've got to here we can remove the unwanted spectra
                list = ChiForceToColumn(list);
                this.labels(list,:) = [];
                this.history.add(['removed ', num2str(length(list)), ' entries']);
            end
            
        end
        
        
    end
end

