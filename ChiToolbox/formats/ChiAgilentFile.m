classdef ChiAgilentFile < ChiAbstractFileFormat

% ChiAgilentFile  File format handler for Agilent IR image (.dms, .seq) files
%
% Syntax
%   myfile = ChiAgilentFile();
%   myfile = ChiAgilentFile.open();
%   myfile = ChiAgilentFile.open(filename);
%
% Description
%   myfile = ChiAgilentFile() creates an empty object.
% 
%   myfile = ChiAgilentFile.open() opens a dialog box to request a filename
%   from the user. The selected file is opened converted to a ChiIRImage.
% 
%   myfile = ChiAgilentFile.open(filename) opens the filename provided as a
%   char string.
%
%   This class can read Agilent infrared hyperspectral images, either a
%   single tile, or mosaicked tile collection (*.seq, *.dms).
%
% Copyright (c) 2017-2018, Alex Henderson.
% Licenced under the GNU General Public License (GPL) version 3.
%
% See also 
%   ChiIRImage ChiSpectrum ChiSpectralCollection ChiImage ChiFile.

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
            if ~(strcmpi(ext,'.dmt') || strcmpi(ext,'.dms') || strcmpi(ext,'.seq'))
                return
            end
            % ToDo: Check internal magic numbers
            truefalse = true;
        end
        
        % ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
        function extn = getExtension()
            extn = '*.dmt;*.seq';
        end
        
        % ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
        function filter = getFiltername()
            filter = 'Agilent Image Files (*.dmt,*.seq)';
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
                filenames = utilities.getfilenames({ChiAgilentFile.getExtension(), ChiAgilentFile.getFiltername()});
            end
            
            % Make sure we have a cell array of filenames
            if ~iscell(filenames)
                filenames = cellstr(filenames);
            end
            
            % Check whether the files are OK for an Agilent reader
            for i = 1:length(filenames) 
                if ~ChiAgilentFile.isreadable(filenames{i})
                    message = sprintf('Filename %s is not an Agilent file (*.dmt/*.seq).', utilities.pathescape(filenames{i}));
                    err = MException(['CHI:',mfilename,':InputError'], message);
                    throw(err);
                end
            end
            
            % Open the file(s)
            if (length(filenames) > 1)
                utilities.warningnobacktrace('Only reading the first file.');
                filenames = filenames(1);
            end
            
            [wavenumbers,data,height,width,filename,acqdate] = agilentFile(filenames{1}); %#ok<ASGLU>
            
            obj = ChiIRImage(wavenumbers,data,width,height);
            obj.filenames = filenames;
            for i = 1:length(filenames)
                obj.history.add(['Agilent file: ', filenames{i}]);
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
            obj = ChiAgilentFile.open(varargin{:});
        end
            
        % ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
        function name = className()
            name = mfilename('class');
        end
    
        % ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    end

    methods
    end
    
end
