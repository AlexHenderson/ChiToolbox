function [denoised,numpcs] = pcnoisereduction(data,numpcs)
%NOISEREDUCTION Denoise using PCA
%   Copyright (c) 2015-2018 Alex Henderson (alex.henderson@manchester.ac.uk)

dims = size(data);

is3D = false;
switch length(dims)
    case 2 
        % do nothing since we're already in 2D
    case 3
        % hyperspectral data so unfold the matrix
        data = reshape(data, dims(1)*dims(2), dims(3));
        is3D = true;
    otherwise
        error('Data must be 2D or 3D');
end

[rows,cols] = size(data);
maxpcs = min(rows,cols);

% Determine the number of principal components to retain, if not provided
if ~exist('numpcs','var')
    numpcs = ceil(maxpcs * (1/3));
else
    
end

% Check the user supplied value is not too high
if (numpcs > maxpcs)
    err = MException('CHI:PCANoiseReduction:OutOfRange', ...
        ['Requested number of principal components is higher than the maximum possible (', num2str(maxpcs), ')']);
    throw(err);
end


% Do PCA
[pcloadings, pcscores] = utilities.chi_pca(input.data); 

denoised = pcscores(:,1:numpcs) * pcloadings(:,1:numpcs)';
denoised = denoised + repmat(mean(data),size(denoised,1),1);

if is3D
    % Data was originally 3D so put the denoised data back into that shape
    denoised = reshape(denoised, dims(1), dims(2), dims(3));
end

end
