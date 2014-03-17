function [ output ] = ChiSumNormalise( spectrum )
%CHISUMNORMALISE Normalise data to unity
%   Detailed explanation goes here

if(~isa(spectrum,'ChiSpectrum'))
    err = MException('CHI:ChiSumNormalise:WrongDataType', ...
        'Input is not a ChiSpectrum');
    throw(err);
end

output = spectrum;
output.yvals = output.yvals / output.sum();

end

