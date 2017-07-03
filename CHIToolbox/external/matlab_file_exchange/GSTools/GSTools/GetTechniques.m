function Techniques = GetTechniques (reversed)
%GetTechniques v0.4.3
%
%This function generates the list with experimental techniques that are
%known by the SPC file format.
%
%Syntax:
%    Techniques = GetTechniques (reversed)
%
%Input parameters:
%    - reversed: boolean: optional: default = 0: indicates whether the
%         numbers indicating the experimental technique need to be
%         in the second column (see output paramters)
%
%Output parameters:
%    - Cell array:
%         1st column: the numbers for the experimental technique
%         2nd column: description of the experimental technique
%
%
%Technical data about the SPC-fileformat is freely available and obtained
%from Galactic Industries Corp: see gspc_udf.pdf available at:
%    https://ftirsearch.com/features/converters/SPCFileFormat.htm
%

%This software package is dual licensed. You can use it according to the term
%of either the GPLv3 or the BSD license.
%
%GSTools: a set of MATLAB functions to read, write and work with SPC spectra in MATLAB
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

%History:
%   v0.4:
%      - Extracted from GSSpcRead

Techniques{1,1} = '0';
Techniques{1,2} = 'General (could be anything)';
Techniques{2,1} = '1';
Techniques{2,2} = 'Gas Chromatogram';
Techniques{3,1} = '2';
Techniques{3,2} = 'General Chromatogram'; % (same as SPCGEN and TCGRAM in ftflgs).';
Techniques{4,1} = '3';
Techniques{4,2} = 'HPLC Chromatogram';
Techniques{5,1} = '4';
Techniques{5,2} = 'FT-IR, FT-NIR, FT-Raman Spectrum'; %(Can also be used for scanning IR.)
Techniques{6,1} = '5';
Techniques{6,2} = 'NIR Spectrum';
Techniques{7,1} = '6';
Techniques{7,2} = 'UV-VIS Spectrum';% (Can be used for single scanning UVVIS-NIR.)
%0x07h Not Defined Do not use.
Techniques{8,1} = '8';
Techniques{8,2} = 'X-ray Diffraction Spectrum';
Techniques{9,1} = '9';
Techniques{9,2} = 'Mass Spectrum'; %(Can be GC-MS, Continuum, Centroid or TOF.)
Techniques{10,1} = '10';
Techniques{10,2} = 'NMR Spectrum';
Techniques{11,1} = '11';
Techniques{11,2} = 'Raman Spectrum'; %(Usually Diode Array, CCD, etc. not for FT-Raman.)
Techniques{12,1} = '12';
Techniques{12,2} = 'Fluorescence Spectrum';
Techniques{13,1} = '13';
Techniques{13,2} = 'Atomic Spectrum';
Techniques{14,1} = '14';
Techniques{14,2} = 'Chromatography Diode Array Spectra';

if nargin == 1
    if reversed
        Techniques(:,3) = Techniques(:,1);
        Techniques(:,1) = [];
    end
end
