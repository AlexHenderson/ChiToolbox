function metadata = metadatareader(filename)

% Function: metadatareader
% Usage: 
%   metadata = metadatareader()
%   metadata = metadatareader(filename)
%
% Purpose:
%   Extracts information from a specialised Excel spreadsheet: MetadataRecordSheet.xlsx
%
%  input:
%   'filename' string containing the full path to the spreadsheet (optional)
% 
%  output:
%   'metadata' is a structure containing the following:
%       -A list of dataset filenames
%       -A list of dates of acquisition, if provised in the spreadsheet
%       -The range of values for each parameter recorded
%       -For each entry in the parameters list, a logical filter for each
%        possible option of the value
%
%   More information on the contents of the metadata output structure is
%   available in the MetadataRecordSheet.xlsx template file. 
%   
%   Copyright (c) 2017, Alex Henderson 
%   Contact email: alex.henderson@manchester.ac.uk
%   Licenced under the GNU General Public License (GPL) version 3
%   http://www.gnu.org/copyleft/gpl.html
%   Other licensing options are available, please contact Alex for details
%   If you use this file in your work, please acknowledge the author(s) in
%   your publications. 
%
%       version 1 June 2017

if exist('filename', 'var')
    % Load the metadata file and overwrite any cached version
    metadata = loadMetadata(filename);
else
%     % No (new) filename provided so load a cached version if available
%     if exist('metadata.mat','file')
%         load('metadata.mat');
%     else
        % No (new) filename or cached version available, so ask user
        filename = getfilename('*.xls?',  'Excel Metadata Files (*.xls;*xlsx)');
        if (isnumeric(filename) && (filename == 0))
            error('No file selected');
        end
        filename = filename{1,1};
        metadata = loadMetadata(filename);
%     end
end

end % function metadataReader

% ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
function metadata = loadMetadata(filename)
    
    %% Check the format of the filename provided
    [status,sheets] = xlsfinfo(filename);
    if isempty(status)
        error(['Cannot read this type of metadata file. ', sheets]);
    end
    
    %% Get settings
    [dummy,dummy,rawSettings] = xlsread(filename, 'settings'); %#ok<ASGLU>

    if strcmp(rawSettings{1,1}, 'Version')
        version = rawSettings{2,1};
    end
    if strcmp(rawSettings{1,2}, 'Metadata types')
        parameterTypeOptions = rawSettings(2:end,2);    % cell array
    end
    
    %% Get raw metadata
    [dummy,dummy,rawData] = xlsread(filename, sheets{1}); %#ok<ASGLU>
    
    %% Remove empty columns
    numCols = size(rawData,2);
    for i = numCols:-1:1
        % Remove in reverse order to preserve layout
        if cellfun(@(C) all(isnan(C)), rawData(:,i))
            rawData(:,i) = [];
        end
    end
    
    %% Locate fields inside metadata sheet
    % Identify the title
    
    finished = false;
    row = 0;
    while ~finished
        row = row + 1;
        switch rawData{row,1}
            case 'Dataset title:'
                title = rawData{row,2};
                if isnan(title)
                    title = '';
                end
                metadata.title = title;
            case 'Owner:'
                owner = rawData{row,2};
                if isnan(owner)
                    owner = '';
                end
                metadata.owner = owner;
            case 'Path to data files: '
                dataPath = rawData{row,2};
                metadata.dataPath = dataPath;
            case 'Filename'
                % This marks the end of the header section
                parameterName = rawData(row, 4:end);     % cell array
                parameterType = rawData(row+1, 4:end);   % cell array
                metadataStart = row + 2;
                metadata.filenames = rawData(metadataStart:end, 1);
                metadata.fullFilenames = fullfile(dataPath, metadata.filenames);
                metadata.acquisitionDate = cell2mat(rawData(metadataStart:end, 2));
                rawData = rawData(metadataStart:end, 4:end);
                finished = true;
        end
    end 
    [numFiles, numVarParameters] = size(rawData);
    metadata.numFiles = numFiles;
    metadata.numParameters = numVarParameters;
    metadata.metadataFile = filename;    
    
    %% Get parameter info
    metadata.filter = struct;
    
    % Variable fields
    for i = 1:numVarParameters
        
        switch parameterType{i}
            case parameterTypeOptions{1}
                % Should be True/False
                metadata = buildLogicalFilter(parameterName{i}, rawData(:, i), metadata);
            case parameterTypeOptions{2}
                % Should be Numeric
                metadata = buildNumericFilter(parameterName{i}, rawData(:, i), metadata);
            case parameterTypeOptions{3}
                % Should be Category
                metadata = buildCategoryFilter(parameterName{i}, rawData(:, i), metadata);
            otherwise
                error(['Cannot interpret the parameter type: ', parameterType{i}]);
        end
    end
   
end % function loadMetadata
    
% ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
function filter = generateFilter(variable, prefix, filter)

    if iscell(variable)
        % If any of the cells contain numbers, we need to convert them to a
        % string version of the number
        variable = cellfun(@num2str,variable,'UniformOutput',false);
        uniq = unique(variable);
    else
        uniq = unique(variable, 'rows');
    end

    for i = 1:size(uniq,1)
        if iscell(variable)
            value = uniq{i,:};
        else
            value = uniq(i,:);
        end

        if verLessThan('matlab', '8.5.0') % genvarname is deprecated in R2015a
            filter_variable = genvarname([prefix, num2str(value)]); %#ok<DEPGENAM>
        else
            filter_variable = matlab.lang.makeValidName([prefix, num2str(value)]);
        end        

        locations = false(size(variable,1),1);
        if iscell(variable)
            locations = strcmp(variable,value);
            locations = logical(locations); %#ok<NASGU>
        else
            locations(variable == value) = true; %#ok<NASGU>
        end            

        eval(['filter.', filter_variable, ' = locations;']);
%         eval(['filt.', filter_variable, ' = logical(', variable, ' == ', num2str(value), ');']);
    end

end % function generateFilter

% ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
function [metadata, newParameterName, rawData] = buildLogicalFilter(parameterName, rawData, metadata)

    % Replace spaces in parameter names and raw data with underscores
    parameterName = strrep(parameterName, ' ', '_');
    % Make the first letter uppercase
    parameterName(1) = upper(parameterName(1));
    % Add 'is to the front of the variable
    newParameterName = ['is', parameterName];

    % Create a MATLAB variable from the parameterName string
    if verLessThan('matlab', '8.5.0') % genvarname is deprecated in R2015a
        filter_variable = genvarname(newParameterName); %#ok<DEPGENAM>
    else
        filter_variable = matlab.lang.makeValidName(newParameterName);
    end        

    rawData = cell2mat(rawData);
    rawData = logical(rawData);
    
    % Build the filter
    eval(['metadata.filter.', filter_variable, ' = rawData;']);
    
end % function buildLogicalFilter

% ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
function [metadata, newParameterName, rawData] = buildNumericFilter(parameterName, rawData, metadata)

    % Replace spaces in parameter names and raw data with underscores
    parameterName = strrep(parameterName, ' ', '_');
    % Add 'is' to the end of the variable
    newParameterName = [parameterName, '_is_'];
    
    rawData = cell2mat(rawData);

    metadata.filter = generateFilter(rawData, newParameterName, metadata.filter);
    eval(['metadata.', parameterName, ' = rawData;']);

end % function buildNumericFilter

% ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
function [metadata, newParameterName, rawData] = buildCategoryFilter(parameterName, rawData, metadata)

    % Replace spaces in parameter names and raw data with underscores
    parameterName = strrep(parameterName, ' ', '_');
    for i = 1:length(rawData)
        rawData{i} = strrep(rawData{i}, ' ', '_');
    end
    % Add 'is' to the end of the variable
    newParameterName = [parameterName, '_is_'];
    
    metadata.filter = generateFilter(rawData, newParameterName, metadata.filter);
    eval(['metadata.', parameterName, ' = rawData;']);

end % function buildCategoryFilter

% ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
function filename = getfilename(filter, filtername)

%   Function: getfilename
%   Usage: [filename] = getfilename(filter, filtername);
%
%   Collects a single filename from the user.
%   For multiple filenames use getfilenames.m
%
%   'filter' and 'filtername' are strings of the form...
%       filter = '*.mat'
%       filtername = 'MAT Files (*.mat)'
%   'filename' is a char array containing the name of the file including
%   the path
%
%   (c) May 2011, Alex Henderson
%

% Mostly based on getfilenames and tweaked to only accept a single filename

filetypes = {   filter, filtername; ...
                '*.*',    'All Files (*.*)'};

% example...            
%filetypes = {   '*.mat',  'MAT Files (*.mat)'; ...
%                '*.*',    'All Files (*.*)'};

setappdata(0,'UseNativeSystemDialogs',false);

[filenames, pathname] = uigetfile(filetypes, 'Select file...', 'MultiSelect', 'off');

if isfloat(filenames) && (filenames==0)
    disp('Error: No filename selected');
    filename = 0;
    return;
end

if iscell(filenames)
    % change from a row of filenames to a column of filenames
    % if only one file is selected we have a single string (not a cell
    % array)
    filenames = filenames';
else
    % convert the filename to a cell array (with one entry)
    filenames = cellstr(filenames);
end

for i = 1:size(filenames,1)
    filenames{i,1} = [pathname, filenames{i,1}];
end
filename = filenames;

end % function getfilename
% ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
