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
% 
%   myfile = ChiPhotothermalFile.open(filenames) opens the filenames
%   provided in a cell array of strings.
%
% Notes
%   Temporarily this class will read an IR image of raw data. If an edited
%   file is opened (one where the image was copied into a new workspace)
%   only the first spectrum will be opened. Currently Raman data is not
%   supported (nor a range of other options!)
% 
%   This class can read Photothermal files (*.ptir). The file format has
%   the capacity to hold different types of information. If a single file
%   containing a single spectrum is selected, then myfile is a ChiSpectrum.
%   If a single file containing multiple spectra is selected, then myfile
%   is a ChiSpectralCollection. If a single file containing an image is
%   selected, then myfile is a ChiImage. If multiple files are selected,
%   then these are combined into a ChiSpectralCollection. If any of these
%   contain images, the pixels are unfolded and combined into a
%   ChiSpectralCollection.
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

% Version 1.0, August 2019
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
            
            % Open the file(s)
            if (length(filenames) == 1)
                [xvals,data,height,width,filename,xlabel,xunit,ylabel,yunit,datatype] = photothermal_ptir(filenames{1}); %#ok<ASGLU>
                if ((height == 1) && (width == 1))
                    % We have one or more spectra rather than an image
                    % Check to see if we have a single spectrum or a profile
                    if (numel(data) == numel(xvals))
                        obj = ChiIRSpectrum(xvals,data,true,xlabel,xunit,ylabel,yunit);
                    else
                        obj = ChiIRSpectralCollection(xvals,data,true,xlabel,xunit,ylabel,yunit);
                    end               
                else
                    obj = ChiIRImage(xvals,data,height,width,true,xlabel,xunit,ylabel,yunit);
                end
            else
                % Need to manage multiple files
                for i = 1:length(filenames)
                    [xvals,data,height,width,filename,xlabel,xunit,ylabel,yunit,datatype] = photothermal_ptir(filenames{1}); %#ok<ASGLU>
                    
                    if (i == 1)
                        % Workaround for broken ChiSpectralCollection.append
                        obj = ChiIRSpectralCollection(xvals,data,true,xlabel,xunit,ylabel,yunit);
                    else
                        if ((height == 1) && (width == 1))
                            % We have one or more spectra rather than an image
                            % Check to see if we have a single spectrum or a profile
                            if (numel(data) == numel(xvals))
                                obj.append(ChiIRSpectrum(xvals,data,true,xlabel,xunit,ylabel,yunit));
                            else
                                obj.append(ChiIRSpectralCollection(xvals,data,true,xlabel,xunit,ylabel,yunit));
                            end               
                        else
                            % An image
                            obj.append(ChiIRSpectralCollection(xvals,data,true,xlabel,xunit,ylabel,yunit));
                        end
                    end
                end
            end
            
            obj.filenames = filenames;
            for i = 1:length(filenames)
                obj.history.add(['Photothermal file: ', filenames{i}]);
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
            obj = ChiPhotothermalFile.open(varargin{:});
        end
            
        % ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
        function name = className()
            name = mfilename('class');
        end
    
        % ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    end
    
end
