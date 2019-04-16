%Binary tree object
%
%function [Items, ItemsList, numlabels] = GetItems(Tree)
%
%This function returns a list of all items in the BTree.
%
%Input parameters:
%   Tree: the current BTree-obect
%
%Output parameters:
%   Items: a structure array containing the different elements, with their
%      itemvalues
%   ItemsList: a array of the elements
%   numlabels: a numeric array, different numbers indicate different
%      class membership of elements (corresponding to the original list; in
%      this case, the position of the element is given as third parameter
%      in the add function of the BTree object. Alternatlively the
%      BTree is build using the ConvertToBTree function.).
%
%See also BTree/add, BTree/ConvertToBTree.
%
%Example:
%   sample = num2cell(['A'; 'A'; 'B'; 'B'; 'A'; 'B'; 'C'; 'C'; 'C']);
%   tree = BTree(sample)
%   Items = GetItems(tree); %obtain the different items
%   for i=1:length(Items)
%       Items{i}
%   end
%   [Items, ItemsList, numlabels] = GetItems(tree); %obtain numerical representation of sample
%   disp(numlabels)

%This software package is dual licensed. You can use it according to the term
%of either the GPLv3 or the BSD license.
%
%BTree: a MATLAB class that implements the binary tree data structure
%C 2004-2008, Kris De Gussem, Raman Spectroscopy Research Group, Department
%of analytical chemistry, Ghent University
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


function [Items, ItemsList, numlabels] = GetItems(Tree)
About (Tree);

Items = GetThem (Tree.items, []);
if isempty (Tree.emptyValues) == false
    ll = length(Items)+1;
    Items{ll}.value = 'NoValue';
    Items{ll}.count = Tree.emptyCount;
    Items{ll}.itemvalues = Tree.emptyValues;
end

if nargout >=2
    ItemsList = cell(length (Items),1);
    for i = 1:length (Items)
        ItemsList{i} = Items{i}.value;
    end
end

%make an equivalent numerical array of itemslist
if nargout >= 3
    total=Count(Tree);
    numlabels = zeros(total.totalitems,1);
    for i = 1:length (Items)
        pos = Items{i}.itemvalues;
        for j=1:length (pos)
            numlabels( pos{j},1) = i;
        end
    end
end
