classdef ChiPhotothermalFile < ChiAbstractFileFormat

% ChiPhotothermalFile  File format handler for Photothermal (.ptir) files
%
% Syntax
%   myfile = ChiPhotothermalFile();
%   myfile = ChiPhotothermalFile.open();
%   myfile = ChiPhotothermalFile.open(filename(s));
%
% Description
%   myfile = ChiPhotothermalFile() creates an empty object.
% 
%   myfile = ChiPhotothermalFile.open() opens a dialog box to request
%   filenames from the user. The selected files are opened and concatenated
%   into a ChiSpectrum, ChiSpectralCollection or ChiImage as appropriate.
%   If multiple files, or any file contains multipe measurements, a cell
%   array of Chi* objects is returned. 
% 
%   myfile = ChiPhotothermalFile.open(filenames) opens the filenames
%   provided in a cell array of strings. If multiple files, or any file
%   contains multipe measurements, a cell array of Chi* objects is
%   returned.
%
% Notes
%   This class can read Photothermal files (*.ptir). The file format has
%   the capacity to hold different types of information (IR or Raman). If
%   multiple files are opened, or if any of the files contains multiple
%   measurements, a cell array of Chi* objects is returned. 
%
% Copyright (c) 2019, Alex Henderson.
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

% Version 2.0, September 2019
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
            if ~strcmpi(ext,'.ptir')
                return
            end
            % ToDo: Check internal magic numbers
            truefalse = true;
        end
        
        % ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
        function extn = getExtension()
            extn = '*.ptir';
        end
        
        % ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
        function filter = getFiltername()
            filter = 'Photothermal Files (*.ptir)';
        end
        
        % ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
        function output = open(filenames)
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
                filenames = utilities.getfilenames({ChiPhotothermalFile.getExtension(), ChiPhotothermalFile.getFiltername()});
            end
            
            % Make sure we have a cell array of filenames
            if ~iscell(filenames)
                filenames = cellstr(filenames);
            end
            
            % Check whether the files are OK for a Photothermal reader
            for i = 1:length(filenames) 
                if ~ChiPhotothermalFile.isreadable(filenames{i})
                    message = sprintf('Filename %s is not a Photothermal file (*.ptir).', utilities.pathescape(filenames{i}));
                    err = MException(['CHI:',mfilename,':InputError'], message);
                    throw(err);
                end
            end

            % Define somewhere to put the output. This is a cell array with
            % the first column being the filenames. Then, each subsequent
            % column contains the various data sets within each file. A
            % single file can contain one or more image, spectrum, camera
            % picture, single wavenumber image. These can be in IR, Raman
            % or an IR background.             
            output = {};
            
            % Open the file(s)
            % Identify if the data format is an image, a spectrum or a
            % spectral collection, then work out whether we have IR or
            % Raman data. If it's a camera image, or a single wavenumber IR
            % image, we just push that straight through to the output cell
            % array.
            for i = 1:length(filenames)
                % First record the filename on a new row (column 1)
                output{end+1,1} = filenames{i}; %#ok<AGROW>
                filecontents = photothermal_ptir(filenames{i});
                for j = 1:length(filecontents)
                    fc = filecontents{j};
                    
                    % Identify the first available slot in this row. We
                    % need this since there may be a previous file with
                    % multiple data sets and therefore the current row will
                    % contain a series of empty cells. 
                    freeslot = utilities.findemptycell(output,i);
                    
                    % If the contents is a Heatmap, or Camera object,
                    % simply store the output. Otherwise generate a Chi
                    % object of the correct type and store that. 
                    if (isa(fc,'ChiPicture') || isa(fc,'ChiImageFile'))
                        output{i,freeslot} = fc; 
                    else
                        if (ndims(fc.data) == 3)
                            % We have an image
                            switch fc.datatype
                                case 'Infrared'
                                    % We have IR data
                                    reversex = true;
                                    obj = ChiIRImage(fc.xvals,fc.data, ...
                                    fc.width,fc.height,reversex, ...
                                    fc.xlabel,fc.xunit,fc.ylabel,fc.yunit);
                                case 'Background'
                                    % We have IR data
                                    reversex = true;
                                    obj = ChiIRImage(fc.xvals,fc.data, ...
                                    fc.width,fc.height,reversex, ...
                                    fc.xlabel,fc.xunit,fc.ylabel,fc.yunit);
                                case 'Raman'
                                    % We have Raman data
                                    reversex = (fc.xvals(end) < fc.xvals(1));
                                    obj = ChiRamanImage(fc.xvals,fc.data, ...
                                    fc.width,fc.height,reversex, ...
                                    fc.xlabel,fc.xunit,fc.ylabel,fc.yunit);
                                otherwise
                                    message = ['Unrecognised data type: ',fc.datatype];
                                    err = MException(['CHI:',mfilename,':InputError'], message);
                                    throw(err);
                            end
                        else
                            if isvector(fc.data)
                                % We have a spectrum
                                switch fc.datatype
                                    case 'Infrared'
                                        % We have IR data
                                        reversex = true;
                                        obj = ChiIRSpectrum(fc.xvals,fc.data, ...
                                        reversex, ...
                                        fc.xlabel,fc.xunit,fc.ylabel,fc.yunit);
                                    case 'Background'
                                        % We have IR data
                                        reversex = true;
                                        obj = ChiIRSpectrum(fc.xvals,fc.data, ...
                                        reversex, ...
                                        fc.xlabel,fc.xunit,fc.ylabel,fc.yunit);
                                    case 'Raman'
                                        % We have Raman data
                                        reversex = (fc.xvals(end) < fc.xvals(1));
                                        obj = ChiRamanSpectrum(fc.xvals,fc.data, ...
                                        reversex, ...
                                        fc.xlabel,fc.xunit,fc.ylabel,fc.yunit);
                                    otherwise
                                        % Not sure of the data type
                                        message = ['Unrecognised data type: ',fc.datatype];
                                        err = MException(['CHI:',mfilename,':InputError'], message);
                                        throw(err);
                                end
                            else
                                % We have a spectral collection
                                switch fc.ylabel(1)
                                    case 'Infrared'
                                        % We have IR data
                                        reversex = true;
                                        obj = ChiIRSpectralCollection(fc.xvals,fc.data, ...
                                        reversex, ...
                                        fc.xlabel,fc.xunit,fc.ylabel,fc.yunit);
                                    case 'Background'
                                        % We have IR data
                                        reversex = true;
                                        obj = ChiIRSpectralCollection(fc.xvals,fc.data, ...
                                        reversex, ...
                                        fc.xlabel,fc.xunit,fc.ylabel,fc.yunit);
                                    case 'Raman'
                                        % We have Raman data
                                        reversex = (fc.xvals(end) < fc.xvals(1));
                                        obj = ChiRamanSpectralCollection(fc.xvals,fc.data, ...
                                        reversex, ...
                                        fc.xlabel,fc.xunit,fc.ylabel,fc.yunit);
                                    otherwise
                                        % Not sure of the data type
                                        message = ['Unrecognised data type: ',fc.datatype];
                                        err = MException(['CHI:',mfilename,':InputError'], message);
                                        throw(err);
                                end
                            end
                        end
                        obj.filenames = filenames(i);
                        obj.history.add(['Photothermal file: ', filenames{i}]);
                        obj.history.add(['Data label: ', fc.measurementlabel]);
                        output{i,freeslot} = obj;
                    end
                end
            end
%             [rows,cols] = size(output); % Actually never happens since we store the filename
%             if (rows == cols == 1)
%                 output = output{1};
%             end
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
            obj = ChiPhotothermalFile.open(varargin{:});
        end
            
        % ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
        function name = className()
            name = mfilename('class');
        end
    
        % ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    end
    
end

