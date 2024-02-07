classdef ChiGRAMSFile < ChiThermoFile

% ChiGRAMSFile  File format handler for Thermo Fisher Scientific GRAMS (.spc) files
%
% Syntax
%   myfile = ChiGRAMSFile();
%   myfile = ChiGRAMSFile.open();
%   myfile = ChiGRAMSFile.open(filename(s));
%
% Description
%   myfile = ChiGRAMSFile() creates an empty object.
% 
%   myfile = ChiGRAMSFile.open() opens a dialog box to request filenames
%   from the user. The selected files are opened and concatenated into a
%   ChiSpectrum, ChiSpectralCollection or ChiImage as appropriate.
% 
%   myfile = ChiGRAMSFile.open(filenames) opens the filenames provided in
%   a cell array of strings.
%
%   The GRAMS SPC format has the capacity to hold different types of
%   information. If a single file containing a single spectrum is selected,
%   then myfile is a ChiSpectrum. If a single file containing multiple
%   spectra is selected, then myfile is a ChiSpectralCollection. If a
%   single file containing an image is selected, then myfile is a ChiImage.
%   If multiple files are selected, then these are combined into a
%   ChiSpectralCollection. If any of these contain images, the pixels are
%   unfolded and combined into a ChiSpectralCollection.
%
% Copyright (c) 2017, Alex Henderson.
% Licenced under the GNU General Public License (GPL) version 3.
%
% See also 
%   ChiSpectrum ChiSpectralCollection ChiImage ChiThermoFile.

% Contact email: alex.henderson@manchester.ac.uk
% Licenced under the GNU General Public License (GPL) version 3
% http://www.gnu.org/copyleft/gpl.html
% Other licensing options are available, please contact Alex for details
% If you use this file in your work, please acknowledge the author(s) in
% your publications. 

% Version 1.0, August 2017
% The latest version of this file is available at:
% https://github.com/AlexHenderson/ChiToolbox

% This is a helper class that simply maps to ChiThermoFile

end
