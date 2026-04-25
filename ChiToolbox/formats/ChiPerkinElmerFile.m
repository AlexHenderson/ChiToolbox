classdef ChiPerkinElmerFile < ChiAbstractFileFormat

% ChiPerkinElmerFile  File format handler for PerkinElmer spectra and image files
%
% Syntax
%   myfile = ChiPerkinElmerFile();
%   myfile = ChiPerkinElmerFile.open();
%   myfile = ChiPerkinElmerFile.open(filename(s));
%
% Description
%   myfile = ChiPerkinElmerFile() creates an empty object.
% 
%   myfile = ChiPerkinElmerFile.open() opens a dialog box to request
%   filenames from the user. The selected files are opened and concatenated
%   into a ChiIRSpectrum, ChiIRSpectralCollection or ChiIRImage as
%   appropriate.
% 
%   myfile = ChiPerkinElmerFile.open(filenames) opens the filenames
%   provided in a cell array of strings.
%
%   This class can read one or more PerkinElmer spectral files (*.sp) or a
%   single PerkinElmer image file (*.fsm). If a single file containing a
%   spectrum is selected, then myfile is a ChiIRSpectrum. If multiple
%   spectral files are selected, then myfile is a ChiIRSpectralCollection.
%   If a single file containing an image is selected, then myfile is a
%   ChiMSImage. If multiple image files are selected, only first is read.
%
% Copyright (c) 2026, Alex Henderson.
% Licenced under the GNU General Public License (GPL) version 3.
%
% See also 
%   ChiIRSpectrum ChiIRSpectralCollection ChiIRImage.

% Contact email: alex.henderson@manchester.ac.uk
% Licenced under the GNU General Public License (GPL) version 3
% http://www.gnu.org/copyleft/gpl.html
% Other licensing options are available, please contact Alex for details
% If you use this file in your work, please acknowledge the author(s) in
% your publications. 

% Version 1.0, April 2026
% The latest version of this file is available at:
% https://github.com/AlexHenderson/ChiToolbox
    
    
    methods (Static)
        % ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
        function truefalse = isreadable(filename)
            if iscell(filename)
                filename = filename{1};
            end
            truefalse = false;
            % Check extension
            [pathstr,name,ext] = fileparts(filename); %#ok<ASGLU>
            if ~(strcmpi(ext,'.sp') || strcmpi(ext,'.fsm'))
                return
            end
            
            % Check internal magic numbers
            try 
                fid = fopen(filename, 'rt'); 
                PEPE = fgets(fid, 4);
                fclose(fid);
                if strcmp(PEPE, 'PEPE')
                    truefalse = true;
                end
            catch
                if fid
                    fclose(fid);
                end
            end
        end
        
        % ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
        function extn = getExtension()
            extn = '*.sp;*.fsm';
        end
        
        % ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
        function filter = getFiltername()
            filter = 'PerkinElmer Files (*.sp;*.fsm)';
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
                        {'*.sp;*.fsm',  'PerkinElmer Files (*.sp;*.fsm)'}, ...
                        {'*.sp',  'PerkinElmer Spectral Files (*.sp)'}, ...
                        {'*.fsm',  'PerkinElmer Image Files (*.fsm)'}));
            end
            
            % Make sure we have a cell array of filenames
            if ~iscell(filenames)
                filenames = cellstr(filenames);
            end
            
            % Check whether the files are OK for a PerkinElmer reader
            for i = 1:length(filenames) 
                if ~ChiPerkinElmerFile.isreadable(filenames{i})
                    message = sprintf('Filename %s is not a PerkinElmer file (*.sp/*.fsm).', utilities.pathescape(filenames{i}));
                    err = MException(['CHI:',mfilename,':InputError'], message);
                    throw(err);
                end
            end


            % Check we have either one or more spectral files, or a single
            % image file

            spectralfiles = false;
            imagefiles = false;
            for i = 1:length(filenames) 

                [filepath,name,ext] = fileparts(filenames{i}); %#ok<ASGLU>
                if strcmpi(ext, '.sp')
                    spectralfiles = true;
                end

                [filepath,name,ext] = fileparts(filenames{i}); %#ok<ASGLU>
                if strcmpi(ext, '.fsm')
                    imagefiles = true;
                end
            end

            if spectralfiles && imagefiles
                message = sprintf('Can''t process both spectral and image files at the same time.');
                err = MException(['CHI:',mfilename,':InputError'], message);
                throw(err);
            end


            % Open the file(s)
            if spectralfiles

                [wavenumbers,spectra,filenames,miscs] = perkinelmerspectra(filenames);

                if size(spectra,1) == 1
                    obj = ChiIRSpectrum(wavenumbers,spectra);
                else
                    obj = ChiIRSpectralCollection(wavenumbers,spectra);
                end

            else
                % We have one or more images
                if length(filenames) > 1
                    % We can read only a single image, so warn the user. 
                    warning('Only the first image file will be imported');
                end

                [imagedata,wavenumbers,width,height,totalimage,filename,miscs] = perkinelmerimage(filenames{1}); %#ok<ASGLU>
                obj = ChiIRImage(wavenumbers,imagedata,width,height);
            end
            
            obj.filenames = filenames;

            for i = 1:length(filenames)
                obj.history.add(['PerkinElmer file: ', filenames{i}]);
            end

            % ToDo: Check each spectrum to make sure they're all in
            % absorbance or percentage transmittance mode. Since this
            % leads to complications downstream, simply default to the
            % mode of the first spectrum or image. 
            loc = find(strcmpi(miscs{1,1}, 'yLabel'));
            if loc
                % We have a label, so it is not 'unknown'
                ylabel = miscs{1}{loc,2};
                if strcmpi(ylabel, '%T')
                    obj.yaxismode = ChiIRMode.percentage_transmittance;
                    obj.ylabelname = 'percentage transmittance';
                    obj.ylabelunit = '';
                else
                    % without an example file, assume absorbance
                    obj.yaxismode = ChiIRMode.absorbance;
                    obj.ylabelname = 'absorbance';
                    obj.ylabelunit = '';
                end
            end

            % Now check the x-axis label
            loc = find(strcmpi(miscs{1,1}, 'xLabel'));
            if loc
                % We have a label, so it is not 'unknown'
                misc_xlabel = miscs{1}{loc,2};
                if strcmpi(misc_xlabel, 'cm-1')
                    obj.xlabelname = 'wavenumber';
                    obj.xlabelunit = 'cm^{-1}';
                    obj.reversex = true;
                else
                    % assume absorbance, without an example file
                    obj.xlabelname = 'wavelength';
                    obj.xlabelunit = misc_xlabel;
                    obj.reversex = false;
                end
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
            obj = ChiPerkinElmerFile.open(varargin{:});
        end
            
        % ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
        function name = className()
            name = mfilename('class');
        end
    
        % ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    end
    
end
