%Binary tree object
%
%function Tree = BTree(X, description)
%
%This function initialises the binary tree. Each element can have a left
%branch (with a lower value, or less important than the element), and a
%right branch which has a higher value, or more important than the
%element). The binary tree is an efficient data-structure for sorting a
%list, obtaining the different values of a list and e.g. the positions of
%the different values. However, although code is implemented to ensure a
%certain degree to obtain a balanced tree, it is yet impossible to obtain a
%fully balanced tree with this implementation.
%
%Parameters:
%   Tree: the created BTree-obect
%   X:  the numeric, cell or string array which needs to be converted in a
%       BTree
%   description: optional string: a description for the data
%
%See also BTree/ConvertToBTree.
%
%Example:
%   sample = num2cell(['A'; 'A'; 'A'; 'B'; 'B'; 'B'; 'C'; 'C'; 'C']);
%   tree = BTree(sample)

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


function Tree = BTree(X, description)

%generate the default structure
Tree = struct ('count', {0}, 'emptyValues', {{}}, 'emptyCount', {0}, 'info', {''}, 'items', {[]});
Tree = class(Tree,'BTree');

%check input + convert it to a BTree-structure
switch nargin
    case 0
        
    case 1
        if isa(X,'BTree')
            Tree = X;
        elseif iscell (X) || isnumeric (X) || ischar (X)
            %convert the array to a BTree
            Tree = ConvertToBTree (Tree, X);
        else
            error ('BTree:msg', ['''' class (X) ''': unsupported data input type. See help BTree for more information.']);
            
        end
        
        Tree.info = '';
    case 2
        %convert the cell array to a binary tree
        if ischar (description)
            Tree.info = description;
        else
            Tree.info = '';
        end
        Tree = ConvertToBTree (Tree, X);
        
    otherwise
        error ('BTree:msg', 'Wrong number of input parameteres');
end
About (Tree);
