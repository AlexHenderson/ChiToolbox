% function LocateItem
%
% This function Locates an Item in a list or table. LocateItem returns the
% value in the nth column. This function is especially useful for use with
% conversion tables or lookup tables. As such it is very usable in e.g.
% import routines where coded and cryptic filenames need to be converted in
% useful sample descriptions.
%
% Syntax:
%    it = LocateItem (str, list, nrcol)
%
% Input parameters:
%    str: string containing the item to search for
%    list: list of cell strings, first column containing the list items,
%       while the following columns can contain additional info, new
%       values for the old values in the first column, ...
%    nrcol: the number of the column (or field) which will be returned
%
% Output parameters:
%    it: the value in the nrcol'th column corresponding to str
%

%This software package is dual licensed. You can use it according to the term
%of either the GPLv3 or the BSD license.
%
%C 2005-2008, Kris De Gussem, Raman Spectroscopy Research Group, Department
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

function [it, i] = LocateItem (str, list, nrcol)
str = trimstr(str);
OK = false;
for i = 1:size (list,1)
    listit = list{i,1};
    if isnumeric(str)
        if listit == str
            OK = true;
            break
        end
    else
        if strcmp (listit, str)
            OK = true;
            break
        end
    end
end
if OK %this is for speed optimisation
    it = list{i,nrcol};
else
    it = []; %in case str is not found
end



% if ~OK
%     if isnumeric(str)
%         str=num2str(str);
%     else
%         str = str2num(str);
%     end
%     if isempty(str)==false
%         [it, i] = LocateItem (str, list, nrcol);
%     end
% else
%     %this is for speed optimisation
%     it = list{i,nrcol};
% end