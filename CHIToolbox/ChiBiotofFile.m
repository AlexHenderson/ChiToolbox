classdef ChiBiotofFile < handle

% ChiBiotofFile  File format handler for Biotof (.dat) files
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
%   ChiToFMassSpectrum, ChiSpectralCollection or ChiImage as appropriate.
% 
%   myfile = ChiBiotofFile.open(filenames) opens the filenames provided in
%   a cell array of strings.
%
%   This class can read Biotof spectrum files (Windows version) (*.dat). 
%
% Copyright (c) 2017, Alex Henderson.
% Licenced under the GNU General Public License (GPL) version 3.
%
% See also 
%   ChiToFMassSpectrum ChiSpectrum ChiSpectralCollection ChiImage.

% Contact email: alex.henderson@manchester.ac.uk
% Licenced under the GNU General Public License (GPL) version 3
% http://www.gnu.org/copyleft/gpl.html
% Other licensing options are available, please contact Alex for details
% If you use this file in your work, please acknowledge the author(s) in
% your publications. 

% Version 1.0, August 2017
% The latest version of this file is available on Bitbucket
% https://bitbucket.org/AlexHenderson/chitoolbox
    
    
    methods (Static)
        % ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
        function yesno = isreadable(filenames)

            % Ensure filenames is a cell array
            if ~iscell(filenames)
                filenames = cellstr(filenames);
            end
            
            yesno = false;
            for i = 1:length(filenames)
                % Check extension
                [pathstr,name,ext] = fileparts(filenames{i}); %#ok<ASGLU>
                if ~strcmpi(ext,'.dat')
                    return
                end
                % Check internal magic numbers
                yesno = ChiBiotofFile.checkmagicnumbers(filenames{i});
            end
            
        end
        
        % ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
        function obj = read(filenames)
            if ~nargout
                stacktrace = dbstack;
                functionname = stacktrace.name;
                err = MException(['CHI:',mfilename,':InputError'], ...
                    'Nowhere to put the output. Try something like: myfile = %s(filename);',functionname);
                throw(err);
            end
            % If filename(s) are not provided, ask the user
            if ~exist('filenames', 'var')
                filenames = utilities.getfilenames(vertcat(...
                        {'*.dat', 'Biotof Spectrum Files (*.dat)'}));

                if (isfloat(filenames) && (filenames == 0))
                    return;
                end
            end
            
            % Ensure filenames is a cell array
            if ~iscell(filenames)
                filenames = cellstr(filenames);
            end
            
            % Check whether the files are OK for a Biotof reader
            if ~ChiBiotofFile.isreadable(filenames)
                err = MException('CHI:ChiBiotofFile:InputError', ...
                    'Filenames do not appear to be Biotof files (*.dat).');
                throw(err);
            end
            
            % Open the file(s)
            if (length(filenames) == 1)
                [mass,data,parameters] = biotofspectrum(filenames{1}); %#ok<ASGLU>
                
                % temp placeholders until we can read XYT files
                height = 1;
                width = 1;
                x_label = 'm/z (amu)';
                y_label = 'intensity';
                
                if ((height == 1) && (width == 1))
                    % We have one or more spectra rather than an image
                    % Check to see if we have a single spectrum or a profile
                    if (numel(data) == numel(mass))
                        obj = ChiToFMassSpectrum(mass,data);
                        obj.filename = filenames{1};
                    else
                        obj = ChiToFMassSpectralCollection(mass,data,false,x_label,y_label);
                    end               
                else
                    obj = ChiImage(mass,data,false,x_label,y_label,width,height);
                    obj.filename = filenames{1};
                end
                obj.history.add(['filename: ', filenames{1}]);
            else
                % Need to manage multiple files
                for i = 1:length(filenames)
                    [mass,data,parameters] = biotofspectrum(filenames{i}); %#ok<ASGLU>
                    mass = ChiForceToRow(mass);
                    data = ChiForceToRow(data);
                    height = 1;
                    width = 1;
                    x_label = 'm/z';
                    y_label = 'intensity';
                    filename = filenames{i};
                    
                    if (i == 1)
                        % Workaround for broken ChiSpectralCollection.append
                        temp = ChiToFMassSpectrum(mass,data,false,x_label,y_label);
                        obj = ChiToFMassSpectralCollection(temp);
%                         obj = ChiToFMassSpectralCollection(mass,data,false,x_label,y_label);
                    else
                        if ((height == 1) && (width == 1))
                            % We have one or more spectra rather than an image
                            % Check to see if we have a single spectrum or a profile
                            if (numel(data) == numel(mass))
                                obj.append(ChiToFMassSpectrum(mass,data));
                            else
                                obj.append(ChiToFMassSpectralCollection(mass,data,false,x_label,y_label));
                            end               
                        else
                            % An image
                            obj.append(ChiToFMassSpectralCollection(mass,data,false,x_label,y_label));
                        end
                    end
                end
                obj.history.add(['filename: ', filename]);
            end
        end        
        
        % ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
        function obj = open(varargin)
            if ~nargout
                stacktrace = dbstack;
                functionname = stacktrace.name;
                err = MException(['CHI:',mfilename,':InputError'], ...
                    'Nowhere to put the output. Try something like: myfile = %s(filename);',functionname);
                throw(err);
            end
            obj = ChiBiotofFile.read(varargin{:});
        end
            
        % ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
        function yesno = checkmagicnumbers(filename)
            yesno = false;
            
            fid = fopen(filename);
            if (fid == -1)
                return;
            end
            
            status = fseek(fid, 0, 'bof');
            if (status == -1)
                return;
            end
            detector_flag = fread(fid, 1, '*int32');

            switch detector_flag
                case 1408
                    yesno = true;
                case 1034 
                    yesno = true;
            end
        end
            
        % ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    end
    
end
