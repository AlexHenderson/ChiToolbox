classdef ChiThermoFile < ChiAbstractFileFormat

% ChiThermoFile  File format handler for Thermo Fisher Scientific GRAMS (.spc) files
%
% Syntax
%   myfile = ChiThermoFile();
%   myfile = ChiThermoFile.open();
%   myfile = ChiThermoFile.open(filename(s));
%
% Description
%   myfile = ChiThermoFile() creates an empty object.
% 
%   myfile = ChiThermoFile.open() opens a dialog box to request filenames
%   from the user. The selected files are opened and concatenated into a
%   ChiSpectrum, ChiSpectralCollection or ChiImage as appropriate.
% 
%   myfile = ChiThermoFile.open(filenames) opens the filenames provided in
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

% Version 3.0, August 2018
% The latest version of this file is available on Bitbucket
% https://bitbucket.org/AlexHenderson/chitoolbox
    
    
    methods (Static)
        % ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
        function truefalse = isreadable(filenames)

            % Ensure filenames is a cell array
            if ~iscell(filenames)
                filenames = cellstr(filenames);
            end
            
            truefalse = false;
            for i = 1:length(filenames)
                % Check extension
                [pathstr,name,ext] = fileparts(filenames{i}); %#ok<ASGLU>
                if ~strcmpi(ext,'.spc')
                    return
                end
            end
            % ToDo: Check internal magic numbers
            truefalse = true;
        end
        
        % ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
        function extn = getExtension()
            extn = '*.spc';
        end
        
        % ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
        function filter = getFiltername()
            filter = 'Thermo Scientific GRAMS Files (*.spc)';
        end
        
        % ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
        function obj = open(filenames)
            if ~nargout
                stacktrace = dbstack;
                functionname = stacktrace.name;
                err = MException(['CHI:',mfilename,':InputError'], ...
                    'Nowhere to put the output. Try something like: myfile = %s(filename);',functionname);
                throw(err);
            end

            % If filename(s) are not provided, ask the user
            if ~exist('filenames', 'var')
                filenames = utilities.getfilenames(vertcat(...
                        {'*.spc',  'Thermo Scientific GRAMS Files (*.spc)'}));

                if (isfloat(filenames) && (filenames == 0))
                    return;
                end
            end
            
            % Check whether the files are OK for a Thermo reader
            if ~ChiThermoFile.isreadable(filenames)
                err = MException('CHI:ChiThermoFile:InputError', ...
                    'Filenames do not appear to be Thermo Fisher files (*.spc).');
                throw(err);
            end
            
            % Open the file(s)
            obj = thermoFile(filenames);

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
            obj = ChiThermoFile.open(varargin{:});
        end
            
        % ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
        function name = className()
            name = mfilename('class');
        end
    
        % ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    end
    
end
