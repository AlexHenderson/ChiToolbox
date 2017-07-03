%function GSimportspec
%
%GSimportspec imports all spc-files in a folder. All files are collected in
%a single structure array containing all spectra with all spectral information.
%
%Syntax:
%    [spectra, path] = GSimportspec (path, compatibility);
%    [spectra, path] = GSimportspec (path);
%
%With:
%    path: optional string: name of map which contains the spectra
%    compatibility: optional (default -1): numerical value: if:
%       0: function is compatible with PLS-toolbox output
%       1: a Biodata object
%       -1 (default value) or anything else: standard GSSpcRead output
%    spectra: structure array: spectra with all spectral information: if
%       input parameter compatibility was
%          0:
%             name: file name
%             data: vector of spectral values (renamed from spectrum!!!)
%             xaxis: vector of xaxis-values
%             auditlog: log of file
%          -1:
%             each structure has standard GSSpcRead format
%
%Example:
%    spectra = GSimportspec ('c:\testset\', 0);
%    spectra2 = cat (1, spectra.data); %convert to data matrix
%    plot (spectra(1).xaxis, spectra2);

%This software package is dual licensed. You can use it according to the term
%of either the GPLv3 or the BSD license.
%
%GSTools: a set of MATLAB functions to read, write and work with SPC spectra in MATLAB
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


function [spectra, path] = GSImportspec (path, compatibility)
init_directory = pwd; % zoekt huidige directory

%check given path or ask if not given or incorrect
switch nargin
    case 0
        path = [];
        compatibility = -1;
    case 1
        compatibility = -1;
    case 2
    otherwise
end

if exist (path, 'file') == 7
else
    path = [];
end

if isempty (path)
    [filedata, path] = uigetfile('*.spc', 'Select an spc-file in the folder to be imported'); %#ok<ASGLU>
    if path == 0
        error ('GSTools:msg', 'User didn''t select a directory...');
    end
    clear filedata;
end

%go to map with spectra
cd(path);
spcfiles = dir('*.spc');

nrfiles= size(spcfiles, 1);
h_importspec = waitbar(0,'Importing spectra ...');

%load spectra
switch compatibility
    case 0
        spectra(nrfiles) = struct ('name', '', 'data', [], 'xaxis', [], 'auditlog', []);
        for i = 1:nrfiles
            spectra(i).name = spcfiles(i).name;
            [spectra(i).data, spectra(i).xaxis, spectra(i).auditlog] = GSSpcRead (spcfiles(i).name, compatibility, 0);
            waitbar(i/nrfiles, h_importspec, 'Importing spectra ...');
        end
        
    case 1
        Name = cell(nrfiles,1);
        date = cell(nrfiles,1);
        time = cell(nrfiles,1);
        xtype = cell(nrfiles,1);
        ytype = cell(nrfiles,1);
        Resolution = cell(nrfiles,1);
        Technique = cell(nrfiles,1);
        InstrumentSource = cell(nrfiles,1);
        Comment = cell(nrfiles,1);
        %data = [];
        i=1;
        while i <= nrfiles
            spectrum = GSSpcRead (spcfiles(i).name, -1, 0);
            waitbar(i/nrfiles, h_importspec, 'Importing spectra...');
            
            if i==1
                data = zeros (nrfiles, size (spectrum.data,2));
                xaxis = spectrum.xaxis;
            end
            
            Name{i} = spectrum.Name;
            %date{i} = [ num2str(spectrum.date(1), '%02d') '/' num2str(spectrum.date(2), '%02d') '/' num2str(spectrum.date(3)) ];
            date{i} = [ num2str(spectrum.date(3)) num2str(spectrum.date(2), '%02d') num2str(spectrum.date(1), '%02d') ];
            time{i} = [ num2str(spectrum.date(4), '%02d') ':' num2str(spectrum.date(5), '%02d') ];
            
            %check for x-xaxis: length and values different?
            isOK = false; %#ok<NASGU>
            if length (xaxis) ~= length (spectrum.xaxis)
                if i==2
                    Btn = questdlg ('Spectra have axes of different length. Probably this is because your first spectrum is calibrated with another xaxis. Do you want to remove the first spectrum from the dataset?', 'Import of spectra', 'yes', 'no', 'no');
                    switch Btn
                        case 'yes'
                            i = 1;
                            Name(i) = [];
                            date(i) = [];
                            time(i) = [];
                            xtype(i) = [];
                            ytype(i) = [];
                            Resolution(i) = [];
                            Technique(i) = [];
                            InstrumentSource(i) = [];
                            Comment(i) = [];
                            spcfiles(i) = [];
                            nrfiles = nrfiles - 1;
                data = zeros (nrfiles, size (spectrum.data,2));
                xaxis = spectrum.xaxis;
                            isOK = true;
                        otherwise
                            error ('GSTools:msg', 'Spectra have x-axes of different length');
                    end
                else
                    error ('GSTools:msg', 'Spectra have x-axes of different length');
                end
            else
                isOK = true;
            end
            if isOK
                if sum (xaxis ~= spectrum.xaxis) > 0
                    error ('GSTools:msg', 'Different axes');
                end
                
                data(i,:) = spectrum.data;
                xtype{i} = spectrum.xtype;
                ytype{i} = spectrum.ytype;
                Technique{i} = spectrum.Technique;
                Resolution{i} = spectrum.Resolution;
                InstrumentSource{i} = spectrum.InstrumentSource;
                Comment{i} = spectrum.Comment;
            end
            i=i+1;
        end
        spectra = Biodata (data);
        spectra = SetUpdating(spectra, true);
        spectra = AddClassdes (spectra, 'Filename', Name);
        spectra = AddClassdes (spectra, 'Date', date);
        spectra = AddClassdes (spectra, 'Time', time);
        spectra = AddClassdes (spectra, 'XType', deblank(xtype));
        spectra = AddClassdes (spectra, 'YType', deblank(ytype));
        spectra = AddClassdes (spectra, 'Technique', deblank(Technique));
        spectra = AddClassdes (spectra, 'Resolution', deblank(Resolution));
        spectra = AddClassdes (spectra, 'InstrumentSource', deblank(InstrumentSource));
        spectra = AddClassdes (spectra, 'Comment', deblank(Comment));
        if IsClassDes(spectra, 'nr')
            spectra = DeleteClassdes (spectra, 'nr');
        end
        
%         Btn = questdlg ('Do you want to add extra spectral descriptions from a csv-text database?', 'SPE import of spectra', 'yes', 'no', 'no');
%         switch Btn
%             case 'yes'
%                 [txtfile, txtpath] = uigetfile('*.csv', 'Select the txt-database');
%                 csvinfo = loadcell ([txtpath txtfile], ';', '"', 'single-string');
%                 ll = size (csvinfo,2)-1;
%                 specdes = cell (nrfiles,ll);
%                 for i = 1:nrfiles
%                     ThisName = spefiles(i).name;
%                     for j = 1:ll
%                         specdes {i,j} = LocateItem (ThisName, csvinfo, j+1);
%                     end
%                 end
%                 %Add spectral descriptions
%                 for i = 1:ll
%                     spectra = AddClassdes (spectra, csvinfo{1,i+1}, specdes (:,i));
%                 end
%             case 'no'
%             otherwise
%                 error 'unknown button';
%         end
        
        spectra.PlotOptions.useSampleNumbers = 0;
        spectra.xaxis = xaxis;
        spectra.xlabel = xtype{1};
        spectra = SetUpdating(spectra, false);
    otherwise
        spectra = GSSpcReadStructure;
        spectra(nrfiles).Name = ''; %preallocation of structure array
        for i = 1:nrfiles
            spectra(i) = GSSpcRead (spcfiles(i).name, -1, 0);
            waitbar(i/nrfiles, h_importspec, 'Importing spectra...');
        end
end
close(h_importspec);
cd(init_directory); % go back to initial directory

GSToolsAbout
