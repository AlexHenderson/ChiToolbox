function [Specdata, varargout] = GSSpcRead (filename, compatibility, plotspec, YScaling, VerboseOutput)
%GSSpcRead v0.4.3
%
%This function will import a spectrum in the spc-file format into the
%MATLAB-environment. The universal design of the spc-file format permits
%the use of spectra from different spectroscopic sources containing a wide
%range of spectra and information.
%
%Syntax:
%    Specdata = GSSpcRead (filename, compatibility, plotspec, YScaling, VerboseOutput)
%
%Input parameters:
%    - filename: the filename of the spectrum in the spc-format, path
%       included
%    - compatibility: (optional) a numerical parameter used for
%       compatibility with other functions (own and commercial ones)
%       - if not given or -1: no compatibility, leave output as it is
%       - if 0: maintains compatibility with the PLS toolbox' spcreadr
%       function. The data are returned in an array: using the
%       outputparameters: [data,xaxis,auditlog] with:
%          - data: one matrix containing all spectra
%          - xaxis: the axis to which the spectra in the spc-file
%          correspond
%          - auditlog: log of the file (ordinary text in an array)
%    - plotspec: (optional, default = true): boolean: indicates whether the
%       spectrum has to be plot when it is loaded
%    - YScaling: (optional) headers in some SPC-files are not consistent,
%       which results in improper Y-scaling. If scaling is incorrect, you
%       can tell GSSpcRead which exponent to use: if YScaling is:
%           'fexp': File exponent (exponent in SPC-header) is used
%           'subexp': sub-file exponent (exponent in sub-header) is used
%       Only use this parameter in case of problems. This parameter may be
%       removed in a future version, so if used, use it with care.
%    - VerboseOutput: (optional: default 0) boolean: indicates whether
%       detailed information needs to be printed in the command window: 
%       if 0: only error messages are given
%
%Output paramters:
%    - Specdata: structure containing the spectrum/spectra in the spc-file,
%         including spectra info, spectrometer info, date-time, ...
%
%
%GSSpcRead outputs the spectra and all their information contained
%in the spc-file in a structure specdata with the following fields:
%   - date: numeric array with 
%       .date (1) = Day
%       .date (2) = Month
%       .date (3) = Year
%       .date (4) = Hour
%       .date (5) = Minute
%   - xtype: type of x-data (cfr. unit of x-axis)
%   - ytype: type of y-data (cfr. unit of y-axis)
%   - ztype: type of z-data (cfr. unit of z-axis)
%   - Technique: contains instrumental technique if stored in the spc-file
%   - Resolution: contains resolution if stored in the spc-file
%   - InstrumentSource: contains instrumental name if stored in the spc-file
%   - data: is empty when the spc-file contains multiple spectra, but it
%     contains the spectrum if the spc-file only contains one spectrum (as
%     is mostly the case)
%   - xaxis: values of the xaxis
%   - spectra: structure array: is empty when the spc-file contains one
%     spectrum, but it has length n (where n is number of spectra in
%     spc-file) when the spc-file contains more than one spectrum. The
%     structure array has the followqing fields:
%       - data: the spectrum itself
%       - xaxis: the xaxis
%   - log: structure: containing log-information stored in the spc-file
%
%Example:
%   SData = GSSpcRead ('c:\test.spc'); %Read the spectrum
%   plot (SData.xaxis, SData.data); %plot the spectrum
%   h = title (Sdata.Name);
%   set (h, 'FontWeight', 'bold');
%   set (h, 'FontSize', 16);
%   xlabel (SData.xtype);
%   ylabel (SData.ytype);
%   SData.log.txt   %show spectral info
%
%Technical data about the SPC-fileformat is freely available and obtained
%from Galactic Industries Corp: see gspc_udf.pdf available at:
%    https://ftirsearch.com/features/converters/SPCFileFormat.htm
%
%GSSpcRead needs the function trimstr.
%
%GSSpcRead is published under the GPLv3 license. 
%
%GSTools: a set of MATLAB functions to read, write and work with SPC spectra in MATLAB
%
%C 2004-2008, Kris De Gussem, Raman Spectroscopy Research Group, Department
%of analytical chemistry, Ghent University
%
%Thanks to Adrian Mariano of the MITRE Corporation for testing and bug reports.

%History:
%   v0.1:
%      - initial release
%   v0.2:
%      - now correctly interpretes flags in SPC-header, which previously
%      lead to negative peaks, ...
%   v0.3:
%      - now supports the old SPC-file format
%      - fixed bug in reading of the exponents for the Y-value scaling
%      - fixed bug in the Y-value scaling
%      - fixed small bug in the reading process of axis' labels using the
%        SPC-header's fcatxt field
%   v0.3.1:
%      - GetAxisTypes is moved to a separate file and is renamed to
%        GetsTypes
%   v0.4:
%      - support for multi-file spc-spectra
%      - if the spc-files contain only one spectrum, then the xaxis and
%        spectrum are found in spectrum.xaxis and spectrum.data, in
%        contrary to spectrum.spectra(1).xaxis and spectrum.spectra(1).data
%   v0.4.1:
%      - minor bugfixes
%   v0.4.2:
%      - minor update

%This software package is dual licensed. You can use it according to the term
%of either the GPLv3 or the BSD license.
%
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

%check input
switch nargin
    case 1
        compatibility = -1;
        plotspec = true;
        VerboseOutput = false;
        YScaling = [];
    case 2
        plotspec = true;
        VerboseOutput = false;
        YScaling = [];
    case 3
        VerboseOutput = false;
        YScaling = [];
    case 4
        VerboseOutput = false;
    case 5
    otherwise
        error ('GSTools:msg', 'Wrong number of input parameters. See help GSSpcRead.');
end

switch compatibility
    case -1
        %no compatibility issues: leave data as it is
    case 0
        %output as a data matrix
    otherwise
        error ('GSTools:msg', 'Unknown compatibility method, check input. See help GSSpcRead for more information...');
end

if iscellstr(filename)
    filename = filename{1};
end
if ischar (filename) == false
    error ('GSTools:msg', 'GSSpcRead requires a string containing the spectral filename...');
end
if exist (filename, 'file') == 2
    %it's OK
else
    error ('GSTools:msg', [ 'The spc-spectrum ' filename ' does not exist...' ]);
end


%now the input parameters should be OK, start with the real work...

%open the spc-file
[f,msg] = fopen(filename,'rb','l');
if f==-1
   disp(msg);
   disp(filename);
   error('GSTools:msg', 'Error opening file');
end
clear msg;

%read the spc-header of the spectrum
ThisSpcHdr = ReadSpcHeader (f);


%check of the files' contents and the flags about its content
if ThisSpcHdr.ftflgs.TCGRAM
    %Enables fexper in older software (not used)
    warning ('GSTools:msg', 'Flag TCGRAM is set in the spc-file. Normally not used.');
end

if ThisSpcHdr.ftflgs.TMULTI
    %Multifile data format (more than one subfile)
    if ThisSpcHdr.fnsub <= 1
        warning ('GSTools:msg', 'Multifile flag is set. But SPC-file does not contain multiple spectra.');
    end
end

Specdata = GSSpcReadStructure;

Specdata.Name = filename;

%set date / time
Specdata.date (1) = ThisSpcHdr.fdate.Day;
Specdata.date (2) = ThisSpcHdr.fdate.Month;
Specdata.date (3) = ThisSpcHdr.fdate.Year;
Specdata.date (4) = ThisSpcHdr.fdate.Hour;
Specdata.date (5) = ThisSpcHdr.fdate.Minute;

% type of all axis'
if ThisSpcHdr.ftflgs.TALABS
    %Axis label text stored in fcatxt separated by nulls. Ignore fxtype,
    %fytype, fztype corresponding to non-null text in fcatxt.
    Specdata.xtype = ThisSpcHdr.fcatxt.Xlabel;
    Specdata.ytype = ThisSpcHdr.fcatxt.Ylabel;
    Specdata.ztype = ThisSpcHdr.fcatxt.Zlabel;
else
    Types = GetSPCAxisTypes;
    Specdata.xtype = LocateItem (num2str(ThisSpcHdr.fxtype), Types.X, 2);
    Specdata.ytype = LocateItem (num2str(ThisSpcHdr.fytype), Types.Y, 2);
    if ThisSpcHdr.ftflgs.TMULTI
        Specdata.ztype = LocateItem (num2str(ThisSpcHdr.fztype), Types.X, 2);
    end
    clear Types;
end

Techniques = GetTechniques;
Specdata.Technique = LocateItem (num2str(ThisSpcHdr.fexper), Techniques, 2);
clear Techniques;
Specdata.TechniqueNr = ThisSpcHdr.fexper;
Specdata.Resolution = trimstr(ThisSpcHdr.fres);
Specdata.InstrumentSource = trimstr(ThisSpcHdr.fsource);
Specdata.Program = ThisSpcHdr.fmethod;
Specdata.Comment = deblank(ThisSpcHdr.fcmnt);
Specdata.Injection = ThisSpcHdr.fsampin;
Specdata.ConcentrationFactor = ThisSpcHdr.ffactor;

%determine the x-axis if evenly spaced, if unevenly spaced: xaxis will be
%loaded along with the spectrum
range=1:ThisSpcHdr.fnpts; %spectral channels recorded: normally as many spectral channels are recorded as is the length of the x-axis
xaxis = [];
if ThisSpcHdr.ftflgs.TXVALS == false
    %Evenly spaced X-data: the most common form of spc-files.
    %It is typically used to store data for a single spectrum or
    %chromatogram where the X axis data point spacing is evenly
    %throughout the data array.
    
    %calculate the xaxis
    xstep = (ThisSpcHdr.flast-ThisSpcHdr.ffirst) / (ThisSpcHdr.fnpts-1);
    xaxis = ThisSpcHdr.ffirst : xstep : ThisSpcHdr.flast;
%     if ThisSpcHdr.fnpts ~= length (xaxis)
%         warning ('GSTools:msg', 'number of spectral channels recorded, is not the same as those stored in the spc-file. Please check data....');
%     end
    clear xstep;
else
    % Non-evenly spaced X data. File has X value array preceding Y data block(s).
    if ThisSpcHdr.ftflgs.TMULTI && ThisSpcHdr.ftflgs.TXYXYS
    else
        xaxis = fread(f,ThisSpcHdr.fnpts,'float32');
        xaxis = xaxis(:)';
    end
end

Specdata.data = [];
Specdata.xaxis = xaxis; %store x-axis


%read the spectra
if ThisSpcHdr.fnsub > 1
    %Read sub header of the current spectrum
    ThisSubHeader = ReadSubHeader(f);
    Specdata.spectra(1).zvalue = ThisSubHeader.subtime; %to store the first value
    
    %ThisSpcHdr.ftflgs.TXYXYS = tmp(2); % Each subfile has unique X array; can only be used if TXVALS is also used. Used exclusively to flag as MS data for drawing as “sticks” rather than connected lines.
    %ThisSpcHdr.ftflgs.TXVALS = tmp(1); % Non-evenly spaced X data. File has X value array preceding Y data block(s).

    if ThisSpcHdr.ftflgs.TXVALS == 0
        %multifile evenly spaced X values
        for i=1:ThisSpcHdr.fnsub
            if i > 1
                ThisSubHeader = ReadSubHeader(f);
            end
            Specdata = FillInSubHeaderInformation (Specdata, i, ThisSpcHdr, ThisSubHeader);
            spectrum = ReadOneSpectrum (f, ThisSpcHdr, ThisSubHeader, YScaling, range, nargin, VerboseOutput);
            Specdata.spectra(i).xaxis = xaxis;
            Specdata.spectra(i).data = spectrum(:)';
        end
    elseif (ThisSpcHdr.ftflgs.TXVALS == 1) && (ThisSpcHdr.ftflgs.TXYXYS == 0)
        %multifile unevenly spaced X values, common X array
        for i=1:ThisSpcHdr.fnsub
            if i > 1
                ThisSubHeader = ReadSubHeader(f);
            end
            Specdata = FillInSubHeaderInformation (Specdata, i, ThisSpcHdr, ThisSubHeader);
            spectrum = ReadOneSpectrum (f, ThisSpcHdr, ThisSubHeader, YScaling, range, nargin, VerboseOutput);
            Specdata.spectra(i).xaxis = xaxis;
            Specdata.spectra(i).data = spectrum(:)';
        end
    else
        %multifile unevenly spaced X values, unique X array for each
        %subfile
        for i=1:ThisSpcHdr.fnsub
            if i > 1
                ThisSubHeader = ReadSubHeader(f);
            end
            xaxis = fread(f,ThisSubHeader.subnpts,'float32');
            Specdata = FillInSubHeaderInformation (Specdata, i, ThisSpcHdr, ThisSubHeader);
            spectrum = ReadOneSpectrum (f, ThisSpcHdr, ThisSubHeader, YScaling, range, nargin, VerboseOutput);
            Specdata.spectra(i).xaxis = xaxis;
            Specdata.spectra(i).data = spectrum(:)';
            
        end
    end    
    
else
    %only one spectrum in the spc-file
    %Read sub header of the current spectrum
    ThisSubHeader = ReadSubHeader(f);
    %Specdata = ReadOneSpectrum (f, ThisSpcHdr, ThisSubHeader);
    spectrum = ReadOneSpectrum (f, ThisSpcHdr, ThisSubHeader, YScaling, range, nargin, VerboseOutput);
    Specdata.data = spectrum(:)';
    
%    clear CurrSpec;
%    Specdata.spectra(1).xaxis = xaxis;
    
    %plot the spectrum
    if plotspec
        DoPlotSpectrum (Specdata, filename);
    end
end

%read logs if necessary
%predefine structure
Specdata.log.bin = [];
Specdata.log.txt = [];
if ThisSpcHdr.flogoff
    %if not NULL: then there's a log
    %Flogoff: File Offset to LOGSTC Structure
    ThisLogstcHdr = ReadLogstcHeader (f);
    
    logsize = ThisLogstcHdr.logsizd - 64;  % size of logstc header is 64 bytes
    %logbegin = ThisLogstcHdr.logtxto - 64; % Byte offset to Log Text data: where to begin to read
    logbinsize = ThisLogstcHdr.logbins;    % Byte size of log binary block
    logdisksize = ThisLogstcHdr.logdsks;   % Byte size of log disk block
    logtxtsize = logsize-logbinsize-logdisksize;
    %log block:
    %1) logstc header
    %2) binary block: logbinsize: information of program which saved the
    %spc-file
    Specdata.log.bin = fread(f,logbinsize,'uint8');
        
    %3) disk block: don't read
    fread(f,logdisksize,'uint8');
    Specdata.log.txt = fread(f,logtxtsize ,'char');
    Specdata.log.txt = char (Specdata.log.txt');
    rem = Specdata.log.txt;
    tmpstruct = [];
    while (~isempty(rem))
        [line, rem] = strtok (rem, 13); %#ok<STTOK>   -> textscan does not work in all versions of MATLAB
        %strip \r and \r characters
        [S, F, T] = regexp (line, '[\n\r]*([^\n\r]*)[\n\r]*'); %#ok<ASGLU>
        if (~isempty(T{1}))
            line = line(T{1}(1,1):T{1}(1,2));
            
            p = strfind (line, '=');
            if (isempty(p)) % try to look for :
                p = strfind (line, ':');
            end
            try
                a = line (1:p(1)-1);
                b = line (p(1)+1:length(line));
                eval (['tmpstruct.' a ' = ''' b ''';']);
            catch
            end
        end
    end
    Specdata.log.txtInterpreted = tmpstruct;
end

%close spc-file and exit
fclose (f);
GSToolsAbout

%do compatibility: make sure this routine is compatible with other
%(own and commercial) functions
switch compatibility
    case -1
        %do nothing
        
    case 0
        %PLS toolbox spcreadr compatibility: data array output
        %outputparameters: [data,xaxis,auditlog]
        clear data;
        if isfield(Specdata, 'spectra') %we have a multi-spectra spc-file
            l = length (Specdata.spectra);
            data = zeros (l,Specdata.spectra(1).data); %preallocation for speed
            for i = 1:l
                data(i,:) = Specdata.spectra(i).data;
            end
        else
            data = Specdata.data;
        end
        
        %possible bug if multiple spectra and different axis'
        if (ThisSpcHdr.ftflgs.TMULTI == 1) && (ThisSpcHdr.ftflgs.TXVALS == 1) && (ThisSpcHdr.ftflgs.TXYXYS == 1)
            error ('GSTools:msg', 'x-axis is different for each spectrum: can not keep the matrices compatible with PLS toolbox''s spcreadr...');
        end
        xaxis = Specdata.xaxis;
        auditlog = Specdata.log.txt;
        
        Specdata = data;
        varargout {1} = xaxis;
        varargout {2} = auditlog;
        
    otherwise
        beep;
        warning ('GSTools:msg', 'incompatible value for compatibility parameter');
        
end


function ThisSpcHdr = ReadSpcHeader (f)
%This subfunction will load an spc-header in the spc-file.
%f is the file-pointer to the spc-file.
%

%lines with a space at the beginning are implemented in the main-code
tmp = fread(f,8,'ubit1'); %BYTE: flags about type of spc-file (see main-function): single-spectrum, multi-spectrum, nr. of bits for an integer, ...
ThisSpcHdr.ftflgs.TSPREC = tmp(1); %Y data blocks are 16 bit integer (only if fexp is NOT 0x80h)
ThisSpcHdr.ftflgs.TCGRAM = tmp(2); %Enables fexper in older software (not used)
ThisSpcHdr.ftflgs.TMULTI = tmp(3); %Multifile data format (more than one subfile)
ThisSpcHdr.ftflgs.TRANDM = tmp(4); %If TMULTI and TRANDM then Z values in SUBHDR structures are in random order (not used)
ThisSpcHdr.ftflgs.TORDRD = tmp(5); %If TMULTI and TORDRD then Z values are in ascending or descending ordered but not evenly spaced. Z values readv from individual SUBHDR structures.
ThisSpcHdr.ftflgs.TALABS = tmp(6); %Axis label text stored in fcatxt separated by nulls. Ignore fxtype, fytype, fztype corresponding to non-null text in fcatxt.
ThisSpcHdr.ftflgs.TXYXYS = tmp(7); % Each subfile has unique X array; can only be used if TXVALS is also used. Used exclusively to flag as MS data for drawing as “sticks” rather than connected lines.
ThisSpcHdr.ftflgs.TXVALS = tmp(8); % Non-evenly spaced X data. File has X value array preceding Y data block(s).

%The file version parameter can have different values:
%   0x4dh or 77: for the old SPC-file format
%   0x4ch or 76: for the new SPC-file format, that allows for a different
%                   word order
%   0x4bh or 75: for the new SPC-file format

ThisSpcHdr.fversn = fread(f,1,'uchar');    %BYTE: version of the spc file: currently two versions exists, only the newer is supported
switch ThisSpcHdr.fversn
    case 77%% Old version of the file
        ThisSpcHdr.fexper = 0;
        ThisSpcHdr.fexp = fread(f,1,'int16');
        ThisSpcHdr.fnpts = fread(f,1,'float');
        ThisSpcHdr.ffirst = fread(f,1,'float');
        ThisSpcHdr.flast = fread(f,1,'float');
        ThisSpcHdr.fxtype = fread(f,1,'uint8');
        ThisSpcHdr.fytype = fread(f,1,'uint8');
        ThisSpcHdr.fdate.Year = fread(f,1,'uint16');
        ThisSpcHdr.fdate.Month = fread(f,1,'uint8');
        ThisSpcHdr.fdate.Day = fread(f,1,'uint8');
        ThisSpcHdr.fdate.Hour = fread(f,1,'uint8');
        ThisSpcHdr.fdate.Minute = fread(f,1,'uint8');
        ThisSpcHdr.fres = fread(f,8,'*char')';
        ThisSpcHdr.fsource = '';
        ThisSpcHdr.fnsub = 1;
        ThisSpcHdr.flogoff = 0;
        ThisSpcHdr.fpeakpt = fread(f,1,'uint16');
        ThisSpcHdr.nscans = fread(f,1,'uint16');
        ThisSpcHdr.fspare = fread(f,7,'float');
        ThisSpcHdr.fcmnt = fread(f,130,'*char')';
        ThisSpcHdr.fcatxt2 = fread(f,30,'*char')';
        
        %compatibility with new file format:
        ThisSpcHdr.fzinc = 0;
        ThisSpcHdr.fztype = 0;
        ThisSpcHdr.fpost = 0;
        ThisSpcHdr.fmods = 0;
        ThisSpcHdr.fprocs = 0;
        ThisSpcHdr.flevel = 1;
        ThisSpcHdr.fsampin = 1;
        ThisSpcHdr.ffactor = 1;
        ThisSpcHdr.fmethod = '';
        ThisSpcHdr.fwplanes = 0;
        ThisSpcHdr.fwinc = 0;
        ThisSpcHdr.fwtype = 0;
        ThisSpcHdr.freserv = zeros(1,187);
        
        ThisSpcHdr.fres = char(ThisSpcHdr.fres(:)');
        %ThisSpcHdr.fsource = char(ThisSpcHdr.fsource(:)');
        ThisSpcHdr.fcmnt = char(ThisSpcHdr.fcmnt(:)');
        %ThisSpcHdr.fmethod = char (ThisSpcHdr.fmethod(:)');
        
    case 75 %new SPC-file format
        ThisSpcHdr.fexper = fread(f,1,'uint8');   %
        ThisSpcHdr.fexp = fread(f,1,'uint8');     %char: Fraction scaling exponent integer (80h = 128 decimal => spec values are float variables)
        ThisSpcHdr.fnpts = fread(f,1,'uint32');   %DWORD: number of points
        ThisSpcHdr.ffirst = fread(f,1,'float64'); %double: Floating X coordinate of first point
        ThisSpcHdr.flast = fread(f,1,'float64');  %   double: Floating X coordinate of last point
        ThisSpcHdr.fnsub = fread(f,1,'uint32');   %   DWORD: Integer number of subfiles (1 if not TMULTI)
        ThisSpcHdr.fxtype = fread(f,1,'uint8');   %   BYTE: Type of X units
        ThisSpcHdr.fytype = fread(f,1,'uint8');   %   BYTE: Type of Y units
        ThisSpcHdr.fztype = fread(f,1,'uint8');   %   BYTE: Type of Z units
        ThisSpcHdr.fpost = fread(f,1,'uint8');    %   BYTE   fpost;  /* Posting disposition (see GRAMSDDE.H) */
        ThisSpcHdr.fdate2 = fread(f,32,'ubit1');   %   DWORD  fdate;  /* Date/Time LSB: min=6b,hour=5b,day=5b,month=4b,year=12b */
        ThisSpcHdr.fdate = CalcSpecDateTime (ThisSpcHdr.fdate2);
        
        
        ThisSpcHdr.fres = fread(f,9,'char');      % char fres[9]; /* Resolution description text (null terminated) */
        ThisSpcHdr.fsource = fread(f,9,'char');   % char fsource[9]; /* Source instrument description text (null terminated) */
        ThisSpcHdr.fpeakpt = fread(f,1,'uint16'); % WORD fpeakpt; /* Peak point number for interferograms (0=not known) */
        ThisSpcHdr.fspare = fread(f,8,'float32'); % float fspare[8]; /* Used for Array Basic storage */
        ThisSpcHdr.fcmnt = fread(f,130,'char');   % char fcmnt[130]; /* Null terminated comment ASCII text string */
        ThisSpcHdr.fcatxt2 = fread(f,30,'char');   % char fcatxt[30]; /* X,Y,Z axis label strings if ftflgs=TALABS */
        ThisSpcHdr.flogoff = fread(f,1,'uint32'); % DWORD flogoff; /* File offset to log block or 0 (see above) */
        ThisSpcHdr.fmods = fread(f,1,'uint32');   % DWORD fmods; /* File Modification Flags (see below: 1=A,2=B,4=C,8=D..) */
        ThisSpcHdr.fprocs = fread(f,1,'char');    % BYTE fprocs; /* Processing code (see GRAMSDDE.H) */
        ThisSpcHdr.flevel = fread(f,1,'char');    % BYTE flevel; /* Calibration level plus one (1 = not calibration data) */
        ThisSpcHdr.fsampin = fread(f,1,'uint16'); % WORD fsampin; /* Sub-method sample injection number (1 = first or only ) */
        ThisSpcHdr.ffactor = fread(f,1,'float32');% float ffactor; /* Floating data multiplier concentration factor (IEEE-32) */
        ThisSpcHdr.fmethod = fread(f,48,'char');  % char fmethod[48]; /* Method/program/data filename w/extensions comma list */
        ThisSpcHdr.fzinc = fread(f,1,'float32');  % float fzinc; /* Z subfile increment (0 = use 1st subnext-subfirst) */
        ThisSpcHdr.fwplanes = fread(f,1,'uint32');% DWORD fwplanes; /* Number of planes for 4D with W dimension (0=normal) */
        ThisSpcHdr.fwinc = fread(f,1,'float32');  % float fwinc; /* W plane increment (only if fwplanes is not 0) */
        ThisSpcHdr.fwtype = fread(f,1,'char');    % BYTE fwtype; /* Type of W axis units (see definitions below) */
        ThisSpcHdr.freserv = fread(f,187,'char'); % char freserv[187]; /* Reserved (must be set to zero) */
        
        %SPC-header = 512 bytes
        ThisSpcHdr.fres = char(ThisSpcHdr.fres(:)');
        ThisSpcHdr.fsource = char(ThisSpcHdr.fsource(:)');
        ThisSpcHdr.fcmnt = char(ThisSpcHdr.fcmnt(:)');
        ThisSpcHdr.fmethod = char (ThisSpcHdr.fmethod(:)');
        
    otherwise
        fclose (f);
        fprintf(1, 'SPC-header mentiones SPC file version %x\n', ThisSpcHdr.fversn);
        error('GSTools:msg', 'Only supporting the old spc-file format and the new spc-fileformat without different word-order...');
end
fcatxt = ThisSpcHdr.fcatxt2;
ind = find(fcatxt == 0);
ThisSpcHdr.fcatxt.Xlabel = char(fcatxt(1:ind(1)-1)');
ThisSpcHdr.fcatxt.Ylabel = char(fcatxt(ind(1)+1:ind(2)-1)');
ThisSpcHdr.fcatxt.Zlabel = char(fcatxt(ind(2):length(fcatxt))');
clear fcatxt;

function fdate2 = CalcSpecDateTime (fdate)
% fdate is the date and time the data in the file was collected/stored. This
% is not the same as the date and time stamp put on the SPC file by the
% operating system when it is stored. The information is encoded as
% unsigned integers into a 32-bit value for compactness as follows (most
% significant bit is on the left):
% Minute (6bits) Hour (5 bits) Day (5 bits) Month (4 bits) Year (12 bits)
%
%it's the reverse way!
tmp = fdate(6:-1:1);
fdate2.Minute = tmp(1)*32 + tmp(2)*16 + tmp(3)*8 + tmp(4)*4 + tmp(5)*2 + tmp(6);
tmp = fdate(11:-1:7);
fdate2.Hour   = tmp(1)*16 + tmp(2)*8 + tmp(3)*4 + tmp(4)*2 + tmp(5);
tmp = fdate(16:-1:12);
fdate2.Day    = tmp(1)*16 + tmp(2)*8 + tmp(3)*4 + tmp(4)*2 + tmp(5);
tmp = fdate(20:-1:17);
fdate2.Month  = tmp(1)*8 + tmp(2)*4 + tmp(3)*2+ tmp(4);
tmp = fdate(32:-1:21);
fdate2.Year   = tmp(1)*2048 + tmp(2)*1024 + tmp(3)*512 + tmp(4)*256 + tmp(5)*128+ tmp(6)*64 + tmp(7)*32 + tmp(8)*16 + tmp(9)*8 +tmp(10)*4 + tmp(11)*2 + tmp(12);

%-----------------------------------------------------------------
function ThisSubHdr = ReadSubHeader (f)
%This subfunction will load a sub-header in the spc-file.
%f is the file-pointer to the spc-file.
%
%An sub-header has the following structure (extract of the Cpp header file
%of Galactic Industries Corp.): see gspc_udf.pdf for more
%information and technical data. 

ThisSubHdr.subflgs = fread(f,1,'uint8');	%   BYTE  subflgs;	
 ThisSubHdr.subexp  = fread(f,1,'uint8');	%   char  subexp;	/* Exponent for sub-file's Y values (80h=>float) */
ThisSubHdr.subindx = fread(f,1,'uint16');	%   WORD  subindx;	/* Integer index number of trace subfile (0=first) */
ThisSubHdr.subtime = fread(f,1,'float32');	%   float subtime;	/* Floating time for trace (Z axis corrdinate) */
ThisSubHdr.subnext = fread(f,1,'float32');	%   float subnext;	/* Floating time for next trace (May be same as beg) */
ThisSubHdr.subnois = fread(f,1,'float32');	%   float subnois;	/* Floating peak pick noise level if high byte nonzero*/
ThisSubHdr.subnpts = fread(f,1,'uint32');	%   DWORD subnpts;	/* Integer number of subfile points for TXYXYS type*/
ThisSubHdr.subscan = fread(f,1,'uint32');	%   DWORD subscan;	/*Integer number of co-added scans or 0 (for collect)*/
ThisSubHdr.subresv = fread(f,8,'char');		%   char  subresv[8];	/* Reserved area (must be set to zero) */

%subheader = 32 bytes


function ThisLogstcHdr = ReadLogstcHeader (f)
%This subfunction will load a LOGSTC-header in the spc-file.
%f is the file-pointer to the spc-file.
%
%An LOGSTC-header has the following structure (extract of the Cpp header file
%of Galactic Industries Corp.): see gspc_udf.pdf for more
%information and technical data. 

ThisLogstcHdr.logsizd = fread(f,1,'uint32'); % byte size of disk block
ThisLogstcHdr.logsizm = fread(f,1,'uint32'); % byte size of memory block
ThisLogstcHdr.logtxto = fread(f,1,'uint32'); % byte offset to text
ThisLogstcHdr.logbins = fread(f,1,'uint32'); % byte size of binary area (after logstc
ThisLogstcHdr.logdsks = fread(f,1,'uint32'); % byte size of disk area (after logbins)
ThisLogstcHdr.logspar = fread(f,44,'char');  % reserved (must be zero)


function spectrum = ReadOneSpectrum (f, ThisSpcHdr, ThisSubHeader, YScaling, range, nrarg, VerboseOutput) %#ok<INUSD>
if ThisSubHeader.subexp == 0
    YScalingExp = ThisSpcHdr.fexp;
else
    YScalingExp = ThisSubHeader.subexp;
end

%if (ThisSpcHdr.fexp ~= ThisSubHeader.subexp) && (VerboseOutput)
%    fprintf(1, '\nThe exponents in the SPC-header and sub-file-header are different...\n\tSub-file exponent: %i\n\tFile exponent: %i\n\tExponent used: %i\n\n', ThisSubHeader.subexp, ThisSpcHdr.fexp, YScalingExp);
%    fprintf(1, 'SPC-file version: %x\n\n',ThisSpcHdr.fversn);
%end

%This is a hack, which can be used by the user of GSSpcRead, in case of
%improper Y-scaling: e.g. when the spectral software that produced the
%SPC-file did not follow the standards
if nrarg >= 4
    switch YScaling
        case 'fexp'
            YScalingExp = ThisSpcHdr.fexp;
        case 'subexp'
            YScalingExp = ThisSubHeader.subexp;
        otherwise
            error ('GSTools:msg', 'When it is supplied by the user, the parameter that indicates whether the spc-file or the spectrums exponent is to be used, should be ''fexp'' or ''subexp''.');
    end
end
%-------------------------------------------------------------

%read spectrum
if YScalingExp == 128
    %means spectral values are floating point variables instead of the
    %standard integers
    CurrSpec = fread (f, ThisSpcHdr.fnpts, 'float32');
    spectrum  = CurrSpec(range,:);
else
    if ThisSpcHdr.ftflgs.TSPREC
        %Y data blocks are 16 bit integer (only if fexp is NOT 0x80h)
        CurrSpec = fread (f, ThisSpcHdr.fnpts, 'int16');
        spectrum = CurrSpec(range,:) * (2^(YScalingExp-16));
    elseif ThisSpcHdr.fversn == 77
        %32 bit data with words reversed, thus data are read as 32 bit
        %unsigned integers. Thereafter the words are put in the correct
        %order and the sign of the numbers is extracted using the
        %bitshift (..., -31) command.
        CurrSpec = fread(f, ThisSpcHdr.fnpts,'*uint32');
        CurrSpec = bitor( bitshift(CurrSpec,16), bitshift(CurrSpec, -16)); %word swap
        TheSigns = bitshift(CurrSpec, -31); %sign-extraction
        spectrum = (double(CurrSpec) - 2^32 * double(TheSigns)) * (2^(YScalingExp-32));
        clear TheSigns
    else
        CurrSpec = fread (f, ThisSpcHdr.fnpts, 'int32',0);
        spectrum  = CurrSpec(range,:) * (2^(YScalingExp-32));
    end
end
spectrum = spectrum(:)';


function DoPlotSpectrum (Specdata, filename)
if isempty (Specdata.data) == false
    plot (Specdata.xaxis, Specdata.data);
    
    %plot spectral information
    p1 = get(gca, 'XLim');
    p2 = get(gca, 'YLim');
    p3 = get(gca, 'ZLim');
    info = [];
    if isempty (Specdata.Resolution) == false
        info{length (info)+1} = sprintf ('Resolution: %s', Specdata.Resolution);
    end
    if isempty (Specdata.InstrumentSource) == false
        info{length (info)+1} = sprintf ('Intrument source: %s', Specdata.InstrumentSource);
    end
    info{length (info)+1} = sprintf ('Date: %02i/%02i/%i', Specdata.date (1), Specdata.date (2), Specdata.date (3));
    info{length (info)+1} = sprintf ('Time: %02i:%02i', Specdata.date (4), Specdata.date (5));
    tpos1 = p1(1)+(p1(2)-(p1(1)))*0.05; %calculate the right position for the spectral information
    tpos2 = p2(2)-(p2(2)-(p2(1)))*0.1; 
    text (tpos1, tpos2, p3(2), info);
    xlabel (Specdata.xtype);
    ylabel (Specdata.ytype);
    
    %for the eye: make the plot look right!
    h = title (filename, 'interpreter', 'none');
    set (h, 'FontWeight', 'bold');
    set (h, 'FontSize', 16);
    set (gcf, 'PaperOrientation', 'landscape');
    set (gcf, 'PaperPositionMode', 'auto ');
end

function Specdata = FillInSubHeaderInformation (Specdata, i, ThisSpcHdr, ThisSubHdr)
if ThisSpcHdr.ftflgs.TORDRD == 0
    %values are determined by fzinc or difference betweeen subtime
    %and subnext
    if ThisSpcHdr.fzinc == 0 %/* Z subfile increment (0 = use 1st subnext-subfirst) */
        Specdata.spectra(i).zvalue = ThisSubHdr.subtime;
    else
        Specdata.spectra(i).zvalue = Specdata.spectra(1).zvalue + (ThisSpcHdr.fzinc*(i-1));%ThisSubHdr.subtime;
    end
    Specdata.spectra(i).nrscans = ThisSubHdr.subscan;
    Specdata.spectra(i).peaknoise = ThisSubHdr.subnois;
else
    Specdata.spectra(i).zvalue = ThisSubHdr.subtime;
    Specdata.spectra(i).nrscans = ThisSubHdr.subscan;
    Specdata.spectra(i).peaknoise = ThisSubHdr.subnois;
    
end
