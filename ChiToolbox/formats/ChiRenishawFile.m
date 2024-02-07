classdef ChiRenishawFile < ChiAbstractFileFormat

% ChiRenishawFile  File format handler for Renishaw (.wdf) files
%
% Syntax
%   myfile = ChiRenishawFile();
%   myfile = ChiRenishawFile.open();
%   myfile = ChiRenishawFile.open(filename(s));
%
% Description
%   myfile = ChiRenishawFile() creates an empty object.
% 
%   myfile = ChiRenishawFile.open() opens a dialog box to request filenames
%   from the user. The selected files are opened and concatenated into a
%   ChiSpectrum, ChiSpectralCollection or ChiImage as appropriate.
% 
%   myfile = ChiRenishawFile.open(filenames) opens the filenames provided in
%   a cell array of strings.
%
%   This class can read Renishaw WiRE version 4 files (*.wdf). The file
%   format has the capacity to hold different types of information. If a
%   single file containing a single spectrum is selected, then myfile is a
%   ChiSpectrum. If a single file containing multiple spectra is selected,
%   then myfile is a ChiSpectralCollection. If a single file containing an
%   image is selected, then myfile is a ChiImage. If multiple files are
%   selected, then these are combined into a ChiSpectralCollection. If any
%   of these contain images, the pixels are unfolded and combined into a
%   ChiSpectralCollection.
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

% Version 4.0, September 2018
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
            if ~strcmpi(ext,'.wdf')
                return
            end
            % ToDo: Check internal magic numbers
            truefalse = true;
        end
        
        % ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
        function extn = getExtension()
            extn = '*.wdf';
        end
        
        % ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
        function filter = getFiltername()
            filter = 'Renishaw Files (*.wdf)';
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
                filenames = utilities.getfilenames({ChiRenishawFile.getExtension(), ChiRenishawFile.getFiltername()});
            end
            
            % Make sure we have a cell array of filenames
            if ~iscell(filenames)
                filenames = cellstr(filenames);
            end
            
            % Check whether the files are OK for a Renishaw reader
            for i = 1:length(filenames) 
                if ~ChiRenishawFile.isreadable(filenames{i})
                    message = sprintf('Filename %s is not a Renishaw file (*.wdf).', utilities.pathescape(filenames{i}));
                    err = MException(['CHI:',mfilename,':InputError'], message);
                    throw(err);
                end
            end
            
            % Open the file(s)
            if (length(filenames) == 1)
                [ramanshift,data,height,width,filename,acqdate,x_label,y_label] = renishawWire(filenames{1},false); %#ok<ASGLU>
                if ((height == 1) && (width == 1))
                    % We have one or more spectra rather than an image
                    % Check to see if we have a single spectrum or a profile
                    if (numel(data) == numel(ramanshift))
                        obj = ChiRamanSpectrum(ramanshift,data);
                    else
                        obj = ChiRamanSpectralCollection(ramanshift,data);
                    end               
                else
                    obj = ChiRamanImage(ramanshift,data,width,height);
                end
            else
                % Need to manage multiple files
                for i = 1:length(filenames)
                    [ramanshift,data,height,width,filename,acqdate,x_label,y_label] = renishawWire(filenames{i},false); %#ok<ASGLU>
                    
                    if (i == 1)
                        % Workaround for broken ChiSpectralCollection.append
                        obj = ChiRamanSpectralCollection(ramanshift,data);
                    else
                        if ((height == 1) && (width == 1))
                            % We have one or more spectra rather than an image
                            % Check to see if we have a single spectrum or a profile
                            if (numel(data) == numel(ramanshift))
                                obj.append(ChiRamanSpectrum(ramanshift,data));
                            else
                                obj.append(ChiRamanSpectralCollection(ramanshift,data));
                            end               
                        else
                            % An image
                            obj.append(ChiRamanSpectralCollection(ramanshift,data));
                        end
                    end
                end
            end
            
            obj.filenames = filenames;
            for i = 1:length(filenames)
                obj.history.add(['Renishaw file: ', filenames{i}]);
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
            obj = ChiRenishawFile.open(varargin{:});
        end
            
        % ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
        function name = className()
            name = mfilename('class');
        end
    
        % ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    end
    
end
