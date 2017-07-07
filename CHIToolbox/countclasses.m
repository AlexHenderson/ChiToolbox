function [names, counts]=countclasses(classlist, possibleClasses)

% function: countclasses
%           Counts the number of entries in each class
% version:  2.0
%
% [names, counts]=countclasses(classlist);
% [names, counts]=countclasses(classlist,possibleClasses);
%
% where:
%   classlist - a collection of numbers or labels that form groups
%   possibleClasses - a list of all possible classes that could appear
%    (optional)
%   names - the names of each unique group, either as numbers or labels
%   counts - the number of each group in classlist
%
% The names list and the counts list are matched, that is, the second entry
% in counts is the number of the second entry in names. 
%
%   Copyright (c) April 2012, Alex Henderson 
%   Contact email: alex.henderson@manchester.ac.uk
%   Licenced under the GNU General Public License (GPL) version 3
%   http://www.gnu.org/copyleft/gpl.html
%   Other licensing options are available, please contact Alex for details
%   If you use this file in your work, please acknowledge the author(s) in
%   your publications. 

%   version 2.0 June 2017, 
%     Changed to count all possible classes, whether or not they actually
%     appear in the given list
%   version 1.0 April 2012, initial release


% If a class is missing it is ignored. Therefore, append all the possible
% classes to the list (thereby guaranteeing a hit) and subtract 1 from the
% answer for each.

if exist('possibleClasses','var')
    classlist = vertcat(classlist, possibleClasses);
end

classlist = sortrows(classlist);

[names, range] = unique(classlist, 'rows', 'first');
[names, range(:,2)] = unique(classlist, 'rows', 'last');

counts = (range(:,2) - range(:,1)) + 1;

if exist('possibleClasses','var')
    % Now remove the extra values added above
    counts = counts - 1;
end
