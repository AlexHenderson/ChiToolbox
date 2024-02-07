function [xvals,data,height,width,filename,acqdate,x_label,y_label] = thermoSpc(filename,plotContents)

%   Function: thermoSpc
%   Usage: [xvals,data,height,width,filename,acqdate,x_label,y_label] = thermoSpc();
%   Usage: [xvals,data,height,width,filename,acqdate,x_label,y_label] = thermoSpc(filename);
%   Usage: [xvals,data,height,width,filename,acqdate,x_label,y_label] = thermoSpc(filename,plotContents);
%
%   Extracts the data from a Thermo Scientific GRAMS .spc file.
%   Optionally plots the contents of the file as either a single spectrum,
%   a series of spectra overlaid, or an image or spectrum of the total
%   signal.
%
%   input:
%   'filename' string containing the full path to the .spc file (optional)
%   'plotContents' 1 or 0 where 1 means plot the contents and 0 (default)
%       means do not (optional). Only used when a filename is provided. 
% 
%   output:
%   'xvals' is a list of the wavenumbers related to the data
%   'data' is a 3D hypercube of the data in the file (height x width x wavenumbers)
%   'filename' is a string containing the full path to the .wdf file
%   'acqdate' is a string containing the date and time of acquisition
%   'x_label' is the name of the unit on the x axis (wavenumber)
%   'y_label' is the name of the unit on the y axis (intensity)
%
%   Copyright (c) 2017, Alex Henderson 
%   Contact email: alex.henderson@manchester.ac.uk
%   Licenced under the GNU General Public License (GPL) version 3
%   http://www.gnu.org/copyleft/gpl.html
%   Other licensing options are available, please contact Alex for details
%   If you use this file in your work, please acknowledge the author(s) in
%   your publications. 
%
%   version 4.0 June 2017, Alex Henderson
%   The latest version of this file is available at:
%   https://bitbucket.org/AlexHenderson/renishaw-file-formats

%   version 4.0 June 2017, Alex Henderson
%       Changed default plotting option to make not plotting the output 
%       the default. 
%   version 3.2 April 2017, Alex Henderson
%       Fix for reading files in Linux. Bizarre problem when reading many
%       bytes using *char. Worked fine on Windows, but adds additional
%       characters in Linux. Now using uint8. This data wasn't used anyway,
%       but...
%   version 3.1 April 2017, Alex Henderson
%       Small changes in help info and code prettification. Title on plots
%       is now only the filename, not the path. Output badged as Raman
%       shift. 
%   version 3.0 July 2016, Alex Henderson
%       Added option not to plot the data.  
%   version 2.0 October 2015, Alex Henderson
%       Modified to handle files that contain one or more spectra rather
%       than an image.
%   version 1.1 August 2015, Alex Henderson
%       Added an empty block identifier which appears to accept files
%       acquired on a different instrument (785 nm laser in addition to 532
%       nm). Note these two files have different numbers of blocks. 
%   version 1.0 December 2014, Alex Henderson
%       Initial release.

%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
% Get the filename if not supplied
if ~exist('filename', 'var')
    filename = getfilename('*.spc', 'Thermo Scientific GRAMS Files (*.spc)');
    if (isfloat(filename) && (filename == 0))
        return;
    end
    filename = filename{1};
end

%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
% Determine which SPC readers are available 

if exist('tgspcread.m','file')
    try 
        [xvals,data,height,width,filename,acqdate,x_label,y_label] = tgspcreadWrapper(filename,plotContents);
    catch exception
        switch exception.identifier
            case 'MATLAB:license:checkouterror'
                % Try the GSSpcRead function
                if exist('GSSpcRead.m','file')
                    [xvals,data,height,width,filename,acqdate,x_label,y_label] = GSSpcReadWrapper(filename,plotContents);
                else
                    err = MException('CHI:thermoSpc:IOError', ...
                        'No code to read SPC files available');
                    throw(err);
                end
            otherwise
                rethrow(exception)
        end
    end
else
    if exist('GSSpcRead.m','file')
        [xvals,data,height,width,filename,acqdate,x_label,y_label] = GSSpcReadWrapper(filename,plotContents);
    else
        err = MException('CHI:thermoSpc:IOError', ...
            'No code to read SPC files available');
        throw(err);
    end
end

% Tidy up labels between the two possible parsers
if strfind(lower(x_label),'raman') %#ok<STRIFCND>
    x_label = 'Raman shift (cm^{-1})';
end
if strfind(lower(x_label),'wavenumber') %#ok<STRIFCND>
    x_label = 'wavenumbers (cm^{-1})';
end
if strfind(lower(y_label),'counts') %#ok<STRIFCND>
    y_label = 'counts';
end


% Force y-values to row vectors
[rows,cols] = size(data);
if (rows == cols)
    utilities.warningnobacktrace('Data matrix is square. Assuming spectra are in rows.');
else
    if (rows == length(xvals))
        data = data';
    end
end                      

if (xvals(end) < xvals(1))
    % flip was introduced in R2013b
    if iscolumn(xvals)
        xvals = flipud(xvals);
    else
        xvals = fliplr(xvals);
    end        
    data = fliplr(data);
end

xvals = utilities.force2row(xvals);

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
