classdef ChiMettlerToledoFile < ChiAbstractFileFormat

%     not finished
    
% ChiMettlerToledoFile  File format handler for Mettler Toledo / Applied Systems spectral files
%
% Syntax
%   myfile = ChiMettlerToledoFile();
%   myfile = ChiMettlerToledoFile.open();
%   myfile = ChiMettlerToledoFile.open(filename(s));
%
% Description
%   myfile = ChiMettlerToledoFile() creates an empty object.
% 
%   myfile = ChiMettlerToledoFile.open() opens a dialog box to request
%   filenames from the user. The selected files are opened and concatenated
%   into a ChiSpectrum or ChiSpectralCollection as appropriate.
% 
%   myfile = ChiMettlerToledoFile.open(filenames) opens the filenames
%   provided in a cell array of strings.
%
%   This class can read one or more Mettler Toledo / Applied Systems
%   spectral files (*.asc). If a single file containing a spectrum is
%   selected, then myfile is a ChiSpectrum. If multiple spectral files are
%   selected, then myfile is a ChiSpectralCollection.
%
% Copyright (c) 2018, Alex Henderson.
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

% Version 1.0, April 2018
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
                if ~strcmpi(ext,'.asc')
                    return
                end
            end
            % ToDo: Check internal magic numbers
            truefalse = true;
        end
        
        % ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
        function extn = getExtension()
            extn = '*.asc';
        end
        
        % ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
        function filter = getFiltername()
            filter = 'Mettler Toledo ASCII Files (*.asc)';
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
            if exist('filenames', 'var')
                [xvals,data,unused,header,x_label,y_label] = mettlertoledofiles(filenames); %#ok<ASGLU>
            else
                [xvals,data,filenames,header,x_label,y_label] = mettlertoledofiles(); %#ok<ASGLU>
            end
                
%             % Check whether the files are OK for this reader
%             if ~ChiMettlerToledoFile.isreadable(filenames)
%                 err = MException(['CHI:',mfilename,':InputError'], ...
%                     'Filenames do not appear to be Mettler Toledo text files (*.asc).');
%                 throw(err);
%             end

            % defaults
            height = 1;
            width = 1;
            
            if ((height == 1) && (width == 1))
                % We have one or more spectra rather than an image
                % Check to see if we have a single spectrum or a profile
                
                if (numel(data) == numel(xvals))
                    % Single spectrum
                    if strfind(lower(x_label),'raman') %#ok<STRIFCND>
                        % Raman data
                        obj = ChiRamanSpectrum(xvals,data);
                    else
                        if strfind(lower(x_label),'wavenumber') %#ok<STRIFCND>
                            % IR data
                            obj = ChiIRSpectrum(xvals,data);
                        else
                            % Generic data
                            xunit = '';
                            yunit = '';
                            obj = ChiSpectrum(xvals,data,false,x_label,xunit,y_label,yunit);
                        end
                    end
                else
                    % Multiple spectra
                    if strfind(lower(x_label),'raman') %#ok<STRIFCND>
                        % Raman data
                        obj = ChiRamanSpectralCollection(xvals,data);
                        obj.filenames = filenames;                                
                    else
                        if strfind(lower(x_label),'wavenumber') %#ok<STRIFCND>
                            % IR data
                            obj = ChiIRSpectralCollection(xvals,data);
                            obj.filenames = filenames;                                
                        else
                            % Generic data
                            xunit = '';
                            yunit = '';
                            obj = ChiSpectralCollection(xvals,data,false,x_label,y_label,x_label,xunit,y_label,yunit);
                            obj.filenames = filenames;                                
                        end
                    end

                end               
            end
            for i = 1:size(filenames,1)
                obj.history.add(['filename: ', filenames{i}]);
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
            obj = ChiMettlerToledoFile.open(varargin{:});
        end
            
        % ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
        function name = className()
            name = mfilename('class');
        end
    
        % ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    end
    
end
