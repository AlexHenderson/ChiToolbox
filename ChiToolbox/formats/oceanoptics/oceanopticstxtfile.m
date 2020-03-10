function [xvals,yvals,info] = oceanopticstxtfile(filename)

% oceanopticstxtfile  Reads an Ocean Optics spectral file
% 
% Usage: 
%   [xvals, yvals, info] = oceanopticstxtfile();
%   [xvals, yvals, info] = oceanopticstxtfile(filename);
%
% Purpose:
%   Extracts a spectrum from an Ocean Optics (now Ocean Insight) text file.
%
%  input:
%   'filename' string containing the full path to a .txt file (optional)
% 
%  output:
%   'xvals' are the x-axis values, typically wavelength in nm (row vector)
%   'yvals' are the intensity values (row vector)
%   'info' is a cell array of strings containing additional information
%   contained in the file
%
%                     *******Caution******* 
%   This code is a hack of the Ocean Optics (now Ocean Insight) format and
%   so there may be files that cannot be opened using this function.
%   Always check the output to make sure it is sensible. If you have a file
%   that doesn't work, please contact Alex.
%
%   Copyright (c) 2020, Alex Henderson 
%   Contact email: alex.henderson@manchester.ac.uk
%   Licenced under the GNU General Public License (GPL) version 3
%   http://www.gnu.org/copyleft/gpl.html
%   Other licensing options are available, please contact Alex for details
%   If you use this file in your work, please acknowledge the author(s) in
%   your publications. 


% The Ocean Optics text file line endings are all mixed up. The first line
% ends 0A0D (whatever that is!), the rest of the header is 0A with the data
% (x-y pairs) ending 0D0A. The x-y pairs are tab delimited. 

% Requires MATLAB R2016b or greater (split command)


if iscell(filename)
    filename = filename{1};
end

info = cell(1,2);

info{1,1} = 'Description';
info{1,2} = '';
info{2,1} = 'Filename';
info{2,2} = filename;

xvals = [];
yvals = [];

try
fid = fopen(filename, 'rt', 'ieee-le');

finishedheader = false;
firstpass = true;
while ~finishedheader
    line = fgetl(fid);
    if (line == -1)
        throw 'end of file?'
    end
        
    if strcmpi(line, '>>>>>Begin Spectral Data<<<<<')
        finishedheader = true;
    else
        if firstpass
            info{1,2} = line;
            firstpass = false;
        else
            % Parse header lines
            splitline = split(line,': ');
            if strcmpi(splitline{1}, 'ate')
                splitline{1} = 'Date';
            end
            info = vertcat(info,{splitline{1},splitline{2}}); %#ok<AGROW>
        end
    end
end

% Read the data
data = textscan(fid, '%f\t%f');
data = cell2mat(data);

xvals = data(:,1)';
yvals = data(:,2)';

fclose(fid);

catch ex
    
    if exist('fid','var')
        fclose(fid);
    end    
    
end

end
