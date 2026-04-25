function [imagedata, wavenumbers, width, height, totalimage, filename, miscs] = perkinelmerimage(filename)

%
% Reads the PerkinElmer image file format
% Version 1.0 (April 2026)
%
% syntax: [imagedata, wavenumbers, totalimage, filename, miscs] = perkinelmerimage(filename);
% or
% syntax: [imagedata, wavenumbers, totalimage, filename, miscs] = perkinelmerimage();
%
% The second version prompts for a filename. 
%
% Returns the following:
%   imagedata
%       A 3D matrix of spectra.
%   wavenumbers
%       A row vector of the wavenumbers. 
%   totalimage
%       A 2D matrix containing the sum of the intensity at each pixel.
%   filename
%       The location of the file opened.
%   miscs
%       Cell array of miscellaneous information from low level file parser.
%
%
% Version 1.0 (April 2026)
%   initial release
%
% Copyright (c) Alex Henderson, 2026
%

if (exist('filename', 'var') == 0)
    filename = getfilename(); % this function is below
end


[imagedata, width, height, wavenumbers, misc] = fsmload(filename);
miscs = {misc};
totalimage = sum(imagedata, 3);

end

%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
function [filename] = getfilename()

%
%   Usage: [filename] = getfilename();
%
%   Collects a filename from the user.
%   'filename' is a char array
%
%   (c) Apr 2008, Alex Henderson
%

filetypes = {   '*.fsm',  'PerkinElmer Image Files (*.fsm)'; ...
                '*.*',    'All Files (*.*)'};

[filename, pathname] = uigetfile(filetypes, 'Select file...', 'MultiSelect', 'off');
filename = char([pathname filename]);
end
%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
