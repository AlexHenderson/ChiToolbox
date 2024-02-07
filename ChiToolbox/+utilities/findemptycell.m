function col = findemptycell(cellarray,row)
    
% findemptycell  Finds the first empty cell in a cell array.
%
% Syntax
%   col = findemptycell(cellarray,row);
%
% Description
%   col = findemptycell(cellarray,row) finds the position of the first
%   empty cell in the requested row of cellarray. If all cells in teh row
%   are occupied, col is length(cellarray(row) + 1. 
% 
% Copyright (c) 2019, Alex Henderson.
% Licenced under the GNU General Public License (GPL) version 3.
%
% See also 
%   cell isempty.

% Contact email: alex.henderson@manchester.ac.uk
% Licenced under the GNU General Public License (GPL) version 3
% http://www.gnu.org/copyleft/gpl.html
% Other licensing options are available, please contact Alex for details
% If you use this file in your work, please acknowledge the author(s) in
% your publications. 

% The latest version of this file is available at:
% https://github.com/AlexHenderson/ChiToolbox
    
    
    % cellarray is a cell array that contains empty cells
    % We wish to find the first empty cell in a given row

    % Extract the row in question
    cellarray = cellarray(row,:);

    slots = length(cellarray);

    % Handle an empty cell array
    if slots == 0
        col = 1;
        return;
    end

    % Cycle through the avilable cells until we find one that is
    % empty
    for i = 1:slots
        if isempty(cellarray{i})
            col = i;
            return;
        end
    end

    % If we get to here there are no empty slots, so we need to
    % create one
    col = slots + 1;
    
end % function
