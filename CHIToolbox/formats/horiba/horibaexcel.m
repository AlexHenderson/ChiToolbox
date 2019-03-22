function [ramanshift,data,info] = horibaexcel(filename)

% horibaexcel  File format handler for Horiba Excel (.xls) files
%
% Syntax
%   [ramanshift,data,info] = horibaexcel();
%   [ramanshift,data,info] = horibaexcel(filename);
%
% Description
%   [ramanshift,data,info] = horibaexcel() prompts the user for a filename,
%   opens the file and extracts the Raman shift (x-axis) values in
%   ramanshift (row vector) and the spectra in data, where each row is a
%   spectrum. info is a struct containing the filename.
% 
%   [ramanshift,data,info] = horibaexcel(filename) opens the filename
%   provided.
%
%   This class reads a Microsoft Excel file exported from the Horiba
%   LabSpec software. 
%
% Copyright (c) 2019, Alex Henderson.
% Licenced under the GNU General Public License (GPL) version 3.
%
% See also 
%   ChiHoribaFile ChiRamanSpectrum ChiRamanSpectralCollection.

% Contact email: alex.henderson@manchester.ac.uk
% Licenced under the GNU General Public License (GPL) version 3
% http://www.gnu.org/copyleft/gpl.html
% Other licensing options are available, please contact Alex for details
% If you use this file in your work, please acknowledge the author(s) in
% your publications. 

% The latest version of this file is available on Bitbucket
% https://bitbucket.org/AlexHenderson/chitoolbox

if ~exist('filename', 'var')
	filename = utilities.getfilenames({ChiHoribaFile.getExtension(), ChiHoribaFile.getFiltername()});
    if iscell(filename)
        filename = filename{1};
    end
end

num = xlsread(filename);

% Ignore first 9 lines since we can't be sure of their contents

ramanshift = num(10:end,1)';
data = num(10:end,3:end)';

info.filename = filename;

end
