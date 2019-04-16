classdef ChiOpusFile < ChiBase

% ChiOpusFile  File format handler for Bruker Opus files (*.??? where ??? is a number)
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
%   Multiple Opus files can be selected. These will be concatenated into a
%   single ChiSpectralCollection.
%   The Open Files dialog only suggests files up to *.10
%   (.0,.1,.2,.3,.4,.5,.6,.7,.8,.9,.10). If files with extensions higher
%   than that are required, use the All Files (*.*) filter.
%   Some Opus files do not contain spectra. If one of these is selected a
%   warning is issued and the file is ignored. 
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
            
            % Check extension - should be a number
            [pathstr,name,ext] = fileparts(filename); %#ok<ASGLU>
            extnum = str2num(ext(2:end)); %#ok<ST2NM>
            if (isempty(extnum) || ~isnumeric(extnum))
                return
            end
            
            % Readability for Opus files
            % Bruker files start with a magic number
            % 0A 0A FE FE
            try
                fid = fopen(filename,'rb','ieee-le');
                if (fid == -1)
                    message = ['File not found: ', utilities.escapestring(filename)];
                    err = MException(['CHI:',mfilename,':IOError'], ...
                        message);
                    throw(err);
                end
                    
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
                fclose(fid);
            catch ex
                if exists('fid','var')
                    fclose(fid);
                    clear fid;
                end
                truefalse = false;
                rethrow(ex);
            end
            
            % If we get to here, we consider the file to be readable. 
           truefalse = true; 
        end
        
        % ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
        function extn = getExtension()
            extn = '*.0;*.1;*.2;*.3;*.4;*.5;*.6;*.7;*.8;*.9;*.10';
        end
        
        % ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
        function filter = getFiltername()
            filter = 'Bruker Opus Files (*.???) where ??? is a number';
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
                    message = sprintf('Filename %s is not a Bruker Opus file (*.???) where ??? is a number. ', utilities.pathescape(filenames{i}));
                    err = MException(['CHI:',mfilename,':InputError'], message);
                    throw(err);
                end
            end
            
            % Open the file(s)
            fileisreadable = true(length(filenames),1);
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
                    try
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
                    catch ex %#ok<NASGU>
                        utilities.warningnobacktrace(['Cannot read this file: ', filenames{i}, ' Ignoring.']);
                        fileisreadable(i) = false;
                    end

                end
            end
            
            obj.filenames = filenames(fileisreadable);
            for i = 1:length(filenames)
                if fileisreadable(i)
                    obj.history.add(['Bruker Opus file: ', filenames{i}]);
                else
                    obj.history.add(['Ignored (could not read) file: ', filenames{i}]);
                end                    
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
