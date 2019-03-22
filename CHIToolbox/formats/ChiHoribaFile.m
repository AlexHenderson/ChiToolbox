classdef ChiHoribaFile < ChiAbstractFileFormat

% ChiHoribaFile  File format handler for Horiba Excel (.xls) files
%
% Syntax
%   myfile = ChiHoribaFile();
%   myfile = ChiHoribaFile.open();
%   myfile = ChiHoribaFile.open(filename(s));
%
% Description
%   myfile = ChiHoribaFile() creates an empty object.
% 
%   myfile = ChiHoribaFile.open() opens a dialog box to request filenames
%   from the user. The selected files are opened and concatenated into a
%   ChiRamanSpectrum, ChiRamanSpectralCollection or ChiRamanImage as
%   appropriate.
% 
%   myfile = ChiHoribaFile.open(filenames) opens the filenames provided in
%   a cell array of strings.
%
%   This class can read Microsoft Excel files exported from the Horiba
%   LabSpec software. The file format has the capacity to hold different
%   types of information. If a single file containing a single spectrum is
%   selected, then myfile is a ChiRamanSpectrum. If a single file
%   containing multiple spectra is selected, then myfile is a
%   ChiRamanSpectralCollection. If multiple files are selected, then these
%   are combined into a ChiRamanSpectralCollection.
%
% Copyright (c) 2019, Alex Henderson.
% Licenced under the GNU General Public License (GPL) version 3.
%
% See also 
%   ChiRamanSpectrum ChiRamanSpectralCollection ChiRamanImage.

% Contact email: alex.henderson@manchester.ac.uk
% Licenced under the GNU General Public License (GPL) version 3
% http://www.gnu.org/copyleft/gpl.html
% Other licensing options are available, please contact Alex for details
% If you use this file in your work, please acknowledge the author(s) in
% your publications. 

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
            if ~strcmpi(ext(1:4),'.xls')
                return
            end
            % ToDo: Check internal magic numbers
            truefalse = true;
        end
        
        % ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
        function extn = getExtension()
            extn = '*.xls?';
        end
        
        % ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
        function filter = getFiltername()
            filter = 'Horiba Excel Files (*.xls)';
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
                filenames = utilities.getfilenames({ChiHoribaFile.getExtension(), ChiHoribaFile.getFiltername()});
            end
            
            % Make sure we have a cell array of filenames
            if ~iscell(filenames)
                filenames = cellstr(filenames);
            end
            
            % Check whether the files are OK for a Horiba reader
            for i = 1:length(filenames) 
                if ~ChiHoribaFile.isreadable(filenames{i})
                    message = sprintf('Filename %s is not a Horiba file (*.xls).', utilities.pathescape(filenames{i}));
                    err = MException(['CHI:',mfilename,':InputError'], message);
                    throw(err);
                end
            end
            
            % Open the file(s)
            if (length(filenames) == 1)
                [ramanshift,data,info] = horibaexcel(filenames{1}); %#ok<ASGLU>
                if (numel(data) == numel(ramanshift))
                    obj = ChiRamanSpectrum(ramanshift,data);
                else
                    obj = ChiRamanSpectralCollection(ramanshift,data);
                end               
            else
                % Need to manage multiple files
                for i = 1:length(filenames)
                    [ramanshift,data,info] = horibaexcel(filenames{1}); %#ok<ASGLU>
                    
                    if (i == 1)
                        % Workaround for broken ChiSpectralCollection.append
                        obj = ChiRamanSpectralCollection(ramanshift,data);
                    else
                        if (numel(data) == numel(ramanshift))
                            obj.append(ChiRamanSpectrum(ramanshift,data));
                        else
                            obj.append(ChiRamanSpectralCollection(ramanshift,data));
                        end               
                    end
                end
            end
            
            obj.filenames = filenames;
            for i = 1:length(filenames)
                obj.history.add(['Horiba file: ', filenames{i}]);
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
            obj = ChiHoribaFile.open(varargin{:});
        end
            
        % ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
        function name = className()
            name = mfilename('class');
        end
    
        % ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    end
    
end
