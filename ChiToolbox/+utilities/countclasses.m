function [names,counts,numClasses,ic] = countclasses(classlist,varargin)

% function: countclasses
%           Counts the number of entries in each class
% version:  3.0
%
% [names,counts,numClasses,ic] = countclasses(classlist);
% [names,counts,numClasses,ic] = countclasses(classlist,possibleClasses);
% [names,counts,numClasses,ic] = countclasses(____,setOrder);
%
% where:
%   classlist - a collection of numbers or labels that form groups
%   possibleClasses - (optional) a list of all possible classes that could
%    appear. If stable sorting is selected these classes appear at the end
%    of the output lists
%   setOrder - (optional) either 'sorted' (default) to return a sorted list
%    of the classes and their counts, or 'stable' to retain the original
%    order of the classes
%   names - the name of each unique group. If stable sorting is selected,
%    any possibleClasses will appear at the names list
%   counts - the number of each group in classlist
%   numClasses - the number of unique classes
%   ic - index to names. The locations of each of the unique names in the
%   original classlist
%
% The names list and the counts list are matched, that is, the second
% entry in counts is the number of the second entry in names.
%
%   Copyright (c) 2012-2018, Alex Henderson 
%   Contact email: alex.henderson@manchester.ac.uk
%   Licenced under the GNU General Public License (GPL) version 3
%   http://www.gnu.org/copyleft/gpl.html
%   Other licensing options are available, please contact Alex for details
%   If you use this file in your work, please acknowledge the author(s) in
%   your publications. 

%   version 3.0 January 2018, 
%     Added stable sorting and added count of unique classes
%   version 2.0 June 2017, 
%     Changed to count all possible classes, whether or not they actually
%     appear in the given list
%   version 1.0 April 2012, initial release

%% sorted or stable?
argposition = find(cellfun(@(x) strcmpi(x, 'stable') , varargin));
if argposition
    % Remove the parameter from the argument list
    varargin(argposition) = [];
    stable = true;
else
    stable = false;
end

if ~isempty(varargin)
    possibleClasses = varargin{1};
end

% If a class is missing it is ignored. Therefore, append all the possible
% classes to the list (thereby guaranteeing a hit) and subtract 1 from the
% answer for each.

if exist('possibleClasses','var')
    classlist = vertcat(classlist, possibleClasses);
end

% If we're sorting cells we get a warning from unique. Suppress this warning. 
warningid = 'MATLAB:UNIQUE:RowsFlagIgnored'; % 'rows' flag ignored for cellstrs.
warning('off',warningid);

if stable
    % Grab the stably sorted list of names before the class list is sorted
    [namesStable,ia,icStable] = unique(classlist, 'rows', 'stable'); %#ok<ASGLU>
end

% Sort the rows to enable efficient counting
classlist = sortrows(classlist);

% Find the first and last occurrences of each class
[namesSorted, range] = unique(classlist, 'rows', 'first'); %#ok<ASGLU>
[namesSorted, range(:,2), icSorted] = unique(classlist, 'rows', 'last');

% Determine the distance between the first and last occurrences
countsSorted = (range(:,2) - range(:,1)) + 1;

% Now remove the extra values added above
if exist('possibleClasses','var')
    countsSorted = countsSorted - 1;
end

if stable
    % Re-order the counts to match the unsorted order
    [sortedStableNames,unused,order] = unique(namesStable,'rows'); %#ok<ASGLU>
    countsStable = countsSorted(order);
end

% Reinstate the warning
warning('on',warningid);

numClasses = size(namesSorted,1);

if stable
    names = namesStable;
    counts = countsStable;
    ic = icStable;
else
    names = namesSorted;
    counts = countsSorted;
    ic = icSorted;
end
