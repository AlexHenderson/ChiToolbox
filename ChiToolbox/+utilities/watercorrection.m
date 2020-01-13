function [corrected,coeffs] = watercorrection(data,waterref,organicref,varargin)

% No help yet :-)    
    
if isempty(waterref)
    p = mfilename('fullpath');
    [filepath] = fileparts(p);
    waterref = ChiFile(fullfile(filepath,'WATER ATR cor.spc'));
end

if isempty(organicref)
    p = mfilename('fullpath');
    [filepath] = fileparts(p);
    locationofrmiesmatrigel = fullfile(filepath,'../external/github/GardnerLabUoM/RMieS/private','Matrigel_Reference_Raw.mat');
    matrigel = load(locationofrmiesmatrigel);
    organicref = ChiIRSpectrum(matrigel.ZRef_Raw(:,1),matrigel.ZRef_Raw(:,2));    
end

%% Select a spectral range of interest
lowwavenumber = 1000;
highwavenumber = 3800;
amideIIlowwavenumber = 1480;
amideIIhighwavenumber = 1596;
    
%% Combine and pre-process data
% We combine everything to ensure any interpolation is consistent
% Data is added before the model since the interpolation isn't ready for
% multiple spectra yet
alldata = ChiIRSpectralCollection();
alldata = alldata.append(data);
alldata = alldata.append(waterref);
alldata = alldata.append(organicref);

% preprocess
alldata.keeprange(lowwavenumber,highwavenumber);
alldata.removeco2;

% Separate the model from the data we wish to fit
originaldata = alldata.clone;
originalwater = originaldata.spectrumat(alldata.numspectra-1);

originaldata.removespectra(originaldata.numspectra);
originaldata.removespectra(originaldata.numspectra);

%% Crop working data to amideII range
alldata.keeprange(amideIIlowwavenumber,amideIIhighwavenumber);

%% Build model
water = alldata.spectrumat(alldata.numspectra-1);
organic = alldata.spectrumat(alldata.numspectra);
model = water.clone;
model = model.append(organic);

%% Isolate data
spectra = alldata.clone;
spectra.removespectra(spectra.numspectra);
spectra.removespectra(spectra.numspectra);

%% Work out weights
[coeffs] = lscov(model.data', spectra.data');

%% Determine the contribution of water
% Water is the first entry/row in the model
waterContrib = coeffs(1,:)' * originalwater.data;

%% Do stuff
corrected = clone(originaldata);
corrected.data = corrected.data - waterContrib;

end
