function obj = ChiBrukerFileHandler(varargin)

% ChiBrukerFileHandler  File format handler for Bruker Opus files
% 
% Imports MAT files exported from Bruker Opus at Diamond Light Source
%
% Syntax
%   brukerData = ChiBrukerFileHandler();
%   brukerData = ChiBrukerFileHandler(filename);
%   brukerData = ChiBrukerFileHandler(____,'map',height,width);
%
% Description
%   brukerData = ChiBrukerFileHandler() prompts the user for a Bruker Opus
%   MATLAB file (*.mat).
% 
%   brukerData = ChiBrukerFileHandler(filename) opens the file named
%   filename.
%
%   brukerData = ChiBrukerFileHandler(____,'map',height,width) opens a
%   Bruker Opus MATLAB file collected in mapping format. height and width
%   are the rows and columns of the map. If filename is not provided, the
%   user is prompted for a location.
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


%% Manage the argument list 
isMap = false;
argposition = find(cellfun(@(x) strcmpi(x, 'map') , varargin));
if argposition
    isMap = true;
    height = varargin{argposition + 1};
    width = varargin{argposition + 2};
    % Remove the parameters from the argument list in reverse order to
    % preserve the argument order 
    varargin(argposition + 2) = [];
    varargin(argposition + 1) = [];
    varargin(argposition) = [];
end

%% Get the filename if not supplied
% Having removed the possible 'map' entries from the argument list, the
% only possible remaining entry is the filename

if ~isempty(varargin)
    filenames = varargin{1};
else
    filenames = utilities.getfilename('*.mat', 'Bruker Opus MAT Files (*.mat)');
end

if ~iscell(filenames)
    filenames = cellstr(filenames);
end


%% Import the data
% The contents always contains a variable called AB
brukermatfile = load(filenames{1}, 'AB');
AB = brukermatfile.AB;
AB = flipud(AB);

wavenumbers = AB(:,1);
data = AB(:,2:end);
data = data';

%% Convert to ChiToolbox format
if isMap
    % Handle case where the file represents a map
    data = reshape(data,width,height,[]);
    data = permute(data,[2,1,3]);
    data = flip(data,1);
    data = reshape(data,height*width,[]);
    
    obj = ChiIRImage(wavenumbers,data,width,height);
else
    if (size(data,1) == 1)
        % We only have a single spectrum
        obj = ChiIRSpectrum(wavenumbers,data);
    else
        % We have a number of spectra, but these are not part of a mapping
        % experiment
        obj = ChiIRSpectralCollection(wavenumbers,data);
    end
end

obj.filenames = filenames;

for i = 1:length(filenames)
    obj.history.add(['Bruker Opus MAT file: ', filenames{i}]);
end
            
end % function ChiBrukerFileHandler
