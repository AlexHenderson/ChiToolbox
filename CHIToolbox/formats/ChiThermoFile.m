function obj = ChiThermoFile(filename)
% ChiThermoFile File format handler for Thermo Scientific files
% usage:
%   myfile = ChiThermoFile();
%   myfile = ChiThermoFile(filename);
% Copyright (c) 2017 Alex Henderson (alex.henderson@manchester.ac.uk)

if exist('filename', 'var')
    [xvals,data,height,width,filename,acqdate,x_label,y_label] = thermoFile(filename); %#ok<ASGLU>
else
    [xvals,data,height,width,filename,acqdate,x_label,y_label] = thermoFile(); %#ok<ASGLU>
end

if ((height == 1) && (width == 1))
    % We have one or more spectra rather than an image
    % Check to see if we have a single spectrum or a profile
    if (numel(data) == numel(xvals))
        obj = ChiSpectrum(xvals,data,true,x_label,y_label,filename);
    else
        obj = ChiSpectralCollection(xvals,data,true,x_label,y_label);
    end               
else
    obj = ChiImage(xvals,data,true,x_label,y_label,width,height);
end

obj.filename = filename;
obj.history.add(['filename: ', filename]);
