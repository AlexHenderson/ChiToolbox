function obj = ChiFile(filenames)

% ChiFile  Opens a range of different filetypes
%
% Syntax
%   myfile = ChiFile();
%   myfile = ChiFile(filename);
%
% Description
%   myfile = ChiFile() opens a dialog box to request a filename from the
%   user. The selected file is opened using the correct file reader.
% 
%   myfile = ChiFile(filename) opens the filename provided as a char
%   string.
%
%   This class can read a range of different filetypes.
%   Only a single file can be opened using this method. If you require
%   multiple files (say to create a ChiSpectralCollection) you should use
%   the appropriate reader for that file type. 
%
% Copyright (c) 2018, Alex Henderson.
% Licenced under the GNU General Public License (GPL) version 3.
%
% See also 
%   ChiFileReader ChiSpectrum ChiSpectralCollection ChiImage.

% Contact email: alex.henderson@manchester.ac.uk
% Licenced under the GNU General Public License (GPL) version 3
% http://www.gnu.org/copyleft/gpl.html
% Other licensing options are available, please contact Alex for details
% If you use this file in your work, please acknowledge the author(s) in
% your publications. 

% Version 2.0, September 2018
% The latest version of this file is available on Bitbucket
% https://bitbucket.org/AlexHenderson/chitoolbox
    
% All FileReaders should inherit from ChiAbstractFileFormat. 
% First we collect a list of all classes that inherit from
% ChiAbstractFileFormat. Each of these has some static functions. We call
% these functions to build a list of readable file types. 
    
% Note this is a free function, not a class. 


    % If filename(s) are not provided, ask the user
    if ~exist('filenames', 'var')
        filters = ChiFileReader.assembleFilters();
        filenames = utilities.getfilenames(filters);
    end

    % Make sure we have a cell array of filenames
    if ~iscell(filenames)
        filenames = cellstr(filenames);
    end
    
    % Pass filenames on to next stage
    obj = ChiFileReader.read(filenames);
    
end
