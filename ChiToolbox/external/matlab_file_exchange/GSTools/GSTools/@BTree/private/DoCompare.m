%Binary tree object
%
%function res = DoCompare (item, value)
%
%This function compares two values (either strings or numbers) and returns
%a value indicating if the first value is lower, equal to or higher than
%the second.
%
%Input parameters:
%   item: first value
%   value: value to compare first with
%
%Output parameters:
%   res: if 
%           < 0: item has a lower value than value
%           = 0: item is equal to value
%           > 0: item has a higher value

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

function tmp = DoCompare (item, value)
itn = isnumeric (item);
itc = ischar (item);
van = isnumeric (value);
vac = ischar (value);

if ~(itn || itc)
    error ('BTree:msg', ['Support for this type ('''  class (item) ''')of data needs to be programmed in future ...']);
end

if ~(van || vac)
    error ('BTree:msg', ['Support for this type ('''  class (value) ''')of data needs to be programmed in future ...']);
end

if itn && van
        %tmp = item - value;
    tmp = double(item) - double(value);
    return;
end
if itn
    item = num2str(item);
end
if van
    value = num2str(value);
end

%tmp = mystrcmp (item, value);
if ischar (item) == false
    error ('BTree:msg', 'String 1 is not a string');
end
if ischar (value) == false
    error ('BTree:msg', 'String 2 is not a string');
end

l1 = length (item);
l2 = length (value);
d = l1 - l2;
if d < 0
    value = value(1:l1);
elseif d > 0
    item = item(1:l2);
end

pos = find(item - value); %search for differing characters: this isfaster than find(item ~= value)
if isempty (pos)
    if d < 0
        retval = -1;
    elseif d == 0
        retval = 0;
    else
        retval = 1;
    end
else
    if item (pos(1)) < value (pos(1))
        retval = -1;
    else
        retval = 1;
    end
end
tmp=retval;
