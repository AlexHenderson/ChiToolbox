function [mass,data,height,width,layers,filename,x_label,y_label] = ionoptika_hd5file(filename)

%   Function: ionoptika_hd5file
%   Usage: [mass,data,height,width,layers,filename,x_label,y_label] = ionoptika_hd5file();
%   Usage: [mass,data,height,width,layers,filename,x_label,y_label] = ionoptika_hd5file(filename);
%
%   Extracts the data from an Ionoptika .hd5 file.
%
%   input:
%   'filename' string containing the full path to the .hd5 file (optional)
% 
%   output:
%   'mass' is a list of the mass values
%   'data' is a 2D matrix of spectra in rows
%   'height' is the height of the image in pixels (number of rows)
%   'width' is the width of the image in pixels (number of columns)
%   'layers' is the depth of the image. Layer 1 is the surface
%   'filename' is a string containing the full path to the .hd5 file
%   'x_label' is the name of the unit on the x axis (m/z)
%   'y_label' is the name of the unit on the y axis (intensity)
% 
%   Depth profiles are not handled yet.     
%
%   Copyright (c) 2017, Alex Henderson 
%   Contact email: alex.henderson@manchester.ac.uk
%   Licenced under the GNU General Public License (GPL) version 3
%   http://www.gnu.org/copyleft/gpl.html
%   Other licensing options are available, please contact Alex for details
%   If you use this file in your work, please acknowledge the author(s) in
%   your publications. 
%
%   version 1.0 September 2017, Alex Henderson
%   The latest version of this file is available on Bitbucket
%   https://bitbucket.org/AlexHenderson/renishaw-file-formats


%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
% Get the filename if not supplied
if ~exist('filename', 'var')
    filename = getfilename('*.hd5', 'Ionoptika Files (*.hd5)');
    if (isfloat(filename) && (filename == 0))
        return;
    end
    filename = filename{1};
end

%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
% Define some defaults
height = 1; %#ok<NASGU>
width = 1; %#ok<NASGU>
layers = 1; % This code doesn't handle depth profiles yet. 

%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
% Read the file
mass = h5read(filename,'/massArray');

data = h5read(filename,'/spectrumArray'); % Takes a while to read, so only do this when necesssary
data = data';

width = h5readatt(filename,'/spectrumArray','rasterWidth');
height = h5readatt(filename,'/spectrumArray','rasterHeight');

x_label = 'm/z (amu)';
y_label = 'intensity';
