classdef ChiBiotofFile < ChiAbstractFileFormat

% ChiBiotofFile  File format handler for Biotof spectra and image files
%
% Syntax
%   myfile = ChiBiotofFile();
%   myfile = ChiBiotofFile.open();
%   myfile = ChiBiotofFile.open(filename(s));
%
% Description
%   myfile = ChiBiotofFile() creates an empty object.
% 
%   myfile = ChiBiotofFile.open() opens a dialog box to request filenames
%   from the user. The selected files are opened and concatenated into a
%   ChiToFMSSpectrum, ChiToFMSSpectralCollection or ChiMSImage as appropriate.
% 
%   myfile = ChiBiotofFile.open(filenames) opens the filenames provided in
%   a cell array of strings.
%
%   This class can read one or more Biotof spectral files (*.dat) or a
%   single Biotof image file (*.xyt). The file format has the capacity to
%   hold different types of information. If a single file containing a
%   spectrum is selected, then myfile is a ChiToFMSSpectrum. If multiple
%   spectral files are selected, then myfile is a
%   ChiToFMSSpectralCollection. If a single file containing an image is
%   selected, then myfile is a ChiMSImage. If multiple image files are
%   selected, only first is read.
%
% Copyright (c) 2018, Alex Henderson.
% Licenced under the GNU General Public License (GPL) version 3.
%
% See also 
%   ChiToFMSSpectrum ChiToFMSSpectralCollection ChiMSImage.

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
            if ~(strcmpi(ext,'.dat') || strcmpi(ext,'.xyt'))
                return
            end
            % ToDo: Check internal magic numbers
            truefalse = true;
        end
        
        % ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
        function extn = getExtension()
            extn = '*.dat;*.xyt';
        end
        
        % ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
        function filter = getFiltername()
            filter = 'Biotof Files (*.dat;*.xyt)';
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
                filenames = utilities.getfilenames(vertcat(...
                        {'*.dat;*.xyt',  'Biotof Files (*.dat,*.xyt)'}, ...
                        {'*.dat',  'Biotof Spectral Files (*.dat)'}, ...
                        {'*.xyt',  'Biotof Image Files (*.xyt)'}));
            end
            
            % Make sure we have a cell array of filenames
            if ~iscell(filenames)
                filenames = cellstr(filenames);
            end
            
            % Check whether the files are OK for a Biotof reader
            for i = 1:length(filenames) 
                if ~ChiBiotofFile.isreadable(filenames{i})
                    message = sprintf('Filename %s is not a Biotof file (*.dat/*.xyt).', utilities.pathescape(filenames{i}));
                    err = MException(['CHI:',mfilename,':InputError'], message);
                    throw(err);
                end
            end
            
            % Open the file(s)
            [mass,data,height,width,filename,imzmlinfo] = biotofFile(filenames);
                
            % Make sure we have a cell array of filenames
            if ~iscell(filenames)
                filenames = cellstr(filenames);
            end
            
            if ((height == 1) && (width == 1))
                % We have one or more spectra rather than an image
                % Check to see if we have a single spectrum or a profile
                if (numel(data) == numel(mass))
                    obj = ChiToFMSSpectrum(mass,data);
                else
                    obj = ChiToFMSSpectralCollection(mass,data);
                end               
            else
                % We read Biotof images at nominal mass, so they are no
                % longer ToF-SIMS images
                obj = ChiMSImage(mass,data,width,height);
                obj.imzmlproperties = imzmlinfo;
            end
            
            obj.filenames = filenames;
            
            for i = 1:length(filenames)
                obj.history.add(['Biotof file: ', filenames{i}]);
            end
            
        end     % function open
        
        % ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
        function obj = read(varargin)
            if ~nargout
                stacktrace = dbstack;
                functionname = stacktrace.name;
                err = MException(['CHI:',mfilename,':IOError'], ...
                    'Nowhere to put the output. Try something like: myfile = %s(filename);',functionname);
                throw(err);
            end
            obj = ChiBiotofFile.open(varargin{:});
        end
            
        % ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
        function name = className()
            name = mfilename('class');
        end
    
        % ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    end
    
end
