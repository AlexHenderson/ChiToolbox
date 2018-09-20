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

% Version 4.0, August 2018
% The latest version of this file is available on Bitbucket
% https://bitbucket.org/AlexHenderson/chitoolbox


    methods (Static)
        % ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
        function truefalse = isreadable(filename)
            truefalse = false;
            % Check extension
            [pathstr,name,ext] = fileparts(filename); %#ok<ASGLU>
            if ~(strcmpi(ext,'.dms') || strcmpi(ext,'.seq'))
                return
            end
            % ToDo: Check internal magic numbers
            truefalse = true;
        end
        
        % ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
        function extn = getExtension()
            extn = '*.dms;*.seq';
        end
        
        % ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
        function filter = getFiltername()
            filter = 'Agilent Image Files (*.dms,*.seq)';
        end
        
        % ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
        function obj = open(filename)
            if ~nargout
                stacktrace = dbstack;
                functionname = stacktrace.name;
                err = MException(['CHI:',mfilename,':InputError'], ...
                    'Nowhere to put the output. Try something like: myfile = %s(filename);',functionname);
                throw(err);
            end
            if exist('filename', 'var')
                if ChiAgilentFile.isreadable(filename)
                    [wavenumbers,data,height,width,filename,acqdate] = agilentFile(filename); %#ok<ASGLU>
                else
                    err = MException(['CHI:',mfilename,':InputError'], ...
                        'Filename does not appear to be an Agilent file (*.dms or *.seq).');
                    throw(err);
                end                    
            else
                [wavenumbers,data,height,width,filename,acqdate] = agilentFile(); %#ok<ASGLU>
            end

            obj = ChiIRImage(wavenumbers,data,width,height);
            obj.filename = filename;
            obj.history.add(['Agilent file: ', filename]);
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
