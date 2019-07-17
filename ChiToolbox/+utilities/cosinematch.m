function [result] = cosinematch(library, unknown)

% cosinematch
%
% Calculates the dot product of an unknown spectrum against a collection of
% standard spectra held in a library. 
%
% usage: [result] = cosinematch(library, unknown);
%
%   - library is a collection of standard spectra in rows
%   - unknown is the spectrum of the unknown as a row vector
%   - result is the output of the spectral match for each spectrum in the
%       library where a larger number means a better match. The result will
%       be between 0 and 1.
%
% Reference: 
% Optimization and Testing of Mass Spectral Library Search Algorithms for
% Compound Identification 
% S.E. Stein and D.R. Scott 
% Journal of the American Society for Mass Spectrometry 5 (1994) 859-866 
% DOI: 10.1016/1044-0305(94)87009-8
%
% Version 1.0
%
% Alex Henderson, November 2009


[number_of_library_spectra, library_mass_channels] = size(library);

% make sure unknown is a row matrix
[rows, cols]=size(unknown);
if(rows > cols)
    unknown=unknown';
end
unknown_mass_channels = size(unknown, 2);

if(library_mass_channels ~= unknown_mass_channels)
    err = MException(['CHI:',mfilename,':TypeError'], ...
        'Unknown spectrum must be the same length as the library spectra');
    throw(err);
end

library_x_unknown = library .* repmat(unknown, number_of_library_spectra,1);
sum_library_x_unknown = sum(library_x_unknown,2);

sum_of_library_squared=sum(library .* library, 2);
sum_of_unknown_squared=sum(unknown .* unknown, 2);

result=sum_library_x_unknown .* sum_library_x_unknown;
result = result ./ (sum_of_library_squared .* sum_of_unknown_squared);
