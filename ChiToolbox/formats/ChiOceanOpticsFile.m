classdef ChiOceanOpticsFile < ChiAbstractFileFormat

% ChiOceanOpticsFile  File format handler for Ocean Optics spectra
%
% Syntax
%   myfile = ChiOceanOpticsFile();
%   myfile = ChiOceanOpticsFile.open();
%   myfile = ChiOceanOpticsFile.open(filename(s));
%
% Description
%   myfile = ChiOceanOpticsFile() creates an empty object.
% 
%   myfile = ChiOceanOpticsFile.open() opens a dialog box to request
%   filenames from the user. The selected files are opened and concatenated
%   into a ChiSpectrum or ChiSpectralCollection.
% 
%   myfile = ChiOceanOpticsFile.open(filenames) opens the filenames
%   provided in a cell array of strings.
%
% Copyright (c) 2020, Alex Henderson.
% Licenced under the GNU General Public License (GPL) version 3.
%
% See also 
%   ChiSpectrum ChiSpectralCollection.

% Contact email: alex.henderson@manchester.ac.uk
% Licenced under the GNU General Public License (GPL) version 3
% http://www.gnu.org/copyleft/gpl.html
% Other licensing options are available, please contact Alex for details
% If you use this file in your work, please acknowledge the author(s) in
% your publications. 

% Version 1.0, May 2020
% The latest version of this file is available on Bitbucket
% https://bitbucket.org/AlexHenderson/chitoolbox
    
    
    methods (Static)
        % ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
        function truefalse = isreadable(filename)
            
%             ###########################################################
            truefalse = false;
%             return;
%             ###########################################################
            
            if iscell(filename)
                filename = filename{1};
            end
            % Check extension
            [pathstr,name,ext] = fileparts(filename); %#ok<ASGLU>
            if ~strcmpi(ext,'.txt')
                return
            end
            % ToDo: Check internal magic numbers
            truefalse = true;
        end
        
        % ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
        function extn = getExtension()
            extn = '*.txt';
        end
        
        % ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
        function filter = getFiltername()
            filter = 'Ocean Optics Files (*.txt)';
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
                filenames = utilities.getfilenames( ...
                        {'*.txt',  'Ocean Optics Files (*.txt)'});
            end
            
            % Make sure we have a cell array of filenames
            if ~iscell(filenames)
                filenames = cellstr(filenames);
            end
            
            % Check whether the files are OK for this reader
            for i = 1:length(filenames) 
                if ~ChiOceanOpticsFile.isreadable(filenames{i})
                    message = sprintf('Filename %s is not an Ocean Optics file (*.txt).', utilities.pathescape(filenames{i}));
                    err = MException(['CHI:',mfilename,':InputError'], message);
                    throw(err);
                end
            end
            
            % Open the file(s)
            fileisreadable = true(length(filenames),1);
            
            % A single file
            if (length(filenames) == 1)
                
                [filepath,name,ext] = fileparts(filenames{1}); %#ok<ASGLU>
                xlabel = '';
                xunit = [];
                ylabel = 'Intensity';   % Taken from the OceanView 2.0 on-screen display
                yunit = 'counts';       % Taken from the OceanView 2.0 on-screen display
                height = 1;
                width = 1;

                switch ext
                    case '.txt'
                        [xvals,data,info] = oceanopticstxtfile(filenames{1});
                        datatype = 'spectrum';

                        xaxisinfo = find(strcmpi(info(:,1),'XAxis mode'));
                        if xaxisinfo
                            xlabel = info{xaxisinfo,2};
                            if strcmpi(xlabel, 'Wavelengths')   % hack
                                xlabel = 'wavelength';          % Taken from the OceanView 2.0 on-screen display
                                xunit = 'nm';                   % Taken from the OceanView 2.0 on-screen display
                            end
                        end
                    otherwise
                        message = sprintf('Unknown data type (spectrum/collection/image) in %s. ', utilities.pathescape(filenames{i}));
                        err = MException(['CHI:',mfilename,':InputError'], message);
                        throw(err);
                end
                
                switch datatype
                    case 'spectrum'
                        obj = ChiSpectrum(xvals,data,false,xlabel,xunit,ylabel,yunit);
                    case 'spectralcollection'
                        obj = ChiSpectralCollection(xvals,data,false,xlabel,xunit,ylabel,yunit);                        
                    otherwise
                        message = sprintf('Unknown data type (spectrum/collection/image) in %s. ', utilities.pathescape(filenames{i}));
                        err = MException(['CHI:',mfilename,':InputError'], message);
                        throw(err);
                end
                        
            else
                % Need to manage multiple files
                for i = 1:length(filenames)
                    try
                        [xvals,data,info] = oceanopticstxtfile(filenames{i});

                        datatype = 'spectrum';
                        xlabel = '';
                        xunit = [];
                        ylabel = 'Intensity';   % Taken from the OceanView 2.0 on-screen display
                        yunit = 'counts';       % Taken from the OceanView 2.0 on-screen display
                        height = 1;
                        width = 1;

                        xaxisinfo = find(strcmpi(info(:,1),'XAxis mode'));
                        if xaxisinfo
                            xlabel = info{xaxisinfo,2};
                            if strcmpi(xlabel, 'Wavelengths')   % hack
                                xlabel = 'wavelength';          % Taken from the OceanView 2.0 on-screen display
                                xunit = 'nm';                   % Taken from the OceanView 2.0 on-screen display
                            end
                        end
                        
                        
                        if (i == 1)
                            % Workaround for broken ChiSpectralCollection.append
                            obj = ChiSpectralCollection(xvals,data,false,xlabel,xunit,ylabel,yunit);                        
                        else
                            switch datatype
                                case 'spectrum'
                                    obj.append(ChiSpectrum(xvals,data,false,xlabel,xunit,ylabel,yunit));
                                case 'spectralcollection'
                                    obj.append(ChiSpectralCollection(xvals,data,false,xlabel,xunit,ylabel,yunit));
                                case 'image'
                                    % Convert image to spectral collection
                                    obj.append(ChiSpectralCollection(xvals,data,false,xlabel,xunit,ylabel,yunit));
                                otherwise
                                    message = sprintf('Unknown data type (spectrum/collection/image) in %s. ', utilities.pathescape(filenames{i}));
                                    err = MException(['CHI:',mfilename,':InputError'], message);
                                    throw(err);
                            end
                        end
                        
                    catch ex %#ok<NASGU>
                        utilities.warningnobacktrace(['Cannot read this file: ', filenames{i}, ' Ignoring.']);
                        fileisreadable(i) = false;
                    end
                end
            end
            obj.filenames = filenames;
            
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
            obj = ChiOceanOpticsFile.open(varargin{:});
        end
            
        % ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
        function name = className()
            name = mfilename('class');
        end
    
        % ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    end
    
end
