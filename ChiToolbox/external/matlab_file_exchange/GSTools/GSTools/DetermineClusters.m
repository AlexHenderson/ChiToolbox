%function DetermineClusters
%
%This function can be used to determine with leafs belong to the same
%cluster in a dendrogram. Clusters are formed by comparing the distances
%between the leafs and grouping is continued until a certain percentage of
%the maximum distance is found.
%
%Syntax:
%    clusters = DetermineClusters (Z, percent)
%
%Parameters:
%    Z: the Z matrix that results from the function linkage
%    percent: percentage of the maximum distance: clusters are formed below
%        this limit
%    clusters: cell vector that contains the clusters that were found, each
%        leaf lists the different elements that belong to one cluster
%
%See also:
%    GSDendrogram

%This software package is dual licensed. You can use it according to the term
%of either the GPLv3 or the BSD license.
%
%GSTools: a set of MATLAB functions to read, write and work with SPC spectra in MATLAB
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

%Copyright (c) 2005-2009, Kris De Gussem
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


function clusters = DetermineClusters (Z, percent)
if isempty (Z)
    msg = 'Can not determine which items cluster together if the distance matrix is empty.';
    errordlg ('GSTools', msg);
    error ('Biodata:msg', msg);
end
[n,m] = size(Z);
lim = Z(n,m)*percent;

maxcluster = n+1;
nsamples = n+1;
i=0;
while i<size(Z,1)
    i=i+1;
    if Z(i,3) < lim
        %it is a grouping below the limit
        maxcluster = maxcluster + 1;
        Z(i,3) = maxcluster; %just place the cluster number in the last column
    else
        %grouping is higher than the limit: stop grouping
        Z(i:n,:) = [];
    end
end

clusters=cell(0,0);
Added = [];
nr = 0;
while isempty(Z) == false
    nr = nr+1;
    [retval, Z] = seek (Z);
    [retval, Z] = seekback (retval, Z, nsamples);
    clusters{nr,1} = sort(retval,2);
    Added = cat(2, Added, clusters{nr,1});
end

%place the unclustered items in different clusters
% nr = size(clusters,1);
SingleElementClusters = setdiff (1:n+1, Added);
for i = 1:length (SingleElementClusters)
    clusters{nr+i,1} = SingleElementClusters(i);
end

disp ([num2str(size(clusters,1)) ' clusters found:']);
for i=1:size(clusters,1)
    fprintf(1, '\t%i: %s\n', i, num2str(clusters{i}));
end



function [retval, Z] = seek (Z)
retval = Z(1,1:2); %first row: first and second column always indicate a new cluster (values are always below the amount of samples we have)
seek = Z(1,3);     %these two samples are clustered. These have cluster number seek
Z(1,:) = [];       %delete row, we already grouped the samples in this row
[x,y] = find(Z == seek); %have a look for the newly formed cluster
while (isempty(Z) == false) && (isempty(x) == false) %and add this sample number to the cluster if present
    if y == 1
        retval = [retval Z(x,2) ];
    else
        retval = [retval Z(x,1) ];
    end
    seek = Z(x,3); %idem: this is the new cluster number
    Z(x,:)=[];
    [x,y] = find(Z == seek); %and have a look for it
end
%now we have the cluster that was formed in retval and we have the
%remaining samples in Z.


function [retval, Z] = seekback (retval, Z, n)
pos = find (retval > n); %seek for cluster numbers that are greater than the amount of samples we have
while isempty(pos) == false
    seek = retval(1,pos(1));
    retval(:,pos(1)) = []; %it is a row vector!
    x = find(Z(:,3) == seek); %formed cluster numbers are in column three, while the "original samples or original groups/clusters"  are in the first two columns
    if (isempty(Z) == false) && (isempty(x) == false) %we found the sample numbers that belonged to the cluster that was composed before
        retval = [retval Z(x,[1 2]) ]; %add the orginal sample numbers to retval
        Z(x,:) = []; %and delete the row from Z
    else
        disp ('seek:');
        disp (seek);
        disp ('retval:');
        disp (retval);
        disp ('Z:');
        disp (Z);
        error ('GSTools:msg', 'Error in determing which samples cluster together');
    end
    pos = find (retval > n);
end
