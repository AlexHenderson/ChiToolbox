classdef ChiBrukerFile < ChiAbstractFileFormat

% ChiBrukerFile  File format handler for Bruker Opus files (*.??? or *.mat)
% 
% Imports Bruker Opus files either in raw format (*.??? where ??? is a
% number), or exported as MAT files.
% 
% Syntax
%   myfile = ChiBrukerFile();
%   myfile = ChiBrukerFile.open();
%   myfile = ChiBrukerFile.open(filenames);
%   myfile = ChiBrukerFile.open(filename,'map',height,width);
%
% Description
%   myfile = ChiBrukerFile() creates an empty object.
% 
%   myfile = ChiBrukerFile.open() prompts the user for a filename. The
%   selected file is opened as a ChiSpectrum, ChiSpectralCollection or
%   ChiImage, as appropriate.
% 
%   myfile = ChiBrukerFile.open(filenames) opens the files provided as a
%   char string, or cell array of char strings.
%
%   myfile = ChiBrukerFile.open(filename,'map',height,width) opens a
%   Bruker Opus MATLAB file collected in mapping format. height and width
%   are the rows and columns of the map. If filename is not provided, the
%   user is prompted for a location. myfile is a ChiImage. 
% 
% Notes
%   Only a single MAT file can be opened. 
%   Multiple Opus files can be selected. These will be concatenated into a
%   single ChiSpectralCollection.
%   The Open Files dialog only suggests files up to *.10
%   (.0,.1,.2,.3,.4,.5,.6,.7,.8,.9,.10). If files with extensions higher
%   than that are required, use the All Files (*.*) filter.
%   Mixtures of Opus and *.mat files are not allowed. 
%   Some Opus files do not contain spectra. If one of these is selected a
%   warning is issued and the file is ignored. 
%
% Copyright (c) 2017-2019, Alex Henderson.
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

% Version 7.0, February 2019
% The latest version of this file is available on Bitbucket
% https://bitbucket.org/AlexHenderson/chitoolbox


    methods (Static)
        % ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
        function truefalse = isreadable(filename)
            if iscell(filename)
                filename = filename{1};
            end
            
            truefalse = false;
            
            % Readability for Opus files
            try
                truefalse = ChiOpusFile.isreadable(filename);
                if truefalse
                    return;
                end
            catch ex
                rethrow(ex);
            end
            
            % Readability for exported MAT files
            % Check extension
            [pathstr,name,ext] = fileparts(filename); %#ok<ASGLU>
            if ~strcmpi(ext,'.mat')
                return
            end
            
            if strcmpi(ext,'.mat')
                % The Bruker Opus MAT files contain an item called AB
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
            end
            
            % If we get to here, we consider the file to be readable. 
           truefalse = true; 
        end
        
        % ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
        function extn = getExtension()
            extn = [ChiOpusFile.getExtension(), ';*.mat'];
        end
        
        % ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
        function filter = getFiltername()
            filter = 'Bruker Opus Files (*.???;*.mat) [where ??? is a number]';
        end
        
        % ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
        function obj = open(varargin)
            % Do we have somewhere to put the data?
            if ~nargout
                stacktrace = dbstack;
                functionname = stacktrace.name;
                err = MException(['CHI:',mfilename,':IOError'], ...
                    'Nowhere to put the output. Try something like: myfile = %s(filename);',functionname);
                throw(err);
            end
            
            if nargin
                filenames = varargin{1};
                varargin{1} = [];
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
                    message = sprintf('Filename %s is not a Bruker Opus file.', utilities.pathescape(filenames{i}));
                    err = MException(['CHI:',mfilename,':InputError'], message);
                    throw(err);
                end
            end
            
            % Open the file(s)
            % We can read a single mat file or many 0 files. Combinations
            % of a single mat file and one, or more, 0 files are not
            % allowed.
            numfiles = length(filenames);
            matfilecount = 0;
            if (numfiles > 1)
                for i = 1:numfiles
                    [filepath,name,ext] = fileparts(filenames{i}); %#ok<ASGLU>
                    if strcmpi(ext,'.mat')
                        matfilecount = matfilecount + 1;
                    end
                end
                if (matfilecount >= 1)
                    message = 'Can read either multiple Opus files, or a single MAT file. Combinations are also not allowed.';
                    err = MException(['CHI:',mfilename,':InputError'], message);
                    throw(err);
                end
            end
            
            [filepath,name,ext] = fileparts(filenames{1}); %#ok<ASGLU>
            if strcmpi(ext, '.mat')
                obj = ChiBrukerMATFileHandler(filenames,varargin);
            else
                obj = ChiOpusFile().read(filenames);
            end
            
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
