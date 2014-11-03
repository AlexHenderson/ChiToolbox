function [ output ] = ChiSumNormalise( spectrum )
%CHISUMNORMALISE Normalise data to unity
%   Copyright (c) 2014 Alex Henderson (alex.henderson@manchester.ac.uk)

if(~isa(spectrum,'ChiSpectrum'))
    err = MException('CHI:ChiSumNormalise:WrongDataType', ...
        'Input is not a ChiSpectrum');
    throw(err);
end

output = spectrum;
output.yvals = output.yvals / output.sum();

end

