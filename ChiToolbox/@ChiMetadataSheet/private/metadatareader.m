function metadata = metadatareader(this,filename)

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
    [dummy,dummy,rawSettings] = xlsread(filename, 'settings');

    if strcmp(rawSettings{1,1}, 'Version')
        version = rawSettings{2,1};
    end
    if strcmp(rawSettings{1,2}, 'Metadata types')
        parameterTypeOptions = rawSettings(2:end,2);    % cell array
    end
    
    %% Get raw metadata
    [num,txt,rawData] = xlsread(filename, sheets{1});
    % Excel 'remembers' deleted rows. xlsread imports these as NaNs.
    % However they're not converted to numbers or text. Therefore we can
    % determine the number of possible rows by using the lengths of the num
    % and txt matrixes. The num matrix is 1 shorter since there are no
    % numbers in the first row of the spreadsheet. 
    numValidRows = max(size(num,1)+1, size(txt,1));
    rawData = rawData(1:numValidRows,:);
    
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
                
                if isnan(dataPath)
                    % Path is missing, so assume it is the same path as the
                    % metadata spreadsheet
                    dataPath = '.';
                end
                
                % Handle cases where relative paths are used
                if strcmpi(dataPath,'.')
                    metadatafilepath = GetFullPath(filename);
                    dataPath = fileparts(metadatafilepath);
                end
                if strcmpi(dataPath,'..')
                    metadatafilepath = GetFullPath(filename);
                    dataPath = fileparts(fileparts(metadatafilepath));
                end
                
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
    metadata.originalParameterNames = parameterName';
    metadata.parameterTypes = parameterType';
    metadata.metadataFile = filename;    
    metadata.version = version;
    
    %% Get parameter info
    metadata.filter = struct;
    
    metadata.safeParameterNames = cell(numVarParameters,1);
    metadata.parameters = cell(numVarParameters,1);
    
    % Variable fields
    for i = 1:numVarParameters
        
        switch parameterType{i}
            case parameterTypeOptions{1}
                % Should be True/False
                % If any of the cells contain numbers, we need to convert them to a
                % string version of the number
                rawData(:, i) = cellfun(@num2str,rawData(:, i),'UniformOutput',false);
                [metadata,safeParameterName,dummy,columnData] = buildLogicalFilter(parameterName{i}, rawData(:, i), metadata); %#ok<ASGLU>
                metadata.safeParameterNames{i} = safeParameterName;
                metadata.parameters{i} = columnData;
            case parameterTypeOptions{2}
                % Should be Numeric
                [metadata,safeParameterName,dummy,columnData] = buildNumericFilter(parameterName{i}, rawData(:, i), metadata); %#ok<ASGLU>
                metadata.safeParameterNames{i} = safeParameterName;
                metadata.parameters{i} = columnData;
            case parameterTypeOptions{3}
                % Should be Category
                % If any of the cells contain numbers, we need to convert them to a
                % string version of the number
                rawData(:, i) = cellfun(@num2str,rawData(:, i),'UniformOutput',false);
                [metadata,safeParameterName,dummy,columnData] = buildCategoryFilter(parameterName{i}, rawData(:, i), metadata); %#ok<ASGLU>
                metadata.safeParameterNames{i} = safeParameterName;
                metadata.parameters{i} = columnData;
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
function [metadata,safeParameterName,filterName,rawData] = buildLogicalFilter(parameterName, rawData, metadata)

    % Replace spaces in parameter names and raw data with underscores
    safeParameterName = strrep(parameterName, ' ', '_');
    safeParameterName = strrep(safeParameterName, '.', '_');
    safeParameterName = strrep(safeParameterName, '(', '_');
    safeParameterName = strrep(safeParameterName, ')', '_');
    % Make the first letter uppercase
    safeParameterName(1) = upper(safeParameterName(1));
    % Add 'is to the front of the variable
    filterName = ['is', safeParameterName];

    % Create a MATLAB variable from the parameterName string
    if verLessThan('matlab', '8.5.0') % genvarname is deprecated in R2015a
        filter_variable = genvarname(filterName); %#ok<DEPGENAM>
    else
        filter_variable = matlab.lang.makeValidName(filterName);
    end        

    % If data is text, remove leading or trailing whitespace
    if ischar(rawData{1})
        rawData = strtrim(rawData);
    
        % Ensure we have a maximum of two options
        % Force to upper case for simplicity
        [uniquevalues,dummy,ic] = unique(upper(rawData),'stable');
        if (length(uniquevalues) > 2)
            % We have more than 2 options T/F and something else
            error('Column defined as logical, but >2 options present')
        else
            % ic is the index values of the unique values. There are a maximum
            % of 2 unique values so the index values can be 1 or 2. Subtract 1
            % and we get 0/1.        
            ic = ic - 1;
            % Now we need to determine what these refer to and that depends on
            % the unique values themselves. Just look at the first character.
            % If the first character of the first unique value is T or Y, then
            % the index values need to be flipped since ic(1) is currently 0,
            % ie false.
            switch (uniquevalues{1}(1))
                case 'T'
                    ic = ~ic;
                case 'Y'
                    ic = ~ic;
                case '1'
                    ic = ~ic;
                case 'F'
                    % No need to flip ic since the values of ic correspond to
                    % false and true
                case 'N'
                    % No need to flip ic since the values of ic correspond to
                    % no and yes
                case '0'
                    % No need to flip ic since the values of ic correspond to
                    % '0' and '1'
                otherwise
                    error('Cannot determine whether the logical values refer to TRUE/FALSE or YES/NO')
            end

            % Now we can map the rawData to these unique index values
            rawData = ic;
        end
        
    end

%     try
%         rawData = cell2mat(rawData);
%     catch ex
%         disp(['Error processing: ', safeParameterName])
%         rethrow(ex);
%     end

    if ischar(rawData)
        rawData = str2num(rawData); %#ok<ST2NM>
    end
    rawData = logical(rawData);
    
    % Build the filter
    eval(['metadata.filter.', filter_variable, ' = rawData;']);
    eval(['metadata.', safeParameterName, ' = rawData;']);
    
end % function buildLogicalFilter

% ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
function [metadata,safeParameterName,filterName,rawData] = buildNumericFilter(parameterName, rawData, metadata)

    % Replace spaces in parameter names and raw data with underscores
    safeParameterName = strrep(parameterName, ' ', '_');
    safeParameterName = strrep(safeParameterName, '.', '_');
    safeParameterName = strrep(safeParameterName, '(', '_');
    safeParameterName = strrep(safeParameterName, ')', '_');
    safeParameterName = strrep(safeParameterName, '/', '_');
    safeParameterName = strrep(safeParameterName, '\', '_');
    safeParameterName = strrep(safeParameterName, '?', '_');
    % Add 'is' to the end of the variable
    filterName = [safeParameterName, '_is_'];
    
    rawData = cellfun(@num2str,rawData,'UniformOutput',false);
    rawData = cellfun(@str2num,rawData,'UniformOutput',false);

    rawData = cell2mat(rawData);
    if ischar(rawData)
        rawData = str2num(rawData); %#ok<ST2NM>
    end

    metadata.filter = generateFilter(rawData, filterName, metadata.filter);
    eval(['metadata.', safeParameterName, ' = rawData;']);

end % function buildNumericFilter

% ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
function [metadata,safeParameterName,filterName,rawData] = buildCategoryFilter(parameterName, rawData, metadata)

    % Replace spaces in parameter names and raw data with underscores
    safeParameterName = strrep(parameterName, ' ', '_');
    safeParameterName = strrep(safeParameterName, '.', '_');
    safeParameterName = strrep(safeParameterName, '(', '_');
    safeParameterName = strrep(safeParameterName, ')', '_');
    safeParameterName = strrep(safeParameterName, '/', '_');
    safeParameterName = strrep(safeParameterName, '\', '_');
    safeParameterName = strrep(safeParameterName, '?', '_');
    for i = 1:length(rawData)
        rawData{i} = strrep(rawData{i}, ' ', '_');
    end
    % Add 'is' to the end of the variable
    filterName = [safeParameterName, '_is_'];
    
    metadata.filter = generateFilter(rawData, filterName, metadata.filter);
    try
        eval(['metadata.', safeParameterName, ' = rawData;']);
    catch ex
        disp(['Error processing: ', safeParameterName])
        rethrow(ex);
    end

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
