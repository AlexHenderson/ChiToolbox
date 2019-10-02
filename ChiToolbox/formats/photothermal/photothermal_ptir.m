function [measurements] = photothermal_ptir(filename)

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
% height = 1;
% width = 1;

%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
% Read the file

fileinfo = h5info(filename);

[numgroups,dummy] = size(fileinfo.Groups); %#ok<ASGLU>

measurements = {}; 

for group = 1:numgroups
    groupname = fileinfo.Groups(group).Name;
    
    % Test first 6 characters since the Measurement groups have different
    % names
    switch groupname(1:6)
        case '/Measu'   % /Measurement_000 Spectral or hyperspectral measurement
            [measurement.xvals,measurement.data, ...
                measurement.height,measurement.width, ...
                measurement.filename, ...
                measurement.xlabel,measurement.xunit, ...
                measurement.ylabel,measurement.yunit, ...
                measurement.datatype,measurement.measurementlabel] ...
                    = photothermal_ptir_measurement(filename, groupname);

            measurements{end+1,1} = measurement; %#ok<AGROW>

        case '/Heigh'   % /Heightmap_000 Single wavenumber image
            datasets = fileinfo.Groups(group).Datasets;
            for d = 1:size(datasets,1)
                name = datasets(d).Name;
                data = h5read(filename,[groupname,'/',name]);
                pic = ChiPicture(data);
                try
                    wavenumber = h5readatt(filename,[groupname,'/',name],'IRWavenumber');
                catch
                    wavenumber = 'unknown';
                end
                pic.history.add(['Filename: ', filename]);
                pic.history.add(['Heightmap: ', name]);
                pic.history.add(['Wavenumber: ', wavenumber]);
                measurements{end+1,1} = pic; %#ok<AGROW>
            end
        case '/Image'   % /Images Camera (visible) image
            datasets = fileinfo.Groups(group).Datasets;
            for d = 1:size(datasets,1)
                name = datasets(d).Name;
                data = h5read(filename,[groupname,'/',name]);
                data = permute(data,[3,2,1]);
                data = data(:,:,1:3);
                im = ChiImageFile(data);
                im.filenames{1} = filename;
                im.history.add(['Filename: ', filename]);
                im.history.add(['Image: ', name]);
                measurements{end+1,1} = im; %#ok<AGROW>
            end
        case '/Views'   % /Views Internal Photothermal parameters, probably screen info
        otherwise
    end
end
