%function GSdendrogram
%
%GSdendrogram builds a dendrogram using the statistical toolbox's
%dendrogram function. However, in case of spectral numbers, labels
%are used to indicate different groups of samples. There is a new labelling
%method as well, in which coloured bars below the dendrogram are plot,
%indicating different groups of spectra, as well as the amount of spectra
%in the different groups.
%
%Syntax:
%    Info = GSDendrogram (Z, Labels, Colors, NewLabellingMethod)
%
%With:
%    Z: The Z-matrix as normal input for dendrogram (see help dendrogram)
%    Labels: Labels of the different spectra
%    Colors: a optional colour matrix, indicating the individual colours
%        for the different sample groups
%    Info: a matrix containing dendrogram info about the spectra
%    NewLabellingMethod: boolean: optional: use coloured bars compared to
%        labels in indicate the difference between samples corresponding
%        with the leafs
%
%Example:
%        (with X a data matrix of spectra)
%    Y = pdist(X,'euclidean'); %calculate euclidean distances
%    Z = linkage(Y,'ward'); %use Ward's clustering
%    cophenet(Z,Y) %FYI: cophenet value
%    Info = GSDendrogram (Z, SampleNames); %plot the dendrogram
%    h = title ('Spectra: Ward''s clustering method using Euclidean distance');
%    set (h, 'FontWeight', 'bold')
%    set (h, 'FontSize', 14)

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


function Info = GSDendrogram (Z, Labels, colors, NewLabellingMethod)
switch nargin
    case 2
        colors = [];
    case 3
    case 4
    otherwise
        error ('GSTools:msg', 'Wrong number of input parameters...');
end

if nargin < 4
    NewLabellingMethod = questdlg ('New labelling method?', 'GSDendrogram', 'Yes', 'No', 'Yes');
end
switch NewLabellingMethod
    case 0
    case 1
    case 'Yes'
        NewLabellingMethod = 1;
    case 'No'
        NewLabellingMethod = 0;
    otherwise
        error ('GSTools:msg', 'No option selected');
end

if isnumeric(Labels)
    Labels = str(Labels(:),1);
end

%figure;
[H, T] = dendrogram(Z); %#ok<ASGLU>
clear H;
xlabel ('samples');
ylabel ('distance');
set (gcf, 'PaperOrientation', 'portrait');
set (gcf, 'PaperPositionMode', 'auto');
set (gcf, 'Paperposition', [0 0 20.984 29.6774])

%if a RGB colour matrix isn't given: make one with a sufficient amount of
%colours
if isempty (colors)
    if NewLabellingMethod
        colors = [0 0 0; 0 0.5 0; 1 0 0; 0 0.75 0.75; 0.75 0 0.75; 0.75 0.75 0; 0.25 0.25 0.25];
        %black blue, green, red, lila, orange, darkgrey
        colors = [colors; 1 0 1; 1 1 0 ];
        %magenta, yellow, black
        colors = [colors; [151 176 133]./255 ; [253 251 144]./255;];
        %chartreuse, Light Yellow
        colors = [colors; [163 177 7]./255];  %PANTONE 383 CV
        colors = [colors; [189 135 135]./255];   %PANTONE 5005 CV
        colors = [colors; [249 142 152]./255]; %PANTONE 708 CV
        colors = [colors; [0 102 204]./255]; %RGB R0G102B204
        colors = [colors; [255 153 0]./255]; %RGB R255G153B0
    else
        colors = [0 0 0; 1 0 0; 0 0 1; 1 1 0; 1 0 1; 0.5 0.5 0.5]; % ; 0.75 0 0.750 0.5 0.5];0 1 0; 
        %     colors = [colors; [151 176 133]./255 ; ];
        %     %chartreuse, Light Yellow
        colors = [colors; [163 177 7]./255];  %PANTONE 383 CV
        colors = [colors; [189 135 135]./255];   %PANTONE 5005 CV
        colors = [colors; [249 142 152]./255]; %PANTONE 708 CV
        colors = [colors; [0 102 204]./255]; %RGB R0G102B204
        colors = [colors; [255 153 0]./255]; %RGB R255G153B0
    end
end

% do the real job: add correct sample labels 
Ax = get(gca); % get all properties of plot
nrs = Ax.XTickLabel; %get numbers of spectra
nrs = str2num(nrs); %#ok<ST2NM>

leafs = cell(max(T),2);
for i=1:max(T)
    leafs{i,1} = i;
    leafs{i,2} = Labels(T==i)';
end
Labels2 = cell(length(nrs),1);
for i=1:length (nrs) %generate new labels list
    Labels2(i,1) = leafs{nrs(i),2}(1,1);
end

%show labels
TheLabel = get(Ax.XLabel, 'String');
legend (TheLabel, 0); %show x-axis-label as legend
set(Ax.XLabel, 'Visible', 'off');
Unit = get(gca, 'Units'); %so distance between dendrogram and labels is always the same
set(gca, 'Units', 'pixels');
Pos = get(gca, 'Position');

set(gca, 'XTickLabel', '');

partx = Pos(1,3) / (length (nrs)+1); %distance of labels
if NewLabellingMethod == false
    g = zeros(1,length(nrs));
    for i=1:length (nrs) %normally max. 30
        g(i) = text (i*partx, -5, Labels2(i,1), 'Rotation', 90, 'HorizontalAlignment', 'right', 'Units', 'Pixels');
    end
end

%generate a matrix with Info about clusters
Info = cell(length (nrs),3); %preallocate cell array for Info matrix
Info (:,1) = num2cell(nrs);
Info (:,2) = Labels2;
if NewLabellingMethod
    Info (:,3) = leafs(nrs,2);
    tree = BTree (Labels); %because originally the 30 leafs may not show all different values
else
    Info (:,3) = GetComb (leafs(nrs,2), false)';
    tree = BTree (Labels2);
end

%colour the labels or place small coloured bars
items = GetItems (tree);
ColorIndex = 0;
LabTable = cell (length (items),2);
ShowWarning=0; %if we do not do it this way: we obtain wrong plots
for i = 1:length (items)
    ColorIndex = ColorIndex + 1;
    if ColorIndex > size (colors, 1)
        ShowWarning=1;
        ColorIndex = 1;
    end
    p = cat(1, items{i}.itemvalues{:});
    if NewLabellingMethod
        LabTable {i, 1} = items{i}.value;
        LabTable {i, 2} = colors(ColorIndex,:);
    else
        set (g(p), 'Color', colors(ColorIndex,:));
    end
end

clear p ColorIndex items

%Show the info matrix on the screen
if NewLabellingMethod
    g = zeros(size(Z,1)+1,1);
    ind = 1;
    for i=1:length (nrs)
        ThisItems = Info {i,3};
        for j=1:length(ThisItems)
            itemstr = ThisItems{j};
            if isempty (itemstr)
                co = LocateItem ('NoValue', LabTable, 2);
            else
                co = LocateItem (itemstr, LabTable, 2);
            end
            g(ind) = text (i*partx, j*-5, '-', 'FontWeight', 'Bold', 'Fontsize', 30, 'Units', 'Pixels', 'color', co);
            ind = ind+1;
        end
        
    end
    clear co ind 
    
    set(gca, 'XTick', []);
    Pos = get(gca, 'Position');
    xl = Pos(1)+10; %to the right of gca
    yl = Pos(4)-10; %beginning at top of gca
    
    si = size(LabTable,1);
    leghandle1 = zeros(1,si);
    leghandle2 = zeros(1,si);
    for i = 1:si
        leghandle1(i) = text (xl, yl, '-', 'FontWeight', 'Bold', 'Fontsize', 30, 'Units', 'Pixels', 'color', LabTable {i, 2});
        leghandle2(i) = text (xl+15, yl, str(LabTable {i, 1}), 'Units', 'Pixels', 'color', LabTable {i, 2});
        yl = yl-12;
    end
    clear si x1 y1 Pos
    
    set (leghandle1, 'Units', Unit);
    set (leghandle2, 'Units', Unit);
    clear leghandle1 leghandle2
end

clear partx


disp(' ');
disp ('Dendrogram Info Matrix:');
si = size (Info,1);
space = repmat(' ', si, 4);
s3 = cell(si,1);
ma = zeros(si,1);
for i=1:si
    s2{i} = str(Info(i,2));
    ma(i) = length(s2{i});
    s3(i) = GetComb (Info(i,3),false);
end
ma = max(5,max(ma));%minimum 5, because the column name is 'Label'
s1 = str2(Info(:,1),4, [], 'right');
s2 = str2(Info(:,2),ma, [], 'right');

disp ([ 'Leaf    ' strjust(CatBlank('Label',ma),'right') '    Leaf items']);
disp ([s1 space s2 space str2(s3,100) ]);
clear s1 s2 s3 space si ma

%set units to correct initial state
set(gca, 'Units', Unit);
set(g, 'Units', Unit);
set(gcf, 'Units', Unit);

if ShowWarning
    warndlg ('More items than available colors.');
end

GSToolsAbout
