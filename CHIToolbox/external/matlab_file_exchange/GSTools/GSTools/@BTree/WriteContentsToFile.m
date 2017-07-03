%Binary tree object
%
%function WriteContentsToFile (Tree, FileName)
%
%This function writes the content of the binary tree to a file.
%
%Input parameters:
%   Tree: the binary tree object
%   FileName: path and filename of the file in which the
%      contents need to be written. If FileName is 1, then output
%      is written to the screen.

%This software package is dual licensed. You can use it according to the term
%of either the GPLv3 or the BSD license.
%
%BTree: a MATLAB class that implements the binary tree data structure
%C 2007-2008, Kris De Gussem, Raman Spectroscopy Research Group, Department
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


function WriteContentsToFile (Tree, FileName)
About (Tree);

switch nargin
    case 1
        File = 1;
        msg='';
    case 2
        [File, msg] = fopen (FileName, 'w+');
    otherwise
       error ('BTree:msg', 'Wrong number of input parameters');
end

if isempty(msg) == false
    disp ('The error returned was:');
    disp (['   ' message]);
    error ('Biodata:msg', 'Could not open file for writing. Please check whether you have access to the destination file.');
end

fprintf (File, '\n');
fprintf (File, '%s = \n', inputname(1));
fprintf (File, '\tBTree object\n');

fprintf (File, '\t\tcontaining %s items\n', int2str(Tree.count));
fprintf (File, '\t\tDescription: %s\n', Tree.info);
fprintf (File, '\n\tList of items in the binary tree:\n\n');
t = GetItems (Tree);
for i=1:length (t)
    fprintf(File, '\tvalue: %s\n', str(t{i}.value));
    fprintf(File, '\tcount: %i\n', t{i}.count);
    fprintf(File, '\tvalue: {');
    tmpstr=[];
    for j=1:t{i}.count
        tmpstr = [ tmpstr ' [' str(t{i}.itemvalues{j}) '] ' ];
    end
    if length(tmpstr) > 50
        fprintf (File, 'string (%i)', length(tmpstr));
    else
        fprintf (File, '%s', tmpstr);
    end
    fprintf(File, '}\n\n');
end
if File ~= 1
    fclose (File);
end
