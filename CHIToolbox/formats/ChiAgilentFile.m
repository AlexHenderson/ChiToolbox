function obj = ChiAgilentFile(filename)
% ChiAgilentFile File format handler for Agilent files
% usage:
%   myfile = ChiAgilentFile();
%   myfile = ChiAgilentFile(filename);
% Copyright (c) 2017 Alex Henderson (alex.henderson@manchester.ac.uk)

if exist('filename', 'var')
    [wavenumbers, data, height, width, filename, acqdate] = agilentFile(filename); %#ok<ASGLU>
else
    [wavenumbers, data, height, width, filename, acqdate] = agilentFile(); %#ok<ASGLU>
end

obj = ChiImage(wavenumbers,data,true,'wavenumber (cm^{-1})','absorbance',width,height);
obj.filename = filename;
obj.history.add(['filename: ', filename]);
