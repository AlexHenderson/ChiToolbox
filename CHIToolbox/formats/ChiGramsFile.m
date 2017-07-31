function thermoData = ChiGramsFile(filenames)

% ChiGramsFile File format handler for Thermo Scientific GRAMS (.spc) files
%
% Syntax
%   thermoData = ChiGramsFile();
%   thermoData = ChiGramsFile(filenames);
%
% Description
%   thermoData = ChiGramsFile() prompts the user for one, or more, Thermo
%   Scientific GRAMS (*.spc) files.
% 
%   thermoData = ChiGramsFile(filenames) opens the filenames provided in a
%   cell array of strings.
%
%   The GRAMS SPC format has the capacity to hold different types of
%   information. If a single file containing a single spectrum is selected,
%   then thermoData is a ChiSpectrum. If a single file containing multiple
%   spectra is selected, then thermoData is a ChiSpectralCollection. If a
%   single file containing an image is selected, then thermoData is a
%   ChiImage. 
%   If multiple files are selected, then these are combined into a
%   ChiSpectralCollection. If any of these contain images, the pixels are
%   unfolded and combined into a ChiSpectralCollection. 
%
% Copyright (c) 2017, Alex Henderson.
% Licenced under the GNU General Public License (GPL) version 3.
%
% See also 
%   ChiSpectrum ChiSpectralCollection ChiImage.

% Contact email: alex.henderson@manchester.ac.uk
% Licenced under the GNU General Public License (GPL) version 3
% http://www.gnu.org/copyleft/gpl.html
% Other licensing options are available, please contact Alex for details
% If you use this file in your work, please acknowledge the author(s) in
% your publications. 

% Version 1.0, July 2017
% The latest version of this file is available on Bitbucket
% https://bitbucket.org/AlexHenderson/chitoolbox


if ~exist('filenames', 'var')
    filenames = utilities.getfilenames(vertcat(...
            {'*.spc',  'Thermo Scientific GRAMS Files (*.spc)'}));

    if (isfloat(filenames) && (filenames == 0))
        return;
    end
end

thermoData = thermoFile(filenames);

end
