function output = ChiPCA(input)

% Make sure we can actually perform PCA on this data
if isa(input,'ChiSpectrum')
    err = MException('CHI:ChiPCA:InputError', ...
        'cannot perform PCA on a single spectrum');
    throw(err);
end

% Cycle through the accepted types    
if isa(input,'ChiSpectralCollection')
    output = ChiSpectralPCA(input);
    output.history.add('ChiPCA');
    this.history.add('ChiPCA');
    return;
end
    
if isa(input,'ChiImage')
    output = ChiImagePCA(input);
    output.history.add('ChiPCA');
    this.history.add('ChiPCA');
    return;
end

% If we get to here we didn't find anything we can work with
err = MException('CHI:ChiPCA:InputError', ...
    'cannot perform PCA on this data type');
throw(err);
