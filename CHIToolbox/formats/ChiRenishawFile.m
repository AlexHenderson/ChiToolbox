function obj = ChiRenishawFile(filename)
% ChiRenishawFile File format handler for Renishaw files
% usage:
%   myfile = ChiRenishawFile();
%   myfile = ChiRenishawFile(filename);
% Copyright (c) 2017 Alex Henderson (alex.henderson@manchester.ac.uk)

if exist('filename', 'var')
    [ramanshift,data,height,width,filename,acqdate,x_label,y_label] = renishawWire(filename,false); %#ok<ASGLU>
else
    [ramanshift,data,height,width,filename,acqdate,x_label,y_label] = renishawWire(); %#ok<ASGLU>
end

if ((height == 1) && (width == 1))
    % We have one or more spectra rather than an image
    % Check to see if we have a single spectrum or a profile
    if (numel(data) == numel(ramanshift))
        obj = ChiSpectrum(ramanshift,data,true,x_label,y_label,width,height);
        obj.filename = filename;
    else
        obj = ChiSpectralCollection(ramanshift,data,true,x_label,y_label,width,height);
    end               
else
    obj = ChiImage(ramanshift,data,true,x_label,y_label,width,height);
end

obj.filename = filename;
obj.history.add(['filename: ', filename]);
