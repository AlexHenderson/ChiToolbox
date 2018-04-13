function [xvals,spectra,filenames,header,x_label,y_label] = mettlertoledofiles(filenames)

% not finished

% BIOTOFSPECTRA Reads the Biotof spectrum file format (Windows version)
% Version 1.1
%
% usage: 
% [mass,spectra,filenames] = biotofspectra(filenames);
% or
% [mass,spectra,filenames] = biotofspectra();
%  (The second version prompts for one or more file names.)
%
% Takes zero, one or more file names. 
% Returns:  'mass' a mass vector
%           'spectra' a matrix of spectra in rows
%           'filenames' a matrix of filenames used in the order the spectra
%           appear
% There is NO binning into fixed mass steps. Where the spectra are
% misaligned the data is interpolated (linearly). The maximum and minimum
% mass limits are determined by the spectrum with the smallest mass range,
% such that the spectra matrix only contains the mass range that overlaps
% all input spectra. The data are aligned such that each column of the
% spectra matrix corresponds to the same mass.
%
% Copyright (c) Alex Henderson, July 2013
% Version 1.1 

% Version 1.1  Alex Henderson, July 2013
%   Truncates the data if there are NaNs present in the first or
%   last data points of any interpolated spectrum.
% Version 1.0  Alex Henderson, June 2013
%   Incorporates version 1.2 of the original Biotof spectrum reader
%   'spectrum.m'


if (exist('filenames', 'var') == 0)
    filter = '*.asc';
    filtername = 'Mettler Toledo Files (*.asc)';
    filenames=getfilenames2(filter, filtername);
    if (isfloat(filenames) && (filenames==0))
        % Nothing chosen
        return;
    end
end

% filenames=char(filenames);
numberoffiles=size(filenames,1);

for i=1:numberoffiles

    % ToDo: match the x and y units, or throw an error
    [xvals_i,spectrum_i,unused,header,x_label,y_label] = mettlertoledo(filenames{i,:}); %#ok<ASGLU>
    if (i==1)
        % First time through we initialise the data array
        spectra = zeros(numberoffiles,length(spectrum_i));
        spectra(1,:) = spectrum_i;
        xvals = xvals_i;
    end
    
    needtointerpolate=0;
    if(length(xvals_i) ~= length(xvals))
        % Different number of data points, so we need to interpolate the
        % data. This is examined separately otherwise, if the two vectors
        % are of different length, MATLAB raises an error. 
        needtointerpolate = 1;
    else
        if(xvals_i ~= xvals)
            % Different values of mass, so we need to interpolate the data
            needtointerpolate = 1;
        end
    end
    
    if needtointerpolate
        % First determine the range over which the mismatched spectra
        % overlap. Then truncate both the mass vector and data matrix for
        % the data already processed and the new data.
        
       lowx = max(xvals(1), xvals_i(1));
       highx = min(xvals(end), xvals_i(end));
       
       idx = utilities.find_in_vector(xvals,[lowx,highx]);
       xvals = xvals(idx(1):idx(2));
       spectra = spectra(:,idx(1):idx(2));
       
       idx = utilities.find_in_vector(xvals_i,[lowx,highx]);
       xvals_i = xvals_i(idx(1):idx(2));
       spectrum_i = spectrum_i(idx(1):idx(2));
       
       % Now interpolate the new spectrum vector to match the existing
       % data.
       
       spectrum_i = interp1(xvals_i,spectrum_i,xvals,'linear');
    end
    
    spectra(i,:) = spectrum_i;
end

% Sometimes the interpolation turns up a NaN in either the first or last
% channel. Possibly both. Here we truncate the data to remove them. 
if find(isnan(spectra(:,1)))
    xvals = xvals(2:end);
    spectra = spectra(:,2:end);
end
if find(isnan(spectra(:,end)))
    xvals = xvals(1:end-1);
    spectra = spectra(:,1:end-1);
end

end % function mettlertoledofiles
