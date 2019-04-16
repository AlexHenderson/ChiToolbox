%GSTools v0.4.3
%
%Function GetSPCAxisTypes
%
%This function is used by GSSpcRead and returns the lists of available
%types of axis' units.
%
%Syntax:
%    Types = GetAxisTypes (reversed)
%
%Input parameters:
%    - reversed: boolean: optional: default = 0: indicates whether the
%         numbers indicating the axis labels need to be
%         in the second column (see output paramters)
%
%Output parameters:
%    Types: a structure with fields X and Y, respectively a cell array
%       representing the possible types of X or Y axis units
%
%Example:
%    Types = GetAxisTypes

%This software package is dual licensed. You can use it according to the term
%of either the GPLv3 or the BSD license.
%
%GSTools: a set of MATLAB functions to read, write and work with SPC spectra in MATLAB
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


function Types = GetSPCAxisTypes (reversed)
Types.X{1,1} = '0';
Types.X{1,2} = 'Arbitrary';
Types.X{2,1} = '1';
Types.X{2,2} = 'Wavenumber (cm^{-1})';
Types.X{3,1} = '2';
Types.X{3,2} = 'Micrometers';
Types.X{4,1} = '3';
Types.X{4,2} = 'Nanometers';
Types.X{5,1} = '4';
Types.X{5,2} = 'Seconds';
Types.X{6,1} = '5';
Types.X{6,2} = 'Minutes';
Types.X{7,1} = '6';
Types.X{7,2} = 'Hertz';
Types.X{8,1} = '7';
Types.X{8,2} = 'Kilohertz';
Types.X{9,1} = '8';
Types.X{9,2} = 'Megahertz';
Types.X{10,1} = '9';
Types.X{10,2} = 'Mass (M/z)';
Types.X{11,1} = '10';
Types.X{11,2} = 'Parts per million';
Types.X{12,1} = '11';
Types.X{12,2} = 'Days';
Types.X{13,1} = '12';
Types.X{13,2} = 'Years';
Types.X{14,1} = '13';
Types.X{14,2} = 'Raman Shift (cm^{-1})';
Types.X{15,1} = '14';
Types.X{15,2} = 'Electron Volts (eV)';
Types.X{16,1} = '15';
Types.X{16,2} = 'X,Y,Z text labels in fcatxt (old 4Dh version only)';
Types.X{17,1} = '16';
Types.X{17,2} = 'Diode Number';
Types.X{18,1} = '17';
Types.X{18,2} = 'Channel';
Types.X{19,1} = '18';
Types.X{19,2} = 'Degrees';
Types.X{20,1} = '19';
Types.X{20,2} = 'Temperature (F)';
Types.X{21,1} = '20';
Types.X{21,2} = 'Temperature (C)';
Types.X{22,1} = '21';
Types.X{22,2} = 'Temperature (K)';
Types.X{23,1} = '22';
Types.X{23,2} = 'Data Points';
Types.X{24,1} = '23';
Types.X{24,2} = 'Milliseconds (mSec)';
Types.X{25,1} = '24';
Types.X{25,2} = 'Microseconds (µSec)';
Types.X{26,1} = '25';
Types.X{26,2} = 'Nanoseconds (nSec)';
Types.X{27,1} = '26';
Types.X{27,2} = 'Gigahertz (GHz)';
Types.X{28,1} = '27';
Types.X{28,2} = 'Centimeters (cm)';
Types.X{29,1} = '28';
Types.X{29,2} = 'Meters (m)';
Types.X{30,1} = '29';
Types.X{30,2} = 'Millimeters (mm)';
Types.X{31,1} = '30';
Types.X{31,2} = 'Hours';
Types.X{32,1} = '255';
Types.X{32,2} = 'Double interferogram (no display labels)';

Types.Y{1,1} = '0';
Types.Y{1,2} = 'Arbitrary Intensity';
Types.Y{2,1} = '1';
Types.Y{2,2} = 'Interferogram';
Types.Y{3,1} = '2';
Types.Y{3,2} = 'Absorbance';
Types.Y{4,1} = '3';
Types.Y{4,2} = 'Kubelka-Munk';
Types.Y{5,1} = '4';
Types.Y{5,2} = 'Counts';
Types.Y{6,1} = '5';
Types.Y{6,2} = 'Volts';
Types.Y{7,1} = '6';
Types.Y{7,2} = 'Degrees';
Types.Y{8,1} = '7';
Types.Y{8,2} = 'Milliamps';
Types.Y{9,1} = '8';
Types.Y{9,2} = 'Millimeters';
Types.Y{10,1} = '9';
Types.Y{10,2} = 'Millivolts';
Types.Y{11,1} = '10';
Types.Y{11,2} = 'Log (1/R)';
Types.Y{12,1} = '11';
Types.Y{12,2} = 'Percent';
Types.Y{13,1} = '12';
Types.Y{13,2} = 'Intensity';
Types.Y{14,1} = '13';
Types.Y{14,2} = 'Relative Intensity';
Types.Y{15,1} = '14';
Types.Y{15,2} = 'Energy';
Types.Y{16,1} = '15';
Types.Y{16,2} = '****** NOT USED *******';
Types.Y{17,1} = '16';
Types.Y{17,2} = 'Decibel';
Types.Y{18,1} = '17';
Types.Y{18,2} = '****** NOT USED *******';
Types.Y{19,1} = '18';
Types.Y{19,2} = '****** NOT USED *******';
Types.Y{20,1} = '19';
Types.Y{20,2} = 'Temperature (F)';
Types.Y{21,1} = '20';
Types.Y{21,2} = 'Temperature (C)';
Types.Y{22,1} = '21';
Types.Y{22,2} = 'Temperature (K)';
Types.Y{23,1} = '22';
Types.Y{23,2} = 'Index of Refraction [N]';
Types.Y{24,1} = '23';
Types.Y{24,2} = 'Extinction Coeff. [K]';
Types.Y{25,1} = '24';
Types.Y{25,2} = 'Real';
Types.Y{26,1} = '25';
Types.Y{26,2} = 'Imaginary';
Types.Y{27,1} = '26';
Types.Y{27,2} = 'Complex';
Types.Y{28,1} = '128';
Types.Y{28,2} = 'Transmission (ALL TYPES >=128 ARE ASSUMED TO HAVE INVERTED PEAKS!)';
Types.Y{29,1} = '129';
Types.Y{29,2} = 'Reflectance';
Types.Y{30,1} = '130';
Types.Y{30,2} = 'Arbitrary or Single Beam with Valley Peaks';
Types.Y{31,1} = '131';
Types.Y{31,2} = 'Emission';

if nargin == 1
    if reversed
        Types.X(:,3) = Types.X(:,1);
        Types.X(:,1) = [];
        Types.Y(:,3) = Types.Y(:,1);
        Types.Y(:,1) = [];
    end
end
