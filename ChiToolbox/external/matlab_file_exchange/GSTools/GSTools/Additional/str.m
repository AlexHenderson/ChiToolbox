%function str
%
%This function formats the input value as a string, regarding the type.
%Currently supported input values are logicals, doubles, chars and cells.
%It outputs the converted value.
%
%syntax:
%     s = str (value, domatrixconversion, format, ntokens)
%     s = str (value)
%
%With:
%     value: a single logical, double string or cell value
%     domatrixconversion: if true: arrays are converted to cellstring arrays
%     s: the value (or cell array of values) converted into a string
%
%Example:
%   str (4.561)
%   str ('abc')

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


function s = str (value, domatrixconversion, format, ntokens, just)
switch nargin
    case 1
        if isvector(value) && isnumeric(value)
            s = num2str(value);
            return
        else
            domatrixconversion = false;
            format = [];
            ntokens = [];
            just = [];
        end
    case 2
        format = [];
        ntokens = [];
        just = [];
    case 3
        ntokens = [];
        just = [];
    case 4
        just = [];
    case 5
    otherwise
        error ('GSTools:msg', 'Wrong number of input parameters.');
end

if ischar (value)
    s = value;
    if isempty(ntokens) == false
        s = CatBlank(s,ntokens);
        if isempty(just) == false
            s = strjust(s,just);
        end
    end
    return;
end

if (domatrixconversion == true) && (numel(value) > 1)
    le1 = size (value,1);
    le2 = size (value,2);
    s = cell(le1,le2); %preallocation of array
    for i = 1:le1
        for j = 1:le2
            if iscell(value(i,j))
                tmp = str (value{i,j}, domatrixconversion, format, ntokens, just);
                if iscell (tmp)%in essence is length of vector is higher than 1, it is a cell array, otherwise a char array
                    s{i,j} = cat(2, tmp{:});
                else
                    s{i,j} = tmp;
                end
            else
                s{i,j} = str (value(i,j), domatrixconversion, format, ntokens, just);
            end
        end
    end
else
    if isempty(value)
        s = '';
    else
        value = value(1,1);
        switch class(value)
            case 'logical'
                s = int2str (value);
            case 'double'
                if isempty(format)
                    s = num2str (value(1,1));
                else
                    s = num2str (value(1,1), format);
                end
            case 'cell'
                s = str (value{1,1});
            otherwise
                error ('GSTools:msg', 'Unknown data type for conversion to string. Please contact the programmer of the Biodata object.');
        end
    end
    if isempty(ntokens) == false
        s = CatBlank(s,ntokens);
    end
    if isempty(just) == false
        s = strjust(s,just);
    end
end
