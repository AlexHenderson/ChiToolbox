classdef ChiIonoptikaFile < handle

% ChiIonoptikaFile  File format handler for Ionoptika (.h5) files
%
% Syntax
%   myfile = ChiIonoptikaFile();
%   myfile = ChiIonoptikaFile.open();
%
% Description
%   myfile = ChiIonoptikaFile() creates an empty object.
% 
%   myfile = ChiIonoptikaFile.open() opens a dialog box to request filenames
%   from the user. The selected files are opened and concatenated into a
%   ChiToFMassSpectrum, ChiSpectralCollection or ChiImage as appropriate.
% 
%   This class can read Ionoptika h5 files (Windows version) (*.h5). 
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
                if ~strcmpi(ext,'.h5')
                    return
                end
                % Check internal magic numbers
                yesno = ChiIonoptikaFile.checkmagicnumbers(filenames{i});
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
                        {'*.h5', 'Ionoptika Files (*.h5)'}));

                if (isfloat(filenames) && (filenames == 0))
                    return;
                end
            end
            
            % Ensure filenames is a cell array
            if ~iscell(filenames)
                filenames = cellstr(filenames);
            end
            
            % Check whether the files are OK for a Ionoptika reader
            if ~ChiIonoptikaFile.isreadable(filenames)
                err = MException('CHI:ChiIonoptikaFile:InputError', ...
                    'Filenames do not appear to be Ionoptika files (*.h5).');
                throw(err);
            end
            
            % Open the file(s)
            if (length(filenames) == 1)
                [mass,data,height,width,layers,filename,x_label,y_label] = ionoptika_hd5file(filenames{1}); %#ok<ASGLU>
                
                obj = ChiImage(mass,data,false,x_label,y_label,width,height);
                obj.filename = filenames{1};
                obj.history.add(['filename: ', filenames{1}]);
            else
                utilities.warningnobacktrace('Can only handle a single file at the moment.');
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
            obj = ChiIonoptikaFile.read(varargin{:});
        end
            
        % ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
        function yesno = checkmagicnumbers(filename)
            yesno = true;   % Assume true for now
%             yesno = false;
%             
%             fid = fopen(filename);
%             if (fid == -1)
%                 return;
%             end
%             
%             status = fseek(fid, 0, 'bof');
%             if (status == -1)
%                 return;
%             end
%             detector_flag = fread(fid, 1, '*int32');
% 
%             switch detector_flag
%                 case 1408
%                     yesno = true;
%                 case 1034 
%                     yesno = true;
%             end
        end
            
        % ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    end
    
end
