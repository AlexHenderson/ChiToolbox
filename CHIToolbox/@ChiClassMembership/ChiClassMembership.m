classdef ChiClassMembership < handle

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
    end
    
    %% Calculated properties
    properties (Dependent = true)
        uniquelabels;
        numuniquelabels;
        labelids;       % index values of unique labels
        labelcounts;    % how many of each label are there        
    end
    
    %% Methods
    methods
        %% Constructor
        function this = ChiClassMembership(title,varargin)
            
            if (nargin > 0) % Support calling with 0 arguments
                this.title = title;
                if (nargin == 2)
                    % We have a list of class labels, one per instance
                    this.labels = varargin{1};
                    this.labels = ChiForceToColumn(this.labels);
                else
                    % We must have pairs of labels and their number 
                    % Expecting structure like...  'alice',3, 'bob',6, 'charlie',5;
                    % or...              205,3, 192,6, 227,5;
                    
                    % Check we have pairs of values
                    if (rem(nargin-1,2) == 1)
                        err = MException('CHI:ChiClassMembership:IOError', ...
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
        
        %% clone : Make a copy of this image
        function output = clone(this)
            % Make a copy of this image
            output = ChiClassMembership(this.title,this.labels);
        end
        
        %% Determine some properties
        function output = get.uniquelabels(this)
            [output] = unique(this.labels,'stable');
        end
        
        function output = get.numuniquelabels(this)
            [output] = length(this.uniquelabels);
        end
        
        function output = get.labelids(this)
            [dummy,dummy,output] = unique(this.labels,'stable'); %#ok<ASGLU>
        end
        
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
        
    end
end

