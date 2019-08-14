function [xvals,data,height,width,filename,xlabel,xunit,ylabel,yunit,datatype] = photothermal_ptir(filename)

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
height = 1; %#ok<NASGU>
width = 1; %#ok<NASGU>

%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
% Read the file

% fileinfo = h5info(filename);

datatype = h5readatt(filename,'/Measurement_000','Label'); % Hyperspectral Measurement

xvals = h5read(filename,'/Measurement_000/Spectroscopic_Values');
xvals = double(xvals);

xy = h5read(filename,'/Measurement_000/Position_Indices');
if ~isscalar(xy)
    width = xy(1,end) + 1;
    height = xy(2,end) + 1;
end

data = h5read(filename,'/Measurement_000/Channel_000/Raw_Data');
data = data';
data = reshape(data,width,height,[]);
data = rot90(data);
data = double(data);
data = squeeze(data);

xlabel = 'wavenumber';
xunits = h5readatt(filename,'/Measurement_000/Spectroscopic_Values','units');
xunit = '';
if iscell(xunits)
    if (xunits{1} == 'c' && ...
        xunits{2} == 'm' && ...
        xunits{3} == '?' && ...
        xunits{4} == '¹')
        xunit = 'cm^{-1}';
    end
end

ylabel = h5readatt(filename,'/Measurement_000/Channel_000','Label');
yunit = h5readatt(filename,'/Measurement_000/Channel_000/Raw_Data','units');

%  x = ChiIRImage(xvals,data,height,width,true,xlabel,xunit,ylabel,yunit);
