function [xvals,spectra,filenames,header,x_label,y_label] = mettlertoledofiles(filenames)

%  mettlertoledofiles  Reads multiple Mettler Toledo / Applied Systems .asc files
%   usage: 
%       [xvals,spectra,filenames,header,x_label,y_label] = mettlertoledofiles();
%       [xvals,spectra,filenames,header,x_label,y_label] = mettlertoledofiles(filenames);
%
%   input:
%   'filenames' cell array of filenames (optional - prompted if not supplied)
% 
%   output:
%   'xvals' is a list of the x-values related to the data
%   'spectra' is a matrix of spectra in rows
%   'filenames' is a cell array of strings containing the full path to the
%       .asc files
%   'header' is a struct containing various parameters within the files
%   'x_label' is the name of the unit on the x axis (eg. wavenumber)
%   'y_label' is the name of the unit on the y axis (eg absorbance)
%
% Where the spectra are misaligned the data is linearly interpolated. The
% maximum and minimum x-value limits are determined by the spectrum with
% the smallest range, such that the spectra matrix only contains the range
% that overlaps all input spectra. The data are aligned such that each
% column of the spectra matrix corresponds to the same x-value.
% 
%                     *******Caution******* 
%   This code is a hack of the Mettler Toledo / Applied Systems format.
%   There were very few example files and so the function may give spurious
%   results. If this is the case, please raise an issue at: 
%   https://github.com/AlexHenderson/ChiToolbox/issues
% 
%   Copyright (c) 2018, Alex Henderson 
%   Contact email: alex.henderson@manchester.ac.uk

%   Licenced under the GNU General Public License (GPL) version 3
%   http://www.gnu.org/copyleft/gpl.html
%   Other licensing options are available, please contact Alex for details
%   If you use this file in your work, please acknowledge the author(s) in
%   your publications. 
%
%   version 1.0 April 2018, Alex Henderson
%   The latest version of this file is available at:
%   https://github.com/AlexHenderson/ChiToolbox


if (exist('filenames', 'var') == 0)
    filter = '*.asc';
    filtername = 'Mettler Toledo Files (*.asc)';
    filenames = utilities.getfilenames(filter, filtername);
    if (isfloat(filenames) && (filenames==0))
        % Nothing chosen
        return;
    end
end

% filenames=char(filenames);
numberoffiles=size(filenames,1);

for i=1:numberoffiles

    % ToDo: match the x and y units, or throw an error
    [xvals_i,spectrum_i,unused,header,x_label,y_label] = mettlertoledo(filenames{i}); %#ok<ASGLU>
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
