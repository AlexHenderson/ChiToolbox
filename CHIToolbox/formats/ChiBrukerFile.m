classdef ChiBrukerFile < ChiAbstractFileFormat

% ChiBrukerFile  File format handler for Bruker Opus files (*.mat)
% 
% Imports MAT files exported from Bruker Opus at Diamond Light Source
% 
% Syntax
%   myfile = ChiBrukerFile();
%   myfile = ChiBrukerFile.open();
%   myfile = ChiBrukerFile.open(filename);
%
% Syntax
%   myfile = ChiBrukerFile();
%   myfile = ChiBrukerFile.open(filename);
%   myfile = ChiBrukerFile.open(filename,'map',height,width);
%
% Description
%   myfile = ChiBrukerFile() creates an empty object.
% 
%   myfile = ChiBrukerFile.open() prompts the user for a filename. The
%   selected file is opened as a ChiSpectrum, or ChiSpectralCollection, as
%   appropriate.
% 
%   myfile = ChiBrukerFile.open(filename) opens the filename provided as a
%   char string.
%
%   myfile = ChiBrukerFile.open(filename,'map',height,width) opens a
%   Bruker Opus MATLAB file collected in mapping format. height and width
%   are the rows and columns of the map. If filename is not provided, the
%   user is prompted for a location. myfile is a ChiImage. 
%
% Copyright (c) 2017-2018, Alex Henderson.
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

% Version 5.0, September 2018
% The latest version of this file is available on Bitbucket
% https://bitbucket.org/AlexHenderson/chitoolbox


    methods (Static)
        % ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
        function truefalse = isreadable(filename)
            if iscell(filename)
                filename = filename{1};
            end
            truefalse = false;
            % Check extension
            [pathstr,name,ext] = fileparts(filename); %#ok<ASGLU>
            if ~strcmpi(ext,'.mat')
                return
            end
            
            % The Bruker Opus files contain an item called AB
            contents = whos('-file',filename);
            if ~isstruct(contents)
                return
            end
            if ~isfield(contents,'name')
                return
            end
            
            if ~strcmpi(contents(1).name, 'AB')
                return
            end
            
            % ToDo: Check internal magic numbers
            truefalse = true;
        end
        
        % ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
        function extn = getExtension()
            extn = '*.mat';
        end
        
        % ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
        function filter = getFiltername()
            filter = 'Bruker Opus MAT Files (*.mat)';
        end
        
        % ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
        function obj = open(filenames)
            % Do we have somewhere to put the data?
            if ~nargout
                stacktrace = dbstack;
                functionname = stacktrace.name;
                err = MException(['CHI:',mfilename,':IOError'], ...
                    'Nowhere to put the output. Try something like: myfile = %s(filename);',functionname);
                throw(err);
            end
            
            % If filename(s) are not provided, ask the user
            if ~exist('filenames', 'var')
                filenames = utilities.getfilenames({ChiBrukerFile.getExtension(), ChiBrukerFile.getFiltername()});
            end
            
            % Make sure we have a cell array of filenames
            if ~iscell(filenames)
                filenames = cellstr(filenames);
            end
            
            % Check whether the files are OK for a Bruker reader
            for i = 1:length(filenames) 
                if ~ChiBrukerFile.isreadable(filenames{i})
                    message = sprintf('Filename %s is not a Bruker Opus MAT file (*.mat).', utilities.pathescape(filenames{i}));
                    err = MException(['CHI:',mfilename,':InputError'], message);
                    throw(err);
                end
            end
            
            % Open the file(s)
            if (length(filenames) > 1)
                utilities.warningnobacktrace('Only reading the first file.');
                filenames = filenames(1);
            end

            obj = ChiBrukerFileHandler(filenames);
            
        end        
        
        % ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
        function obj = read(varargin)
        if ~nargout
            stacktrace = dbstack;
            functionname = stacktrace.name;
            err = MException(['CHI:',mfilename,':IOError'], ...
                'Nowhere to put the output. Try something like: myfile = %s(filename);',functionname);
            throw(err);
        end
            obj = ChiBrukerFile.open(varargin{:});
        end
            
        % ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
        function name = className()
            name = mfilename('class');
        end
    
        % ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    end
    
end
