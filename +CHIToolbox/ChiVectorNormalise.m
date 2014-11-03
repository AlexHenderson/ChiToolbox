function [ output ] = ChiVectorNormalise( spectrum )
%CHIVECTORNORMALISE Vector normalisation (CytoSpec version)
%   See: http://www.cytospec.com/specpreproc.php#PreprocNorm
%   Copyright (c) 2014 Alex Henderson (alex.henderson@manchester.ac.uk)

if(~isa(spectrum,'ChiSpectrum'))
    err = MException('CHI:ChiSumNormalise:WrongDataType', ...
        'Input is not a ChiSpectrum');
    throw(err);
end

output = spectrum;

% subtract the mean intensity
output.yvals = output.yvals - mean(output.yvals);

% square the intensities
output.yvals = output.yvals .^2;

% determine the sum of the intensities
total = output.sum();

% normalise to this total
output.yvals = output.yvals / total;


end

