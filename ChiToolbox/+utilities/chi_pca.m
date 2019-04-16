function [loadings,scores,variances,explained] = chi_pca(data,meanc)

% chi_pca  Principal Components Analysis
% usage:
%     [loadings,scores,variances,explained] = chi_pca(data,meanc);
%
% input:
%     data  - a matrix of spectra in rows
%     meanc - logical (default true) whether to mean center the data
% output:
%     loadings - principal component (pc) loadings, unique characteristics in the data
%     scores - principal component scores, weighting of each pc
%     variances - explained variance of each pc
%     explained - percentage explained variance of each pc
%
%   Copyright (c) 2018, Alex Henderson 
% 
%   See also 
%       princomp pca covpca

%   Copyright (c) 2018, Alex Henderson 
%   Contact email: alex.henderson@manchester.ac.uk
%   Licenced under the GNU General Public License (GPL) version 3
%   http://www.gnu.org/copyleft/gpl.html
%   Other licensing options are available, please contact Alex for details
%   If you use this file in your work, please acknowledge the author(s) in
%   your publications. 
%
%   version 1.0 April 2018


if ~exist('meanc','var')
    meanc = true;
end

% If the statistics toolbox is available, use it. 
if (exist('princomp','file') || exist('pca','file')) && meanc
    if utilities.isoctave() || verLessThan('matlab', '8.0.0') % princomp is deprecated in R2012b
        [loadings,scores,variances] = princomp(data, 'econ'); %#ok<PRINCOMP>
    else
        [loadings,scores,variances] = pca(data);
    end
else
    % Do PCA manually
    if meanc
        data = utilities.meancenter(data);
    end
    
    [U,S,V] = svd(data,'econ');
    loadings = V;
    scores = U*S;
    variances = diag(S'*S);

    % Trim to size depending on whether mean centered or not
    if meanc
        loadings = loadings(:,1:end-1);
        scores = scores(:,1:end-1);
        variances = variances(1:end-1) ./ (size(data,1) - 1);
    else
        variances = variances ./ size(data,1);
    end
    
end
    
explained = 100 * (variances/sum(variances));

end
