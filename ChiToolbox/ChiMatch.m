function output = ChiMatch(library,spectrum,comparison)

%ChiCompare SpectralMatch of inputs
% Reference: 
% Optimization and Testing of Mass Spectral Library Search Algorithms for
% Compound Identification 
% S.E. Stein and D.R. Scott 
% Journal of the American Society for Mass Spectrometry 5 (1994) 859-866 
% DOI: 10.1016/1044-0305(94)87009-8
%   Copyright (c) 2014 Alex Henderson (alex.henderson@manchester.ac.uk)


if ~(isa(library,'ChiImage') || isa(library,'ChiSpectralCollection') || isa(library,'ChiSpectrum'))
    err = MException(['CHI:',mfilename,':TypeError'], ...
        'First input should be a ChiSpectrum, a ChiSpectralCollection, or a ChiImage');
    throw(err);
end
if ~isa(spectrum,'ChiSpectrum')
    err = MException(['CHI:',mfilename,':TypeError'], ...
        'Second input should be a ChiSpectrum');
    throw(err);
end

if ~exist('comparison','var')
    comparison = 'cosine';
end

if (library.numchannels == spectrum.numchannels)

    switch lower(comparison)
        case 'cosine'
            result = utilities.cosinematch(library.data,spectrum.data);
            
        otherwise
            err = MException('CHI:ChiMatch:ToDo', ...
                'Can only handle cosine matching at the moment');
            throw(err);
    end
    
else
    err = MException(['CHI:',mfilename,':DimensionalityError'], ...
        'Spectral lengths are different');
    throw(err);
end
    
if isa(library,'ChiImage')
    output = ChiPicture(result,library.xpixels,library.ypixels);
    output.history.add(['Generated a ', comparison, ' match']');
else
    % ChiSpectralCollection
    output = result;    
end
