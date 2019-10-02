function [xvals,data,height,width,filename,xlabel,xunit,ylabel,yunit,datatype,measurementlabel] = photothermal_ptir_measurement(filename, measurement_name)

% Help not written yet
    
%   Function: photothermal_ptir
%   Usage: [xvals,data,height,width,filename,x_label,y_label,type] = photothermal_ptir();
%   Usage: [xvals,data,height,width,filename,x_label,y_label,type] = photothermal_ptir(filename);
%
%   Extracts the data from an Photothermal .ptir file.
%
%   input:
%   'filename' string containing the full path to the .ptir file (optional)
% 
%   output:
%   'xvals' is a list of the x-axis values
%   'data' is a 2D matrix of spectra in rows
%   'height' is the height of the image in pixels (number of rows)
%   'width' is the width of the image in pixels (number of columns)
%   'filename' is a string containing the full path to the .hd5 file
%   'x_label' is the name of the unit on the x axis (IR or Raman)
%   'y_label' is the name of the unit on the y axis (intensity)
%   'type' is the method of acquisition: 'IR' or 'Raman'
% 
%   Copyright (c) 2019, Alex Henderson 
%   Contact email: alex.henderson@manchester.ac.uk
%   Licenced under the GNU General Public License (GPL) version 3
%   http://www.gnu.org/copyleft/gpl.html
%   Other licensing options are available, please contact Alex for details
%   If you use this file in your work, please acknowledge the author(s) in
%   your publications. 
%
%   The latest version of this file is available on Bitbucket
%   https://bitbucket.org/AlexHenderson/renishaw-file-formats


%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
% Get the filename if not supplied
if ~exist('filename', 'var')
    filename = getfilename('*.ptir', 'Photothermal Files (*.ptir)');
    if (isfloat(filename) && (filename == 0))
        return;
    end
    filename = filename{1};
end

%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
% Define some defaults
height = 1;
width = 1;

%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
% Read the file

% Read user-defined data label
measurementlabel = h5readatt(filename,measurement_name,'Label'); 

% Work out the spectroscopy type
datatype = 'Infrared';  % Probably
try
    type = h5readatt(filename,measurement_name,'IsBackground');
    if type
        datatype = 'Background';
    end
catch
   % Not a Background 
end

try
    type = h5readatt(filename,measurement_name,'IsRaman');
    if type
        datatype = 'Raman';
    end
catch
   % Not a Raman data set
end

xvals = h5read(filename,[measurement_name,'/Spectroscopic_Values']);
xvals = double(xvals);

width = 1;
height = 1;
xy = h5read(filename,[measurement_name,'/Position_Indices']);
if ~isscalar(xy)
    width = xy(1,end) + 1;
    height = xy(2,end) + 1;
end

data = h5read(filename,[measurement_name,'/Channel_000/Raw_Data']);
data = data';
data = reshape(data,width,height,[]);
data = rot90(data);
data = squeeze(data);
data = double(data);

xlabel = 'measurement';
xunit = '';
xunits = h5readatt(filename,[measurement_name,'/Spectroscopic_Values'],'units');
if iscell(xunits)
    if (xunits{1} == 'c' && ...
        xunits{2} == 'm' && ...
        xunits{3} == '?' && ...
        xunits{4} == '¹')
        xlabel = 'wavenumber';
        xunit = 'cm^{-1}';
    else
        if (xunits{1} == 'c' && ...
            xunits{2} == 'm' && ...
            xunits{3} == '-' && ...
            xunits{4} == '1')
            xlabel = 'wavenumber';
            xunit = 'cm^{-1}';
        else
            xunit = cell2mat(xunits)';
        end
    end
end

try
    ylabel = h5readatt(filename,[measurement_name,'/Channel_000'],'Label');
    
    % Remove any empty parentheses from, for example, 'Raman Intensity ()'
    ylabel = regexprep(ylabel, ' \(\)', '');
    % Remove additional units from, for example, 'Mirage Amp (mV)'
    ylabel = regexprep(ylabel, ' \(mV\)', '');
    
catch
    ylabel = 'measurement';
end

yunit = h5readatt(filename,[measurement_name,'/Channel_000/Raw_Data'],'units');

% Handle NULL string
if (dec2hex(yunit) == '0')
    yunit = '';
end
