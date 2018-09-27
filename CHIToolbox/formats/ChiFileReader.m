classdef ChiFileReader

% ChiFileReader  Opens a range of different filetypes
%
% Syntax
%   myfile = ChiFileReader.read(filenames);
%
% Description
%   myfile = ChiFileReader.read(filenames) opens the filenames provided as
%   a cell array of strings.
%
%   This class can read a range of different filetypes.
%
% Copyright (c) 2018, Alex Henderson.
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

% Version 2.0, September 2018
% The latest version of this file is available on Bitbucket
% https://bitbucket.org/AlexHenderson/chitoolbox
    
% All FileReaders should inherit from ChiAbstractFileFormat. 
% First we collect a list of all classes that inherit from
% ChiAbstractFileFormat. Each of these has some static functions. We call
% these functions to build a list of readable file types. 

% All the methods here are static. That way we can identify the correct
% filetype and dispatch to the appropriate reader without having to
% instantiate the class. It removes redundant braces from the signature
% (ie. ChiFileReader.read() rather than ChiFileReader().read())


    methods (Static)
        
        function subclasses = getChildren()
            % Generate a list of classes that inherit from the rootclass. 
            rootclass = 'ChiAbstractFileFormat';
            thispath = fileparts(mfilename('fullpath'));
            rootpath = thispath;
            tb = getSubclasses(rootclass,rootpath); 
            subclasses = tb.names;
            subclasses = subclasses(2:end);
        end
        
        % ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
        function readers = findReader(filenames)
            % Cycle through the subclasses, accessing their static members.
            readers = {};
            subclasses = ChiFileReader.getChildren();
            
            if isempty(subclasses)
                err = MException(['CHI:',mfilename,':InputError'], ...
                    'No file readers are available');
                throw(err);                
            else
                for f = 1:length(filenames)
                    for i = 1:length(subclasses)
                        truefalse = false; %#ok<NASGU>
                        commandline = [subclasses{i}, '.isreadable(filenames{f});'];
                        truefalse = eval(commandline);
                        if truefalse
                            readers = vertcat(readers,subclasses{i}); %#ok<AGROW>
                        end
                    end
                end
                readers = unique(readers);
            end
        end
        % ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
        function filters = assembleFilters()
            % Generate a list of available file formats and their file
            % extensions ready to be passed to getfilename function(s);
            
            subclasses = ChiFileReader.getChildren();
            % Only using a map to remove duplicate entries where one filter
            % inherits from another.
            filtermap = containers.Map;
            if isempty(subclasses)
                err = MException(['CHI:',mfilename,':InputError'], ...
                    'No file readers are available');
                throw(err);                
            else
                for i = 1:length(subclasses)
                    filtername = eval([subclasses{i}, '.getFiltername();']);
                    extension = eval([subclasses{i}, '.getExtension();']);
                    filtermap(filtername) = extension;
                end
                
                % Build a complete list of all file extensions so we can
                % offer the 'Readable Files' option. 
                keys = filtermap.keys';
                values = filtermap.values';
                
                filtercellarray = horzcat(values,keys);
                for i = 1:filtermap.Count
                    if i == 1
                        % First pass through, no semicolon
                        readableextensions = values{i};
                    else
                        % On subsequent passes we prepend a semicolon
                        readableextensions = [readableextensions, ';', values{i}]; %#ok<AGROW>
                    end
                end

                % Maps sort their keys, but we want 'Readable Files' to be
                % at the top. Therefore, we convert the map to a cell array
                % and concatenate.
                filters = cell(1,2);
                filters{1,1} = readableextensions;
                filters{1,2} = ['Readable Files (', readableextensions, ')'];
                filters = vertcat(filters,filtercellarray);
            end
                        
        end
        
        % ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
        function obj = read(filenames)
            % Reads the filename(s) provided
            readers = ChiFileReader.findReader(filenames);
            if isempty(readers)
                err = MException(['CHI:',mfilename,':InputError'], ...
                    'Sorry, cannot read this file type.');
                throw(err);
            else
                if (length(readers) > 1)
                    err = MException(['CHI:',mfilename,':InputError'], ...
                        'Multiple file readers are available. Please use the specific reader. ');
                    throw(err);
                else
                    commandline = [readers{1}, '.read(filenames);'];
                    obj = eval(commandline);
                end
            end
        end
        
        % ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
        
    end
    
end
