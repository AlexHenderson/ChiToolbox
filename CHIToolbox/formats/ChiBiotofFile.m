classdef ChiBiotofFile < ChiAbstractFileFormat

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
%   ChiToFMassSpectrum, ChiToFMassSpectralCollection or ChiImage as appropriate.
% 
%   myfile = ChiBiotofFile.open(filenames) opens the filenames provided in
%   a cell array of strings.
%
%   This class can read one or more Biotof spectral files (*.dat) or a
%   single Biotof image file (*.xyt). The file format has the capacity to
%   hold different types of information. If a single file containing a
%   spectrum is selected, then myfile is a ChiToFMassSpectrum. If multiple
%   spectral files are selected, then myfile is a
%   ChiToFMassSpectralCollection. If a single file containing an image is
%   selected, then myfile is a ChiImage. If multiple image files are
%   selected, only first is read.
%
% Copyright (c) 2018, Alex Henderson.
% Licenced under the GNU General Public License (GPL) version 3.
%
% See also 
%   ChiToFMassSpectrum ChiToFMassSpectralCollection ChiSpectrum ChiSpectralCollection ChiImage.

% Contact email: alex.henderson@manchester.ac.uk
% Licenced under the GNU General Public License (GPL) version 3
% http://www.gnu.org/copyleft/gpl.html
% Other licensing options are available, please contact Alex for details
% If you use this file in your work, please acknowledge the author(s) in
% your publications. 

% Version 2.0, August 2018
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
                if ~(strcmpi(ext,'.dat') || strcmpi(ext,'.xyt'))
                    return
                end
            end
            % ToDo: Check internal magic numbers
            truefalse = true;
        end
        
        % ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
        function extn = getExtension()
            extn = '*.dat;*.xyt';
        end
        
        % ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
        function filter = getFiltername()
            filter = 'Biotof Files (*.dat;*.xyt)';
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
            
            % Let another function handle reading the files
            if exist('filenames', 'var') && ~isempty(filenames)
                [mass, data, height, width] = biotofFile(filenames);
            else
                [mass, data, height, width, filenames] = biotofFile();
            end
                
%             % Check whether the files are OK for a Biotof reader
%             if ~ChiBiotofFile.isreadable(filenames)
%                 err = MException('CHI:ChiBiotofFile:InputError', ...
%                     'Filenames do not appear to be Biotof files (*.dat|*.xyt).');
%                 throw(err);
%             end
            
            x_label = 'm/z';
            y_label = 'counts';
            
            if ((height == 1) && (width == 1))
                % We have one or more spectra rather than an image
                % Check to see if we have a single spectrum or a profile
                if (numel(data) == numel(mass))
                    obj = ChiToFMassSpectrum(mass,data);
                    obj.filename = filenames;
                else
                    obj = ChiToFMassSpectralCollection(mass,data);
                    obj.filenames = filenames;
                end               
            else
                % ToDo: convert to ToF image
                obj = ChiMassSpecImage(mass,data,false,x_label,y_label,width,height);
                obj.filename = filenames;
            end
            for i = 1:size(filenames,1)
                if iscell(filenames)
                    obj.history.add(['filename: ', filenames{i}]);
                else
                    obj.history.add(['filename: ', filenames(i)]);
                end
            end
                
        end     % function open
        
        % ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
        function obj = read(varargin)
            if ~nargout
                stacktrace = dbstack;
                functionname = stacktrace.name;
                err = MException(['CHI:',mfilename,':InputError'], ...
                    'Nowhere to put the output. Try something like: myfile = %s(filename);',functionname);
                throw(err);
            end
            obj = ChiBiotofFile.open(varargin);
        end
            
        % ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
        function name = className()
            name = mfilename('class');
        end
    
        % ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    end
    
end