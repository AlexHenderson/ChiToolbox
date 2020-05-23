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
%   Copyright (c) 2017-2019, Alex Henderson 
%   Contact email: alex.henderson@manchester.ac.uk
%   Licenced under the GNU General Public License (GPL) version 3
%   http://www.gnu.org/copyleft/gpl.html
%   Other licensing options are available, please contact Alex for details
%   If you use this file in your work, please acknowledge the author(s) in
%   your publications. 
%
% Version 1.0 June 2017

    properties
        title@char;             % Name of this ClassMembership
        labels;                 % Class labels of each instance
        history = ChiLogger();  % Log of data processing steps
    end
    
    %% Calculated properties
    properties (Dependent = true)
        uniquelabels;   % Names of the unique labels
        numuniquelabels;% Number of unique class labels
        labelids;       % Index values of unique class labels in the same order as uniquelabels
        labelcounts;    % Number of instances of each class label
        numentries;     % Number of instances (should be the same as the number of spectra)
        numclasses;     % Number of unique classes
    end
    
    %% Methods
    methods
        % ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
        %% Constructor
        function this = ChiClassMembership(title,varargin)
            
            argposition = find(cellfun(@(x) isa(x,'ChiLogger') , varargin));
            if argposition
                this.history = varargin{argposition}.clone;
                varargin(argposition) = []; 
            else
                this.history = ChiLogger();
            end
            
            if (nargin > 0) % Support calling with 0 arguments
                this.title = title;
                if (nargin == 2)
                    % We have a list of class labels, one per instance
                    if ischar(varargin{1})
                        this.labels = char(varargin{1});
                    else
                        this.labels = varargin{1};
                    end
                    try
                        this.labels = utilities.force2col(this.labels);
                    catch ex
                        disp(['Error processing: ', title])
                        rethrow(ex);
                    end
                    
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
        function labelat = labelat(this,idx)
        % Returns the label at a given index position
            if iscell(this.labels)
                labelat = this.labels{idx};
            else
                labelat = this.labels(idx);
            end
        end
        
        % ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
        function uniquelabelat = uniquelabelat(this,idx)
        % Returns the unique label at a given index position
            if iscell(this.labels)
                uniquelabelat = this.uniquelabels{idx};
            else
                uniquelabelat = this.uniquelabels(idx);
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
            
            if iscellstr(this.labels)
                this.labels = lower(strtrim(this.labels));
            end
            
            [names,counts] = utilities.countclasses(this.labels,'stable'); %#ok<ASGLU>
            output = counts;            
        end
        
        % ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
        function output = get.numentries(this)
            [output] = length(this.labels);
        end
        
        % ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
        function numclasses = get.numclasses(this)
            numclasses = this.numuniquelabels;
        end
        
        % ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
        
    end
end

