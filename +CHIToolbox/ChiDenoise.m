function [ output ] = ChiDenoise( hyperspectralimage, numpcs )
%CHIDENOISE Denoise using PCA
%   See: http://www.cytospec.com/specpreproc.php#PreprocNorm
%   Copyright (c) 2014 Alex Henderson (alex.henderson@manchester.ac.uk)

if(~isa(hyperspectralimage,'ChiImage'))
    err = MException('CHI:ChiChiDenoise:WrongDataType', ...
        'Input is not a ChiImage');
    throw(err);
end

if (~exist('numpcs','var'))
    numpcs= 30;
end

output = hyperspectralimage;

% TODO: Check reuseability of the PCA code (licence etc.)
[scores, loadings] = alex_pca(hyperspectralimage.yvals, numpcs, 'nipals');

denoised = scores(:,1:numpcs)*loadings(:,1:numpcs)';
denoised = denoised + repmat(mean(hyperspectralimage.yvals),size(denoised,1),1);

output.yvals = denoised;

end
