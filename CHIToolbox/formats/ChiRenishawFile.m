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

% Version 3.0, August 2018
% The latest version of this file is available on Bitbucket
% https://bitbucket.org/AlexHenderson/chitoolbox
    
    
    methods (Static)
        % ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
        function truefalse = isreadable(filenames)

            % Ensure filenames is a cell array
            if ~iscell(filenames)
                filenames = cellstr(filenames);
            end
            
            truefalse = false;
            for i = 1:length(filenames)
                % Check extension
                [pathstr,name,ext] = fileparts(filenames{i}); %#ok<ASGLU>
                if ~strcmpi(ext,'.wdf')
                    return
                end
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
            if ~nargout
                stacktrace = dbstack;
                functionname = stacktrace.name;
                err = MException(['CHI:',mfilename,':InputError'], ...
                    'Nowhere to put the output. Try something like: myfile = %s(filename);',functionname);
                throw(err);
            end
            % If filename(s) are not provided, ask the user
            if ~exist('filenames', 'var') || isempty(filenames)
                filenames = utilities.getfilenames(vertcat(...
                        {'*.wdf', 'Renishaw Files (*.wdf)'}));

                if (isfloat(filenames) && (filenames == 0))
                    return;
                end
            end
            
            % Check whether the files are OK for a Renishaw reader
            if ~ChiRenishawFile.isreadable(filenames)
                err = MException('CHI:ChiRenishawFile:InputError', ...
                    'Filenames do not appear to be Renishaw files (*.wdf).');
                throw(err);
            end
            
            % Open the file(s)
            
            if (length(filenames) == 1)
                [ramanshift,data,height,width,filename,acqdate,x_label,y_label] = renishawWire(filenames{1},false); %#ok<ASGLU>
                if ((height == 1) && (width == 1))
                    % We have one or more spectra rather than an image
                    % Check to see if we have a single spectrum or a profile
                    if (numel(data) == numel(ramanshift))
                        obj = ChiRamanSpectrum(ramanshift,data);
                        obj.filename = filename;
                    else
                        obj = ChiRamanSpectralCollection(ramanshift,data);
                        obj.filenames = filenames;
                    end               
                else
                    obj = ChiRamanImage(ramanshift,data,width,height);
                    obj.filename = filename;
                end
                obj.history.add(['filename: ', filename]);
            else
                % Need to manage multiple files
                for i = 1:length(filenames)
                    [ramanshift,data,height,width,filename,acqdate,x_label,y_label] = renishawWire(filenames{i},false); %#ok<ASGLU>
                    
                    if (i == 1)
                        % Workaround for broken ChiSpectralCollection.append
                        obj = ChiRamanSpectralCollection(ramanshift,data);
                        obj.filenames = filenames;                        
                    else
                        if ((height == 1) && (width == 1))
                            % We have one or more spectra rather than an image
                            % Check to see if we have a single spectrum or a profile
                            if (numel(data) == numel(ramanshift))
                                obj.append(ChiRamanSpectrum(ramanshift,data));
                            else
                                obj.append(ChiRamanSpectralCollection(ramanshift,data));
                                obj.filenames = filenames;                                
                            end               
                        else
                            % An image
                            obj.append(ChiRamanSpectralCollection(ramanshift,data));
                            obj.filenames = filenames;                                
                        end
                    end
                end
                obj.history.add(['filename: ', filename]);
            end
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
            obj = ChiRenishawFile.open(varargin);
        end
            
        % ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
        function name = className()
            name = mfilename('class');
        end
    
        % ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    end
    
end
