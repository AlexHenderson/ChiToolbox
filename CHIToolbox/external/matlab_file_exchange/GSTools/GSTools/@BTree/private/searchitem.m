%Binary tree object
%
%private function it = searchitem (list, str, retfullitem)
%
%This function searches for an item str in the tree of items (list). It is
%repeatedly called in an iterative way.
%
%Input parameters:
%   list: list of items in BTree structure
%   str: the item to look for
%   retfullitem: boolean value: true if the full elements structure
%      needs to be returned, false if searchitem returns a boolean value
%      indicating if the element is found
%
%Output parameters:
%   it: the structure of the item which is searched

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


function it = searchitem (list, str, retfullitem)
if isempty (list)
    %the element is not found in the list
    it = [];
    return;
else
    %Is it the element we look for?
    found = DoCompare (str, list.value);
    if found == 0
        if retfullitem
            tmp.value = list.value;
            tmp.count = list.count;
            tmp.itemvalues = list.itemvalues;
            it = tmp;
            return;
        else
            it = 1; %succes
        end
    elseif found < 0
        %look in the left branch
        it = searchitem (list.left, str, retfullitem);
    else
        %look in the right branch
        it = searchitem (list.right, str, retfullitem);
    end
end
