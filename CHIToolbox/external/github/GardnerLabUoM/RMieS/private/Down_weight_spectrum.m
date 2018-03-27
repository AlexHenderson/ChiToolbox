function [ZWeightsSpec] = Down_weight_spectrum(ZWeightsSpec , min , max , value)
% Usage: [ZWeightsSpec] = Down_weight_spectrum(Spectra)
% - Just enter the Saisir structure of ZWeightsSpec
% - Output is a Saisir Structure for the new Weights

WN = str2num(ZWeightsSpec.v);

[t1 t2] = find_value_min_max(WN , min, max);

ZWeightsSpec.d(t1:t2) = value;



