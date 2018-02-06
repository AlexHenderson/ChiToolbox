function [mass,spectra,filenames] = biotofspectra(filenames)
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
    filter = '*.dat';
    filtername = 'Biotof Spectral Files (*.dat)';
    filenames=getfilenames2(filter, filtername);
    if (isfloat(filenames) && (filenames==0))
        % Nothing chosen
        return;
    end
end

filenames=char(filenames);
numberoffiles=size(filenames,1);

for i=1:numberoffiles

    [mass_i, spectrum_i, acqdatetime] = biotofspectrum(filenames(i,:));
    if (i==1)
        % First time through we initialise the data array
        spectra=zeros(numberoffiles,length(spectrum_i));
        spectra(1,:)=spectrum_i;
        mass=mass_i;
    end
    
    needtointerpolate=0;
    if(length(mass_i) ~= length(mass))
        % Different number of data points, so we need to interpolate the
        % data. This is examined separately otherwise, if the two vectors
        % are of different length, MATLAB raises an error. 
        needtointerpolate=1;
    else
        if(mass_i ~= mass)
            % Different values of mass, so we need to interpolate the data
            needtointerpolate=1;
        end
    end
    
    if(needtointerpolate)
        % First determine the range over which the mismatched spectra
        % overlap. Then truncate both the mass vector and data matrix for
        % the data already processed and the new data.
        
       lowmass=max(mass(1), mass_i(1));
       highmass=min(mass(end), mass_i(end));
       
       idx=find_value2(mass,[lowmass,highmass]);
       mass=mass(idx(1):idx(2));
       spectra=spectra(:,idx(1):idx(2));
       
       idx=find_value2(mass_i,[lowmass,highmass]);
       mass_i=mass_i(idx(1):idx(2));
       spectrum_i=spectrum_i(idx(1):idx(2));
       
       % Now interpolate the new spectrum vector to match the existing
       % data.
       
       spectrum_i=interp1(mass_i,spectrum_i,mass,'linear');
    end
    
    spectra(i,:)=spectrum_i;
end

% Sometimes the interpolation turns up a NaN in either the first or last
% channel. Possibly both. Here we truncate the data to remove them. 
if(find(isnan(spectra(:,1))))
    mass=mass(2:end);
    spectra=spectra(:,2:end);
end
if(find(isnan(spectra(:,end))))
    mass=mass(1:end-1);
    spectra=spectra(:,1:end-1);
end

end % function biotofspectrum
