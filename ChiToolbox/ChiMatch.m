function output = ChiMatch(collection,spectrum,comparison)

% ChiMatch  Performs a comparison between a spectrum and a collection of spectra
% 
% Syntax
%   output = ChiMatch(collection,spectrum);
%   output = ChiMatch(collection,spectrum,comparison);
%
% Description
%   output = ChiMatch(collection,spectrum) performs a vector angle
%   comparison between spectrum and collection. spectrum is a ChiSpectrum
%   and collection can be a ChiSpectrum, a ChiSpectralCollection, or a
%   ChiImage. 
%   Where collection is a ChiSpectrum, or a ChiSpectralCollection, output
%   is a column vector of cosine values (see below). Where collection is a
%   ChiImage, output is a ChiPicture showing the spatial distribution of
%   cosine values.
% 
%   output = ChiMatch(collection,spectrum,comparison) allows for
%   alternative matching methods. Currently only 'cosine' is supported. 
% 
% Notes
%   The comparison method is a cosine match, sometimes called the dot
%   product. Here we consider each spectrum as a vector and measure the
%   angle between them. The output is the cosine of this angle. Therefore,
%   if two spectra are very similar they will have a small vector angle and
%   consequently a cosine match of near 1. A paper discussing this is
%     'Optimization and Testing of Mass Spectral Library Search Algorithms
%     for Compound Identification' by S.E. Stein and D.R. Scott 
%     Journal of the American Society for Mass Spectrometry 5 (1994) 
%      859-866 DOI: 10.1016/1044-0305(94)87009-8
%
% Copyright (c) 2009-2019, Alex Henderson.
% Licenced under the GNU General Public License (GPL) version 3.
%
% See also 
%   utilities.cosinematch.

% Contact email: alex.henderson@manchester.ac.uk
% Licenced under the GNU General Public License (GPL) version 3
% http://www.gnu.org/copyleft/gpl.html
% Other licensing options are available, please contact Alex for details
% If you use this file in your work, please acknowledge the author(s) in
% your publications. 

% The latest version of this file is available on Bitbucket
% https://bitbucket.org/AlexHenderson/chitoolbox


if ~(isa(collection,'ChiImage') || isa(collection,'ChiSpectralCollection') || isa(collection,'ChiSpectrum'))
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

if (collection.numchannels == spectrum.numchannels)

    switch lower(comparison)
        case 'cosine'
            result = utilities.cosinematch(collection.data,spectrum.data);
            
        otherwise
            err = MException(['CHI:',mfilename,':ToDo'], ...
                'Can only handle cosine matching at the moment');
            throw(err);
    end
    
else
    err = MException(['CHI:',mfilename,':DimensionalityError'], ...
        'Spectral lengths are different');
    throw(err);
end
    
if isa(collection,'ChiImage')
    output = ChiPicture(result,collection.xpixels,collection.ypixels);
    output.history.add(['Generated a ', comparison, ' match']');
else
    % ChiSpectralCollection
    output = result;    
end
