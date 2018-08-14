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

% Version 4.0, August 2018
% The latest version of this file is available on Bitbucket
% https://bitbucket.org/AlexHenderson/chitoolbox


    methods (Static)
        % ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
        function truefalse = isreadable(filename)
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
            
            if ~strcmpi(contents.name, 'AB')
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
        function obj = open(varargin)
            if ~nargout
                stacktrace = dbstack;
                functionname = stacktrace.name;
                err = MException(['CHI:',mfilename,':InputError'], ...
                    'Nowhere to put the output. Try something like: myfile = %s(filename);',functionname);
                throw(err);
            end
            if (nargin > 0)
                if ChiBrukerFile.isreadable(varargin{1})
                    obj = ChiBrukerFileHandler(varargin{:});
                else
                    err = MException(['CHI:',mfilename,':InputError'], ...
                        'Filename does not appear to be a Bruker Opus file (*.mat).');
                    throw(err);
                end
            else
                obj = ChiBrukerFileHandler();
            end
        end        
        
        % ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
        function obj = read(varargin)
        if ~nargout
            stacktrace = dbstack;
            functionname = stacktrace.name;
            err = MException(['CHI:',mfilename,':InputError'], ...
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
