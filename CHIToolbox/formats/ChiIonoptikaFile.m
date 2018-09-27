classdef ChiIonoptikaFile < ChiAbstractFileFormat

% ChiIonoptikaFile  File format handler for Ionoptika (.h5) files
%
% Syntax
%   myfile = ChiIonoptikaFile();
%   myfile = ChiIonoptikaFile.open();
%
% Description
%   myfile = ChiIonoptikaFile() creates an empty object.
% 
%   myfile = ChiIonoptikaFile.open() opens a dialog box to request filenames
%   from the user. The selected files are opened and concatenated into a
%   ChiToFMassSpectrum, ChiSpectralCollection or ChiImage as appropriate.
% 
%   This class can read Ionoptika h5 files (Windows version) (*.h5). 
%
% Copyright (c) 2017-2018, Alex Henderson.
% Licenced under the GNU General Public License (GPL) version 3.
%
% See also 
%   ChiToFMassSpectrum ChiSpectrum ChiSpectralCollection ChiImage.

% Contact email: alex.henderson@manchester.ac.uk
% Licenced under the GNU General Public License (GPL) version 3
% http://www.gnu.org/copyleft/gpl.html
% Other licensing options are available, please contact Alex for details
% If you use this file in your work, please acknowledge the author(s) in
% your publications. 

% Version 3.0, September 2018
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
            if ~strcmpi(ext,'.h5')
                return
            end
            % ToDo: Check internal magic numbers
            truefalse = true;
        end
        
        % ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
        function extn = getExtension()
            extn = '*.h5';
        end
        
        % ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
        function filter = getFiltername()
            filter = 'Ionoptika Files (*.h5)';
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
                filenames = utilities.getfilenames({ChiIonoptikaFile.getExtension(), ChiIonoptikaFile.getFiltername()});
            end
            
            % Make sure we have a cell array of filenames
            if ~iscell(filenames)
                filenames = cellstr(filenames);
            end
            
            % Check whether the files are OK for a Thermo reader
            for i = 1:length(filenames) 
                if ~ChiThermoFile.isreadable(filenames{i})
                    message = sprintf('Filename %s is not an Ionoptika file (*.h5).', utilities.pathescape(filenames{i}));
                    err = MException(['CHI:',mfilename,':InputError'], message);
                    throw(err);
                end
            end
            
            % Open the file(s)
            if (length(filenames) > 1)
                utilities.warningnobacktrace('Only reading the first file.');
                filenames = filenames(1);
            end
            
            [mass,data,height,width,layers,filename,x_label,y_label,imzmlinfo] = ionoptika_hd5file(filenames{1}); %#ok<ASGLU>
            
            % Work out whether this is a continuum dataset or a mass
            % binned one. Crude method, but...
            mstep1 = mass(2) - mass(1);
            mstep2 = mass(end) - mass(end-1);
            if (mstep1 == mstep2)
                obj = ChiMassSpecImage(double(mass),double(data),width,height);
            else
                obj = ChiToFMassSpecImage(double(mass),double(data),width,height);
            end

            obj.imzmlproperties = imzmlinfo;
            obj.filenames = filenames;
            for i = 1:length(filenames)
                obj.history.add(['Ionoptika file: ', filenames{i}]);
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
            obj = ChiIonoptikaFile.open(varargin{:});
        end
            
        % ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
        function name = className()
            name = mfilename('class');
        end
    
        % ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    end
    
end
