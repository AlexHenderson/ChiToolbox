function [ output ] = ChiDenoise( hyperspectralimage, numpcs )
%CHIDENOISE Denoise using PCA
%   Copyright (c) 2014 Alex Henderson (alex.henderson@manchester.ac.uk)

if(~isa(hyperspectralimage,'ChiImage'))
    err = MException('CHI:ChiDenoise:WrongDataType', ...
        'Input is not a ChiImage');
    throw(err);
end

if (~exist('numpcs','var'))
    numpcs= 30;
end

output = hyperspectralimage.clone();

% TODO: Check reuseability of the PCA code (licence etc.)
% [scores, loadings] = alex_pca(hyperspectralimage.data, numpcs, 'nipals');
[scores, loadings] = alex_pca(hyperspectralimage.data, numpcs, 'matlab econ');

denoised = scores(:,1:numpcs)*loadings(:,1:numpcs)';
denoised = denoised + repmat(mean(hyperspectralimage.data),size(denoised,1),1);

output.data = denoised;
output.log = vertcat(output.log,['Denoised, ', num2str(numpcs), ' PCs']);

end
