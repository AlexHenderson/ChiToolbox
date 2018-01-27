function output = ChiImagePCA(input)

% ChiImagePCA Principal Components Analysis
% usage:
%     output = ChiImagePCAOutcome;
%
% input:
%     data - ChiImage
% output:
%     output - principal component loadings, unique characteristics in the data
%     pcscores - principal component scores, weighting of each pc
%     pcexplained - percentage explained variance of each pc
%     pcaResult - a PcaResult object containing the above outputs
%
%   Copyright (c) 2015-2017, Alex Henderson 
%   Contact email: alex.henderson@manchester.ac.uk
%   Licenced under the GNU General Public License (GPL) version 3
%   http://www.gnu.org/copyleft/gpl.html
%   Other licensing options are available, please contact Alex for details
%   If you use this file in your work, please acknowledge the author(s) in
%   your publications. 
%
%   version 2.0 June 2017

%   version 2.0 June 2017 Alex Henderson
%     Managed the deprecation of princomp
%     Introduced Octave compatibility
%     Added option to output an object
%   version 1.0 June 2015 Alex Henderson
%   initial release

%   There are a number of different PCA algorithms and implementations.
%   This function is named pca_clirspec to differentiate it from the other
%   possibilities. The function is essentially a wrapper round the built-in
%   princomp and pca functions, but with outputs labelled for consistency.


if ~isa(input,'ChiImage')
    err = MException('CHI:ChiImagePCA:InputError', ...
        'A ChiImage is required');
    throw(err);
end
    
if utilities.isoctave() || verLessThan('matlab', '8.0.0') % princomp is deprecated in R2012b
    [pcloadings, pcscores, pcvariances, tsquared] = princomp(input.data, 'econ'); %#ok<PRINCOMP>
    pcexplained = 100 * (pcvariances/sum(pcvariances));
else
    [pcloadings, pcscores, pcvariances, tsquared, pcexplained] = pca(input.data); 
end

    output = ChiImagePCAOutcome(pcscores,pcloadings,pcexplained,pcvariances,tsquared,input.xvals,input.xlabel,input.reversex,input.xpixels,input.ypixels);
    if ~isempty(input.filename)
        output.history.add(['PCA of ', input.filename]);
    end
end
