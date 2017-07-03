%Binary tree object
%
%function Tree = ConvertToBTree(Tree, X)
%
%This function will convert a given numeric, cell or string array into a
%BTree. By building the binary tree, the items positions in the original
%list are saved. By doing this, one can easily get the number of different
%elements in the list and positions of these elements. 
%
%Input parameters:
%   Tree: an empty BTree-structure
%   X:  the numeric, cell or string array which needs to be converted in a
%       BTree
%
%Output parameters:
%   Tree: the created BTree-obect
%
%uses: trimstr, MakeVector
%
%Example:
%   sample = num2cell(['A'; 'A'; 'B'; 'B'; 'A'; 'B'; 'C'; 'C'; 'C']);
%   tree = BTree
%   tree = ConvertToBTree (tree, sample)

%This software package is dual licensed. You can use it according to the term
%of either the GPLv3 or the BSD license.
%
%BTree: a MATLAB class that implements the binary tree data structure
%C 2004-2008, Kris De Gussem, Raman Spectroscopy Research Group, Department
%of analytical chemistry, Ghent University
%C2009 Kris De Gussem
%
%This file is part of GSTools.
%
%GSTools is free software: you can redistribute it and/or modify
%it under the terms of the GNU General Public License as published by
%the Free Software Foundation, either version 3 of the License, or
%(at your option) any later version.
%
%GSTools is distributed in the hope that it will be useful,
%but WITHOUT ANY WARRANTY; without even the implied warranty of
%MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
%GNU General Public License for more details.
%
%You should have received a copy of the GNU General Public License
%along with GSTools.  If not, see <http://www.gnu.org/licenses/>.

%Copyright (c) 2004-2009, Kris De Gussem
%All rights reserved.
%
%Redistribution and use in source and binary forms, with or without 
%modification, are permitted provided that the following conditions are 
%met:
%
%    * Redistributions of source code must retain the above copyright 
%      notice, this list of conditions and the following disclaimer.
%    * Redistributions in binary form must reproduce the above copyright 
%      notice, this list of conditions and the following disclaimer in 
%      the documentation and/or other materials provided with the distribution
%    * Neither the name of Raman Spectroscopy Research Group, Department of
%	  analytical chemistry, Ghent University nor the names 
%      of its contributors may be used to endorse or promote products derived 
%      from this software without specific prior written permission.
%      
%THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" 
%AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE 
%IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE 
%ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE 
%LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR 
%CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF 
%SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS 
%INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN 
%CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) 
%ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE 
%POSSIBILITY OF SUCH DAMAGE.


function Tree = ConvertToBTree(Tree, X)
if nargin ~= 2
    error ('BTree:msg', 'Function requires two input parameters');
end

if ischar (X)
    %convert it to a cell array
    %must be done before calling MakeVector: essentially this is a
    %2-dimensional character array
    tmp = cell(size (X,1),1);
    for i = 1:size (X,1)
        tmp{i,1} = X(i,:);
    end
    X = tmp;
    clear tmp;
end

if length (X) < 1
    warning ('BTree:msg', 'No data assigned to BTree object');
    return;
end
X = MakeVector (X, 'Input X must be a vector');

if isnumeric (X)
    %convert to a cell array
    X=num2cell(X(:));
    %for i = 1:length (X)
    %    tmp{i,1} = X(i);
    %end
    %X = tmp;
    %clear tmp;
end

%character and numeric arrays are already converted to cell arrays
if iscell (X) == false
    error ('BTree:msg', 'Input X must be a cell array');
end

%convert cell array to BTree
for i = 1: size (X,1)
    item = X{i};
    if isempty (item)
        Tree.emptyValues {length (Tree.emptyValues)+1} = i;
        Tree.emptyCount = Tree.emptyCount +1;
    else
        if isnumeric (item)
            Tree = Add (Tree, item, i);
        else
            %item = trimstr(item);
            while length (item) >= 1
                if (item (1) == ' ') || (item (1) == 0)
                    item(1) = [];
                else
                    break;
                end
            end
            l = length (item);
            while l >= 1
                if (item (l) == ' ') || (item (l) == 0)
                    item(l) = [];
                else
                    break;
                end
                l = l-1;
            end
            
            Tree = Add (Tree, item, i);
        end
    end
end
