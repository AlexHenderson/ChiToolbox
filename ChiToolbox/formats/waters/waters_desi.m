function [xvals,data,height,width,filenames,xlabel,xunit,ylabel,yunit] = waters_desi(varargin)

% waters_desi  File format handler for Waters DESI image files
% 
% Syntax
%   [xvals,data,height,width,filenames,xlabel,xunit,ylabel,yunit] = waters_desi()
%   [____] = waters_desi(filename)
%
% Notes
%   This function requires all the following to be true:
%    - The file to be opened is from a Desorption Electrospray Ionization
%      (DESI) imaging experiment, using a Waters instrument. 
%    - The data have been peak detected (centroided). 
%    - There is a subfolder of the DESI folder called 'imaging'.
%    - There is a text file in the imaging folder. 
% 
%   It is this text file that the function reads. Therefore the filename
%   parameter refers to this text (*.txt) file, and not the actual DESI
%   folder.
%
% Copyright (c) 2026, Alex Henderson.
% Licenced under the Apache License 2.0.
%
% See also 
%   ChiMSImage.

% Contact email: alex.henderson@manchester.ac.uk
% Licenced under the Apache License 2.0
% https://spdx.org/licenses/Apache-2.0.html
% Other licensing options are available, please contact Alex for details
% If you use this file in your work, please acknowledge the author(s) in
% your publications. 

% Version 1.0, May 2026
% The latest version of this file is available at:
% https://github.com/AlexHenderson/ChiToolbox


%% Get the filename if not supplied
if ~isempty(varargin)
    filenames = varargin{1};
else
    filter = ChiWatersFile.getExtension();
    filtername = ChiWatersFile.getFiltername();
    filenames = utilities.getfilename(filter, filtername);
end

if ~iscell(filenames)
    filenames = cellstr(filenames);
end

%% Read in the data
% Note readmatrix ignores the first row in the file since it only contains
% a string. Row numbers are relative to that, effectively starting at 0. 
m = readmatrix(filenames{1});

% The file appears to have a list of masses across the third row. 
% The spectra (intensities at each mass) are rows 4 and below.
% The x and y coordinates of the pixels/spectra are in columns 2 and 3.

%% Extract the mass and intensities
% This block includes the mass vector
data = m(3:end, 4:end-2); 

%% Sort the intensity positions according to their mass
% Transposing and back to enable use of sortrows command.
% Here we set the first column to the mass vectror, so we sort the data by
% mass.
data = sortrows(data')'; 

%% Separate the mass vector from the intensities
xvals = data(1,:);
data = data(2:end,:);

%% Read the x and y coordinates
xpositions = m(4:end, 2);
ypositions = m(4:end, 3);

%% Determine the number of x and y pixels
xpixels = length(unique(xpositions));
ypixels = length(unique(ypositions));

%% Reshape the data matrix
data = reshape(data, xpixels, ypixels, []);
data = permute(data, [2,1,3]);

%% Other information
height   = ypixels;
width    = xpixels;
xlabel   = 'm/z';
xunit    = 'amu';
ylabel   = 'intensity';
yunit    = 'counts';

end
