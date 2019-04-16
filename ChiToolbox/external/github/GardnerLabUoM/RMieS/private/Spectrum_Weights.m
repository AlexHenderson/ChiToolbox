function [ZWeightsSpec] = Spectrum_Weights(Spectra)
% Usage: [ZWeightsSpec] = Spectrum_Weights(Spectra)
% - Just enter the Saisir structure of Spectra to be corrected
% - Output is a Saisir Structure for the Weights



[N,M] = size(Spectra.d);

ZWeightsSpec.d = ones(1,M);
ZWeightsSpec.v = Spectra.v;
ZWeightsSpec.i = 'Weightings';