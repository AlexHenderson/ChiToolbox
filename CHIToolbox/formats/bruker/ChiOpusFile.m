classdef ChiOpusFile < ChiHandle

% ChiOpusFile  File format handler for Bruker Opus files (*.0)
% 
% Syntax
%   myfile = ChiOpusFile();
%   myfile = ChiOpusFile.open();
%   myfile = ChiOpusFile.open(filenames);
%
% Description
%   myfile = ChiOpusFile() creates an empty object.
% 
%   myfile = ChiOpusFile.open() prompts the user for a filename. The
%   selected file is opened as a ChiSpectrum, ChiSpectralCollection or
%   ChiImage, as appropriate.
% 
%   myfile = ChiOpusFile.open(filenames) opens the files provided as a
%   char string, or cell array of char strings.
%
% Notes
%   Multiple raw files (*.0) can be selected. These will be concatenated
%   into a single ChiSpectralCollection. 
%
% Copyright (c) 2019, Alex Henderson.
% Licenced under the GNU General Public License (GPL) version 3.
%
% See also 
%   ChiBrukerFile ChiSpectrum ChiSpectralCollection ChiImage.

% Contact email: alex.henderson@manchester.ac.uk
% Licenced under the GNU General Public License (GPL) version 3
% http://www.gnu.org/copyleft/gpl.html
% Other licensing options are available, please contact Alex for details
% If you use this file in your work, please acknowledge the author(s) in
% your publications. 

% Version 1.0, January 2019
% The latest version of this file is available on Bitbucket
% https://bitbucket.org/AlexHenderson/chitoolbox

    
    methods(Static)
        function obj = ChiOpusFile(varargin)
            %CHIOPUSFILE Construct an instance of this class
        end
        % ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
        function truefalse = isreadable(filename)
            if iscell(filename)
                filename = filename{1};
            end
            
            truefalse = false;
            
            % Check extension
            [pathstr,name,ext] = fileparts(filename); %#ok<ASGLU>
            if ~strcmpi(ext,'.0')
                return
            end
            
            % Readability for Opus files
            if strcmpi(ext,'.0')
                % Bruker .0 files start with a magic number
                % 0A 0A FE FE
                try
                    fid = fopen(filename,'rb','ieee-le');
                    x = fread(fid, 1, 'uint8',0,'ieee-le');
                    if (x ~= 10)
                        return
                    end
                    x = fread(fid, 1, 'uint8',0,'ieee-le');
                    if (x ~= 10)
                        return
                    end
                    x = fread(fid, 1, 'uint8',0,'ieee-le');
                    if (x ~= 254)
                        return
                    end
                    x = fread(fid, 1, 'uint8',0,'ieee-le');
                    if (x ~= 254)
                        return
                    end
                catch
                    return
                end
            end
            
            % If we get to here, we consider the file to be readable. 
           truefalse = true; 
        end
        
        % ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
        function extn = getExtension()
            extn = '*.0';
        end
        
        % ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
        function filter = getFiltername()
            filter = 'Bruker Opus Files (*.0)';
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
                filenames = utilities.getfilenames({ChiOpusFile.getExtension(), ChiOpusFile.getFiltername()});
            end
            
            % Make sure we have a cell array of filenames
            if ~iscell(filenames)
                filenames = cellstr(filenames);
            end
            
            % Check whether the files are OK for a Bruker Opus reader
            for i = 1:length(filenames) 
                if ~ChiOpusFile.isreadable(filenames{i})
                    message = sprintf('Filename %s is not a Bruker Opus file (*.0). ', utilities.pathescape(filenames{i}));
                    err = MException(['CHI:',mfilename,':InputError'], message);
                    throw(err);
                end
            end
            
            % Open the file(s)
            if (length(filenames) == 1)
                [xvals,data,height,width,currentfilename,acqdate,xlabel,xunit,ylabel,yunit,datatype] = ChiOpusFileHandler(filenames{1}); %#ok<ASGLU>
                switch datatype
                    case 'spectrum'
                        obj = ChiIRSpectrum(xvals,data,true,xlabel,xunit,ylabel,yunit);
                    case 'spectralcollection'
                        obj = ChiIRSpectralCollection(xvals,data,true,xlabel,xunit,ylabel,yunit);                        
                    case 'image'
                        obj = ChiIRImage(xvals,data,width,height,true,xlabel,xunit,ylabel,yunit);
                    otherwise
                        message = sprintf('Unknown data type (spectrum/collection/image) in %s. ', utilities.pathescape(filenames{i}));
                        err = MException(['CHI:',mfilename,':InputError'], message);
                        throw(err);
                end
                        
            else
                % Need to manage multiple files
                for i = 1:length(filenames)
                    [xvals,data,height,width,currentfilename,acqdate,xlabel,xunit,ylabel,yunit,datatype] = ChiOpusFileHandler(filenames{i}); %#ok<ASGLU>
                    if (i == 1)
                        % Workaround for broken ChiSpectralCollection.append
                        obj = ChiIRSpectralCollection(xvals,data,true,xlabel,xunit,ylabel,yunit);                        
                    else
                        switch datatype
                            case 'spectrum'
                                obj.append(ChiIRSpectrum(xvals,data,true,xlabel,xunit,ylabel,yunit));
                            case 'spectralcollection'
                                obj.append(ChiIRSpectralCollection(xvals,data,true,xlabel,xunit,ylabel,yunit));
                            case 'image'
                                % Convert image to spectral collection
                                obj.append(ChiIRSpectralCollection(xvals,data,true,xlabel,xunit,ylabel,yunit));
                            otherwise
                                message = sprintf('Unknown data type (spectrum/collection/image) in %s. ', utilities.pathescape(filenames{i}));
                                err = MException(['CHI:',mfilename,':InputError'], message);
                                throw(err);
                        end
                    end
                end
            end
            
            obj.filenames = filenames;
            for i = 1:length(filenames)
                obj.history.add(['Bruker Opus file: ', filenames{i}]);
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
            obj = ChiOpusFile.open(varargin{:});
        end
        % ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
        
    end
end
