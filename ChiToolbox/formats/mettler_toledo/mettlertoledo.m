function [xvals,data,filename,header,x_label,y_label] = mettlertoledo(filename,plotContents)

%  mettlertoledo  Reads data from a Mettler Toledo / Applied Systems ASCII .asc file.
%   usage: 
%       [xvals,data,filename,header,x_label,y_label] = mettlertoledo();
%       [xvals,data,filename,header,x_label,y_label] = mettlertoledo(filename);
%       [xvals,data,filename,header,x_label,y_label] = mettlertoledo(filename,plotContents);
%
%   input:
%   'filename' string containing the full path to the .asc file (optional)
%   'plotContents' 1 or 0 where 1 means plot the contents and 0 (default)
%       means do not (optional). Only used when a filename is provided. 
% 
%   output:
%   'xvals' is a list of the x-values related to the data
%   'data' is a list of the intensity values of the data
%   'filename' is a string containing the full path to the .asc file
%   'header' is a struct containing various parameters within the file
%   'x_label' is the name of the unit on the x axis (eg. wavenumber)
%   'y_label' is the name of the unit on the y axis (eg absorbance)
%
%                     *******Caution******* 
%   This code is a hack of the Mettler Toledo / Applied Systems format.
%   There were very few example files and so the function may give spurious
%   results. If this is the case, please raise an issue at:
%   https://github.com/AlexHenderson/ChiToolbox/issues
% 
%   Copyright (c) 2018-2023, Alex Henderson 
%   Contact email: alex.henderson@manchester.ac.uk

%   Licenced under the GNU General Public License (GPL) version 3
%   http://www.gnu.org/copyleft/gpl.html
%   Other licensing options are available, please contact Alex for details
%   If you use this file in your work, please acknowledge the author(s) in
%   your publications. 
%
%   version 1.0 April 2018, Alex Henderson
%   The latest version of this file is available at:
%   https://github.com/AlexHenderson/ChiToolbox


%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
% Get the filename if not supplied
if ~exist('filename', 'var')
    filename = getfilename('*.asc', 'Mettler Toledo Files (*.asc)');
    if (isfloat(filename) && (filename == 0))
        return;
    end
    filename = filename{1};
end

%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
% Define some defaults
if ~exist('plotContents','var')
    plotContents = false;
end

%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
% Read the file contents
try
    fid = fopen(filename,'rt','l');

    header = readheader(fid);
    [xvals,data] = readdelimdata(fid);
%     if isfield(header, 'NumPoints')
%         [xvals,data] = readdata(fid,header.NumPoints);
%     else
%         [xvals,data] = readdata(fid,1);
%     end
    
    fclose(fid);
    
    % Define axis labels
    if isfield(header,'XUnit')
        if strcmpi(header.XUnit,'WaveNumber')
            x_label = 'wavenumbers (cm^{-1})';
        else
            x_label = header.XUnit;
        end            
    else
        x_label = '';
    end
    
    if isfield(header,'YUnit')
        if strcmpi(header.YUnit,'Absorbance')
            y_label = 'absorbance';
        else
            y_label = header.YUnit;
        end            
    else
        y_label = '';
    end
    
    if plotContents
        plotSpectralData(xvals,data,x_label,y_label,filename);
    end
    
catch exception
    if exist('fid','var')
        fclose(fid);
        clear fid;
    end
    error(exception.message);
end

end

%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
function header = readheader(fid)

    header = [];
    finished = false;
    while ~finished
        
        line = fgetl(fid);
        if (line == -1)
            % end of file
            finished = true;
        else
            if ~isempty(line)
                expr = '(.)+\t(.)+';
                [start_idx,end_idx,extents,matches,tokens,names,splits] = regexp(line,expr); %#ok<ASGLU>
                
                if ~isempty(tokens)
                    param = tokens{1,1}{1};
                    value = tokens{1,1}{2};
                    if ~isempty(param) && ~isempty(value)
                        if strcmpi(param,'XVALUES')
                            finished = true;
                        else
                            str = ['header.',param,' = ''',value,''';'];
                            eval(str);
                        end
                    end
                end
            end
        end
    end
    
    if isfield(header, 'Scans')
        header.Scans = str2num(header.Scans); %#ok<*ST2NM>
    end
    if isfield(header, 'Gain')
        header.Gain = str2num(header.Gain);
    end
    if isfield(header, 'Start')
        header.Start = str2num(header.Start);
    end
    if isfield(header, 'End')
        header.End = str2num(header.End);
    end
    if isfield(header, 'dLaserWL')
        header.dLaserWL = str2num(header.dLaserWL);
    end
    if isfield(header, 'NumPoints')
        header.NumPoints = str2num(header.NumPoints);
    end

end
%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
function [xvals,data] = readdelimdata(fid)

M = textscan(fid,'%f %f','Delimiter','\t');

xvals = M{:,1}';
data  = M{:,2}';

end
    
%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
function [xvals,data] = readdata(fid,numpoints)

    xvals = zeros(1,numpoints);
    data = zeros(1,numpoints);
    counter = 1;
    finished = false;
    while ~finished
        
        line = fgetl(fid);
        if line == -1
            % end of file
            finished = true;
        else
            if ~isempty(line)
                expr = '(.)+\t(.)+';
                [start_idx,end_idx,extents,matches,tokens,names,splits] = regexp(line,expr); %#ok<ASGLU>
                
                if ~isempty(tokens)
                    x = tokens{1,1}{1};
                    y = tokens{1,1}{2};
                    if ~isempty(x) && ~isempty(y)
                        xvals(counter) = str2num(x);
                        data(counter) = str2num(y);
                        counter = counter + 1;
                    end
                end
            end
        end
    end

end

%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
function [creationTimeStr,creationTime] = readCreationTime(fid) %#ok<DEFNU>
    position = ftell(fid);
    status = fseek(fid,0,'bof');
    if (status == -1) 
        message = ferror(fid,'clear'); 
        error(message); 
    end

    fileAsStr = fread(fid,inf,'*char')';

    [start_idx] = regexp(fileAsStr,'CreationTime');
    start_idx = start_idx + 20; % move to start of date string
    end_idx = start_idx + 18; % determine end of date string
    fileAsStr = fileAsStr(start_idx:end_idx);

    expr = '(\d\d)/(\d\d)/(\d\d\d\d) (\d\d):(\d\d):(\d\d)';
    [start_idx,end_idx,extents,matches,tokens,names,splits] = regexp(fileAsStr,expr); %#ok<ASGLU>
    
    creationTimeStr = '';
    creationTime = 0;
    if ~isempty(tokens)
        day = str2double(tokens{1,1}{1});
        month = str2double(tokens{1,1}{2});
        year = str2double(tokens{1,1}{3});
        hours = str2double(tokens{1,1}{4});
        minutes = str2double(tokens{1,1}{5});
        seconds = str2double(tokens{1,1}{6});

        creationTime = datenum(year,month,day,hours,minutes,seconds);
        creationTimeStr = datestr(creationTime);
    end
    
    % Go back where we were
    status = fseek(fid, position, 'bof'); %#ok<NASGU>
end

%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
function plotSpectralData(ramanshift,data,x_label,y_label,filename)
    window_title = filename;
    figure('Name',window_title,'NumberTitle','off');
    utilities.plotformatted(ramanshift,data);
    utilities.tightxaxis;
    xlabel(x_label);
    ylabel(y_label);
    [pathstr, name, ext] = fileparts(filename);  %#ok<ASGLU>
    title(name,'interpreter','none');
end

%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
function filename = getfilename(filter,filtername)

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
                '*.*',  'All Files (*.*)'};

% example...            
%filetypes = {   '*.mat',  'MAT Files (*.mat)'; ...
%                '*.*',    'All Files (*.*)'};

setappdata(0,'UseNativeSystemDialogs',false);

[filenames,pathname] = uigetfile(filetypes,'Select file...','MultiSelect','off');

if (isfloat(filenames) && (filenames == 0))
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
    filenames{i,1} = [pathname,filenames{i,1}];
end

filename = filenames;

end
%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

% Some information...

% FileName	IBU growthrate So = 1_5 25_02_2010 #3.mts
% FileType	Sample
% Origin	Applied Systems
% Owner	Public Domain
% Apodization	Intensity
% Scans	128
% Gain	1
% Start	4001.839978
% End	648.321231
% dLaserWL	0.000000
% NumPoints	1739
% XUnit	WaveNumber
% YUnit	Absorbance
% Collected	Thu Feb 25 18:02:37 2010
% History	Acquired at Thu Feb 25 18:02:37 2010
