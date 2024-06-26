function [chosen,uniqueNames,chosenClassMasks,counts,originalClassMasks] = undersample(classMembership,requestedMin)

% undersample  Balances class sizes by selecting class members based on the minimum membership
%
% Syntax
%   [chosen,uniqueNames,chosenClassMasks,counts,originalClassMasks] = undersample(classMembership);
%   [chosen,uniqueNames,chosenClassMasks,counts,originalClassMasks] = undersample(classMembership,requestedMin);
%
% Description
%   [chosen,uniqueNames,chosenClassMasks,counts,originalClassMasks] = undersample(classMembership) 
%   determines which class in classMemberhip has the minimum number of
%   occurrences. It then randomly selects this number from each of the
%   larger classes to make the membership count of each class equal.
%
%   [chosen,uniqueNames,chosenClassMasks,counts,originalClassMasks] = undersample(classMembership,requestedMin) 
%   uses requestedMin as the minimum number of members to choose for each
%   class. If the requestedMin is greater than the membership of the
%   minority class, a warning is issued and the requestedMin is ignored. 
% 
%   classMembership: A list with multiple class names
% 
%   chosen: A logical column vector where true values indicate the members
%     of the classMembership that have been selected to form balanced
%     classes.
% 
%   uniqueNames: The unique names of the classes
% 
%   chosenClassMasks: A logical matrix where each row represents a position
%     in classMembership and one column per class in the same order as
%     uniqueNames. True indicates the entry in classMembership is selected.
% 
%   counts: The count of each class in classMembership in the same order as
%     uniqueNames
% 
%   originalClassMasks: The original classMembership expressed in the same
%     manner as chosenClassMasks
% 
% Copyright (c) 2018, Alex Henderson.
% Licenced under the GNU General Public License (GPL) version 3.
%
% See also 
%   datasample, utilities.countclasses.

% Contact email: alex.henderson@manchester.ac.uk
% Licenced under the GNU General Public License (GPL) version 3
% http://www.gnu.org/copyleft/gpl.html
% Other licensing options are available, please contact Alex for details
% If you use this file in your work, please acknowledge the author(s) in
% your publications. 

% Version 3.0, June 2018

% Version 3.0, June 2018
% Allow user to chose minimum number of members. 
% Version 2.0, February 2018
% Added chosen output. This changes the function signature. 
% Version 1.0, January 2018
% Initial release


[uniqueNames,counts,numClasses,ic] = utilities.countclasses(classMembership,'stable');

numValues = size(ic,1);
[minCount,minClassId] = min(counts);

if exist('requestedMin','var')
    if (requestedMin < minCount)
        % We need to undersample all classes
        minCount = requestedMin;
    else
        message = sprintf('Not enough samples in the minority class (%s) to make up the requested number. Using minority class size (%d)',uniqueNames{minClassId},minCount);
        utilities.warningnobacktrace(message);
    end
end
        

originalClassMasks = false(numValues,numClasses);
chosenClassMasks   = false(numValues,numClasses);

for i = 1:numClasses
    originalClassMasks(ic == i, i) = true;
end

spectrumIdx = transpose(1:numValues);

for thisClass = 1:numClasses
    if (counts(thisClass) > minCount)
        % Need to resample this class
        classListIdx = spectrumIdx(originalClassMasks(:,thisClass)); % The index positions in the full spectrum list that correspond to this class
        theChosenOnes = randperm(counts(thisClass),minCount); % Randomly select some of these indexes
        chosenIdx = classListIdx(theChosenOnes); % Identify the position of the chosen spectra in the full list
        tempMask = false(size(spectrumIdx)); % Create a mask of all positions
        tempMask(chosenIdx) = true; % Flag the chosen positions in the full mask 
        chosenClassMasks(:,thisClass) = originalClassMasks(:,thisClass) & tempMask; % Remove the spectra of this class that were not chosen
    else
        % Just select all members of this class
        chosenClassMasks(:,thisClass) = originalClassMasks(:,thisClass);
    end
end

chosen = any(chosenClassMasks,2);
