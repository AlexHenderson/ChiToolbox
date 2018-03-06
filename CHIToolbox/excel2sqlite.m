function excel2sqlite(filename)

% excel2sqlite  Copy metadata from a MetadataRecordSheet Excel file to a SQLite file
%
% Syntax
%   excel2sqlite();
%   excel2sqlite(filename);
%
% Description
%   excel2sqlite() opens a dialog box to request a Microsoft Excel file
%   from the user. This file must be in the MetadataRecordSheet layout. The
%   contents of the file is transferred to a SQLite database file of the
%   same name where the file extension has been changed to .sqlite
% 
%   excel2sqlite(filename) uses the filename provided. 
%
% Copyright (c) 2018, Alex Henderson.
% Licenced under the GNU General Public License (GPL) version 3.
%
% See also 
%   ChiMetadataSheet.

% Contact email: alex.henderson@manchester.ac.uk
% Licenced under the GNU General Public License (GPL) version 3
% http://www.gnu.org/copyleft/gpl.html
% Other licensing options are available, please contact Alex for details
% If you use this file in your work, please acknowledge the author(s) in
% your publications. 

% Version 1.0, February 2018


try

    % Get input filename, if not provided
    if ~exist('filename', 'var')
        filename = utilities.getfilename('*.xls?', 'Microsoft Excel Files (*.xls,*.xlsx)');
        filename = filename{1};
    end

    % Determine the output filename
    [pathstr,name,ext] = fileparts(filename); %#ok<ASGLU>
    sqlfilename = fullfile(pathstr,[name,'.sqlite']);

    %% Copy metadata to a backup file if already present
    if (exist(sqlfilename, 'file') == 2)
        backupsqlfilename = fullfile(pathstr,[name,'.sqlite.bak']);
        [status,msg,msgID] = movefile(sqlfilename,backupsqlfilename); %#ok<ASGLU>
        if ~status
            err = MException(['CHI:',mfilename,':InputError'], ...
                ['Error: ', msg]);
            throw(err);
        end
    end

    %% Check the format of the filename provided
    [status,sheets] = xlsfinfo(filename);
    if isempty(status)
        error(['Cannot read this type of metadata file. ', sheets]);
    end

    %% Get settings sheet
    [dummy,dummy,rawSettings] = xlsread(filename, 'settings'); %#ok<ASGLU>

    if strcmp(rawSettings{1,1}, 'Version')
        version = rawSettings{2,1};
    end
    if strcmp(rawSettings{1,2}, 'Metadata types')
        metadataTypes = rawSettings(2:end,2);    %#ok<NASGU> % cell array
    end

    %% Get Metadata Record Sheet
    [num,txt,rawSheetData] = xlsread(filename, sheets{1});

    % Excel 'remembers' deleted rows. xlsread imports these as NaNs.
    % However they're not converted to numbers or text. Therefore we can
    % determine the number of possible rows by using the lengths of the num
    % and txt matrixes. The num matrix is 1 shorter since there are no
    % numbers in the first row of the spreadsheet. 
    numValidRows = max(size(num,1)+1, size(txt,1));
    rawSheetData = rawSheetData(1:numValidRows,:);

    % Remove empty columns
    % ToDo: improve this
    numCols = size(rawSheetData,2);
    for row = numCols:-1:1
        % Remove in reverse order to preserve layout
        if cellfun(@(C) all(isnan(C)), rawSheetData(:,row))
            rawSheetData(:,row) = [];
        end
    end

    %% Locate information fields inside metadata sheet

    finished = false;
    row = 0;
    while ~finished
        row = row + 1;
        switch rawSheetData{row,1}
            case 'Dataset title:'
                title = rawSheetData{row,2};
            case 'Owner:'
                owner = rawSheetData{row,2};
            case 'Path to data files: '
                dataPath = rawSheetData{row,2};
            case 'Filename'
                % This marks the end of the header section
                parameterName = rawSheetData(row, 4:end);     % cell array
                parameterType = rawSheetData(row+1, 4:end);   % cell array
                metadataStart = row + 2;
                filenames = rawSheetData(metadataStart:end, 1);
                acquisitionDate = rawSheetData(metadataStart:end, 2);
                rawSheetData = rawSheetData(metadataStart:end, 4:end);
                finished = true;
        end
    end 

    [numObservations, numVariables] = size(rawSheetData);

    %% SQLite specific

    % Create the database on disc
    metadataDB = sql_object(sqlfilename);

    % Begin transaction
    metadataDB.Begin;   

    % Create a table for the metadata sheet overarching information
    createHeadersStr = 'CREATE TABLE headers (version REAL, title TEXT, owner TEXT, datapath TEXT, numvariables INTEGER, numobservations INTEGER)';
    metadataDB.exec(createHeadersStr);
    
    % Insert the header values
    insertHeadersStr = sprintf('INSERT INTO headers (version,title,owner,datapath,numvariables,numobservations) values (%f,"%s","%s","%s",%d,%d)', version, title, owner, dataPath, numVariables, numObservations);
    metadataDB.exec(insertHeadersStr);

    % Generate some useful aliases
    comma = ', ';
    space = ' ';
    dquote = '"';
    
    % Create a table for the actual metadata
    createDataStr = 'CREATE TABLE data ("idx" INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,"filename" TEXT, "acquired" TEXT';
    for i = 1:numVariables
        createDataStr = horzcat(createDataStr, comma, dquote, parameterName{i}, dquote); %#ok<AGROW>
        switch lower(parameterType{i}(1))
            case 'c' % for Category
                createDataStr = horzcat(createDataStr,space,'TEXT'); %#ok<AGROW>
            case 'n' % for Numeric
                createDataStr = horzcat(createDataStr,space,'NUMERIC'); %#ok<AGROW>
            case 't' % for True/False
                createDataStr = horzcat(createDataStr,space,'INTEGER'); %#ok<AGROW>
            otherwise
                createDataStr = horzcat(createDataStr,space,'TEXT'); %#ok<AGROW>
        end   
    end
    createDataStr = horzcat(createDataStr, ')');
    metadataDB.exec(createDataStr);

    % Insert the actual metadata
    for row = 1:numObservations
        % If the acquisition date is not available, make it a NULL
        acqdate = acquisitionDate{row}; 
        if (any(isnan(acqdate)) || isempty(acqdate))
            acqdate = 'NULL';
        end

        insertDataStr = sprintf('INSERT INTO data VALUES(%d,"%s","%s"', row, filenames{row}, acqdate);
        for col = 1:numVariables
            value = rawSheetData{row,col};
            switch lower(parameterType{col}(1))
                case 'c' % for Category
                    insertDataStr = horzcat(insertDataStr,comma,dquote, num2str(value), dquote); %#ok<AGROW>
                case 'n' % for Numeric
                    insertDataStr = horzcat(insertDataStr,comma, num2str(value,'%.8g')); %#ok<AGROW>
                case 't' % for True/False
                    % Manage possibility taht the user has decided to go
                    % with t/f or y/n
                    if ischar(value)
                        switch lower(value(1))
                            case 'y' % yes
                                value = true;
                            case 'n' % no, not OK
                                value = false;
                            case 't' % true
                                value = true;
                            case 'f' % false
                                value = false;
                            case 'o' % OK?
                                value = true;
                        end
                    end
                    insertDataStr = horzcat(insertDataStr,comma, num2str(logical(value))); %#ok<AGROW>
                otherwise
                    insertDataStr = horzcat(insertDataStr,comma,dquote, num2str(value), dquote); %#ok<AGROW>
            end   
        end    
        insertDataStr = horzcat(insertDataStr, ')'); %#ok<AGROW>
        metadataDB.exec(insertDataStr);
    end

    % All done so commit the transaction and close the database
    metadataDB.Commit();
    delete(metadataDB);

catch ex
    % Should probably rolback any changes to the database, although this
    % may be automatic
    metadataDB.Rollback();
    % Report the error
    err = MException(['CHI:',mfilename,':InputError'], ...
        ['Error: ', ex.message]);
    throw(err);
end
