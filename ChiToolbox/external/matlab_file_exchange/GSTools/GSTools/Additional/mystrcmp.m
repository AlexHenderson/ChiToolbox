%function retval = mystrcmp (str1, str2)
%
%Mystrcmp will compare two strings in the same way as the standard
%c-functions do. In contrary to the MATLAB function, it will return a value
%of -1 of the first string has a 'lower value' than the second string, and
%+1 if the first string has a 'higher value'.
%The first different character will determine retval. In case the two
%strings have different lengths and only the longer part of the string is
%the difference, then this will determine retvals value.
%
%See also help strcmp
%
%Example:
%   mystrcmp ('abc', 'abC')
%   mystrcmp ('abc', 'abc')
%   mystrcmp ('abC', 'abc')

%This software package is dual licensed. You can use it according to the term
%of either the GPLv3 or the BSD license.
%
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

function retval = mystrcmp (str1, str2)
if ischar (str1) == false
    error ('BTree:msg', 'String 1 is not a string');
end
if ischar (str2) == false
    error ('BTree:msg', 'String 2 is not a string');
end

l1 = length (str1);
l2 = length (str2);
d = l1 - l2;
if d < 0
    str2 = str2(1:l1);
elseif d > 0
    str1 = str1(1:l2);
end

pos = find(str1 - str2); %search for differing characters: this isfaster than find(str1 ~= str2)
if isempty (pos)
    if d < 0
        retval = -1;
    elseif d == 0
        retval = 0;
    else
        retval = 1;
    end
else
    if str1 (pos(1)) < str2 (pos(1))
        retval = -1;
    else
        retval = 1;
    end
end
