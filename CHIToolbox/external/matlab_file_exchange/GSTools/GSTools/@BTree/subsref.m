%Binary tree object
%
%function b = subsref(Tree,s)
%
%This function is responsible for correctly handling references to the
%BTree object. It controls the correct syntax, and returns the
%appropriate information. This function is automatically called and
%shouldn't be used by the user of the BTree object.
%
%see also help subsref for more information
%

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

function b = subsref(Tree,s)
About (Tree);

nnargin = nargin;
error(nargchk(2,2,nnargin));   %#ok<ERTAG> %give error if nargin is not appropriate

if isempty(s)
    error('BTree:msg', 'Invalid subscripting');
end

switch s(1).type
    case '.'
        switch s(1).subs
            case 'count'
                b = Tree.count;
            case 'emptyValues'
                b = Tree.emptyValues;
            case 'EmptyValues'
                b = Tree.emptyValues;
            case 'info'
                b = Tree.info;
            otherwise
                error ('BTree:msg', [ s.subs ': Undefined field!' ] );
        end
    otherwise
        error('BTree:msg', 'Undefined subsref')
end

s(1) = [];
if isempty(s)    %nothing other than indexing into main object? just return reduced object
   return;
else
    error ('BTree:msg', 'Referencing is to deep.');
end
