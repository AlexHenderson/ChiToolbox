function output = ChiMatch(image,spectrum,comparison)

%ChiCompare SpectralMatch of inputs
% Reference: 
% Optimization and Testing of Mass Spectral Library Search Algorithms for
% Compound Identification 
% S.E. Stein and D.R. Scott 
% Journal of the American Society for Mass Spectrometry 5 (1994) 859-866 
% DOI: 10.1016/1044-0305(94)87009-8
%   Copyright (c) 2014 Alex Henderson (alex.henderson@manchester.ac.uk)


if ~isa(image,'ChiImage')
    err = MException('CHI:ChiMatch:TypeError', ...
        'First input should be a ChiImage');
    throw(err);
end
if ~isa(spectrum,'ChiSpectrum')
    err = MException('CHI:ChiMatch:TypeError', ...
        'Second input should be a ChiSpectrum');
    throw(err);
end

if (image.channels == spectrum.channels)

    switch lower(comparison)
        case 'cosine'
            pixels = image.xpixels * image.ypixels;
            
            image_x_spectrum = image.data .* repmat(spectrum.data, pixels,1);
            sum_image_x_spectrum = sum(image_x_spectrum,2);
            numerator = sum_image_x_spectrum .* sum_image_x_spectrum;

            sum_of_image_squared = sum(image.data .* image.data, 2);
            sum_of_spectrum_squared = sum(spectrum.data .* spectrum.data, 2);
            denominator = sum_of_image_squared .* sum_of_spectrum_squared;

            result = numerator ./ denominator;
            
        otherwise
            err = MException('CHI:ChiMatch:ToDo', ...
                'Can only handle cosine matching at the moment');
            throw(err);
    end
    
else
    err = MException('CHI:ChiMatch:DimensionalityError', ...
        'Spectral lengths are different');
    throw(err);
end
    
output = ChiPicture(result,image.xpixels,image.ypixels);
output.history.add(['Generated a ', comparison, ' match']');
