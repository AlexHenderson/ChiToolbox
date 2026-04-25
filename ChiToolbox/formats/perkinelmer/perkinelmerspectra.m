function [wavenumbers,spectra,filenames,miscs] = perkinelmerspectra(filenames)
% PERKINELMERSPECTRA Reads the perkinelmer spectrum file format
% Version 1.0
%
% usage: 
% [wavenumbers,spectra,filenames,miscs] = perkinelmerspectra(filenames);
% or
% [wavenumbers,spectra,filenames,miscs] = perkinelmerspectra();
%  (The second version prompts for one or more file names.)
%
% Takes zero, one or more file names. 
% Returns:  'wavenumbers' a row vector of wavenumbers
%           'spectra' a matrix of spectral intensities in rows
%           'filenames' a matrix of filenames used in the order the spectra
%           appear
%           'miscs' a cell array of miscellaneous information from low 
%           level file parser. 
% 
% Notes
% Where the spectra are misaligned, the data is interpolated (linearly).
% The maximum and minimum wavenumber limits are determined by the spectrum
% with the smallest wavenumber range, such that the spectra matrix only
% contains the wavenumber range that overlaps all input spectra. The data
% are aligned such that each column of the spectra matrix corresponds to
% the same wavenumber.
%
% Copyright (c) Alex Henderson, April 2026
% Version 1.0 

% Version 1.0  Alex Henderson, April 2026
%   Initial release


if (exist('filenames', 'var') == 0)
    filter = '*.sp';
    filtername = 'PerkinElmer Spectral Files (*.sp)';
    filenames=getfilenames2(filter, filtername);
    if (isfloat(filenames) && (filenames==0))
        % Nothing chosen
        return;
    end
end


% Make sure we have a cell array of filenames
if ~iscell(filenames)
    filenames = cellstr(filenames);
end

numberoffiles=length(filenames);

for i=1:numberoffiles

    [spectrum_i, wavenumbers_i, misc_i] = spload(filenames{i}); 

    if (i==1)
        % First time through we initialise the data array
        spectra = zeros(numberoffiles,length(spectrum_i));
        miscs = cell(numberoffiles,1);
        spectra(1,:) = spectrum_i;
        wavenumbers = wavenumbers_i;
        miscs{1} = misc_i;
    end
    
    needtointerpolate=0;
    if(length(wavenumbers_i) ~= length(wavenumbers))
        % Different number of data points, so we need to interpolate the
        % data. This is examined separately otherwise, if the two vectors
        % are of different length, MATLAB raises an error. 
        needtointerpolate=1;
    else
        if(wavenumbers_i ~= wavenumbers)
            % Different values of wavenumbers, so we need to interpolate the data
            needtointerpolate=1;
        end
    end
    
    if(needtointerpolate)
        % First determine the range over which the mismatched spectra
        % overlap. Then truncate both the wavenumbers vector and data matrix for
        % the data already processed and the new data.
        
       lowwavenumbers = max(wavenumbers(1), wavenumbers_i(1));
       highwavenumbers = min(wavenumbers(end), wavenumbers_i(end));
       
       idx = utilities.find_in_vector(wavenumbers,[lowwavenumbers, highwavenumbers]);
       wavenumbers = wavenumbers(idx(1):idx(2));
       spectra = spectra(:,idx(1):idx(2));
       
       idx = utilities.find_in_vector(wavenumbers_i,[lowwavenumbers, highwavenumbers]);
       wavenumbers_i = wavenumbers_i(idx(1):idx(2));
       spectrum_i = spectrum_i(idx(1):idx(2));
       
       % Now interpolate the new spectrum vector to match the existing
       % data.
       
       spectrum_i = interp1(wavenumbers_i, spectrum_i, wavenumbers, 'linear');
    end
    
    spectra(i,:) = spectrum_i;
    miscs{i,1} = misc_i;
end

% Sometimes the interpolation turns up a NaN in either the first or last
% channel. Possibly both. Here we truncate the data to remove them. 
if(find(isnan(spectra(:,1))))
    wavenumbers = wavenumbers(2:end);
    spectra = spectra(:,2:end);
end
if(find(isnan(spectra(:,end))))
    wavenumbers = wavenumbers(1:end-1);
    spectra = spectra(:,1:end-1);
end

end % function perkinelmerspectra
