classdef ChiWatersFile < ChiAbstractFileFormat

% ChiWatersFile  File format handler for Waters DESI image files
% 
% Syntax
%   myfile = ChiWatersFile();
%   myfile = ChiWatersFile.open();
%   myfile = ChiWatersFile.open(filename);
%
% Description
%   myfile = ChiWatersFile() creates an empty object.
% 
%   myfile = ChiWatersFile.open() prompts the user for a filename. The
%   selected file is opened as a ChiMSImage.
% 
%   myfile = ChiWatersFile.open(filename) opens the file provided as a
%   char array.
%
% Notes
%   This class requires all the following to be true:
%    - The file to be opened is from a Desorption Electrospray Ionization
%      (DESI) imaging experiment, using a Waters instrument. 
%    - The data have been peak detected (centroided). 
%    - There is a subfolder of the DESI folder called 'imaging'.
%    - There is a text file in the imaging folder. 
% 
%   It is this text file that the class reads. Therefore the filename
%   parameter refers to this text (*.txt) file, and not the actual DESI
%   folder.
% 
%   Only a single file can be read, per invocation. 
%
% Copyright (c) 2026, Alex Henderson.
% Licenced under the GNU General Public License (GPL) version 3.
%
% See also 
%   ChiMSImage.

% Contact email: alex.henderson@manchester.ac.uk
% Licenced under the GNU General Public License (GPL) version 3
% http://www.gnu.org/copyleft/gpl.html
% Other licensing options are available, please contact Alex for details
% If you use this file in your work, please acknowledge the author(s) in
% your publications. 

% Version 1.0, May 2026
% The latest version of this file is available at:
% https://github.com/AlexHenderson/ChiToolbox

    
    methods(Static)
        function obj = ChiWatersFile(varargin)
            %ChiWatersFile Construct an instance of this class
        end
        % ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
        function truefalse = isreadable(filename)
            if iscell(filename)
                filename = filename{1};
            end
            
            truefalse = false; %#ok<NASGU>
           
            % Can't really check a text file. 
            % There are no magic numbers etc. 
            
            [~,~,ext] = fileparts(filename);
            if ~strcmpi(ext, '.txt')
                truefalse = false;
                return;
            end

            % If we get to here, we consider the file to be readable. 
           truefalse = true; 
        end
        
        % ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
        function extn = getExtension()
            extn = '*.txt';
        end
        
        % ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
        function filter = getFiltername()
            filter = 'Waters DESI Image Files (*.txt)';
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
                filenames = utilities.getfilename({ChiWatersFile.getExtension(), ChiWatersFile.getFiltername()});
            end
            
            % Make sure we have a cell array of filenames
            if ~iscell(filenames)
                filenames = cellstr(filenames);
            end
            
            % Check whether the files are OK for a Waters DESI reader
            for i = 1:length(filenames) 
                if ~ChiWatersFile.isreadable(filenames{i})
                    message = sprintf('Filename %s is not a Waters DESI file (*.txt). ', utilities.pathescape(filenames{i}));
                    err = MException(['CHI:',mfilename,':InputError'], message);
                    throw(err);
                end
            end
            
            % Open the file(s)
            fileisreadable = true(length(filenames),1);
            if (length(filenames) == 1) %#ok<ISCL>
                [xvals,data,height,width,filenames,xlabel,xunit,ylabel,yunit] = waters_desi(filenames{1});
                obj = ChiMSImage(xvals,data,width,height,false,xlabel,xunit,ylabel,yunit);
                obj.iscentroided = true;
            end
            
            obj.filenames = filenames(fileisreadable);
            for i = 1:length(filenames)
                if fileisreadable(i)
                    obj.history.add(['Waters DESI file: ', filenames{i}]);
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
            obj = ChiWatersFile.open(varargin{:});
        end
        % ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
        
    end
end
