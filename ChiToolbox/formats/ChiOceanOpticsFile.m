classdef ChiOceanOpticsFile < ChiAbstractFileFormat

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
                filenames = utilities.getfilenames({ChiOceanOpticsFile.getExtension(), ChiOceanOpticsFile.getFiltername()});
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
            
            if (length(filenames) == 1)
                [xvals,data,info] = oceanopticstxtfile(filenames{1});

                datatype = 'spectrum';
                xlabel = '';
                xunit = [];
                ylabel = '';
                yunit = [];
                height = 1;
                width = 1;
                
                xaxisinfo = find(strcmpi(info(:,1),'XAxis mode'));
                if xaxisinfo
                    xlabel = info{xaxisinfo,2};
                    if strcmpi(xlabel, 'Wavelengths')   % hack
                        xlabel = 'wavelength';          % hack
                        xunit = 'nm';                   % hack
                    end
                end
                
                switch datatype
                    case 'spectrum'
                        obj = ChiSpectrum(xvals,data,false,xlabel,xunit,ylabel,yunit);
                    case 'spectralcollection'
                        obj = ChiSpectralCollection(xvals,data,false,xlabel,xunit,ylabel,yunit);                        
                    case 'image'
                        obj = ChiImage(xvals,data,width,height,false,xlabel,xunit,ylabel,yunit);
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
                        ylabel = '';
                        yunit = [];
                        height = 1;
                        width = 1;

                        xaxisinfo = find(strcmpi(info(:,1),'XAxis mode'));
                        if xaxisinfo
                            xlabel = info{xaxisinfo,2};
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
