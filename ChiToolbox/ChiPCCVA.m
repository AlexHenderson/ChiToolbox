function output = ChiPCCVA(this,pcs)
% function [cvloadings,cvscores,cvexplained,cvs,pcloadings,pcscores,pcexplained,pcs,cveigenvectors,cveigenvalues] = ChiPCCVA(this,pcs)
% 
% ChiPCCVA Principal Components - Canonical Variates Analysis
% usage:
%     [cvloadings,cvscores,cvexplained,cvs,pcloadings,pcscores,pcexplained,pcs,cveigenvectors,cveigenvalues] = ChiPCCVA(data,groupmembership);
%     [cvloadings,cvscores,cvexplained,cvs,pcloadings,pcscores,pcexplained,pcs,cveigenvectors,cveigenvalues] = ChiPCCVA(data,groupmembership,pcs);
%
% input:
%     data - rows of spectra
%     groupmembership - vector of labels, one per row of data
%     pcs - (optional) number of principal components to use in the CVA
%       calculation. If not supplied then this is calculated at 95% explained
%       variance
% output:
%     cvloadings - canonical variates, directions of most variation in the data
%     cvscores - weighting of each canonical variate
%     cvexplained - percentage explained variation of each canonical variate
%     cvs - number of canonical variates (number of groups - 1)
%     pcloadings - principal component loadings, unique characteristics in the data
%     pcscores - principal component scores, weighting of each pc
%     pcexplained - percentage explained variance of each pc
%     pcs - number of principal components used
%     cveigenvectors - eigenvectors of the canonical variates
%     cveigenvalues - eigenvalues of the canonical variates
%
%   Copyright (c) 2015, Alex Henderson 
%   Contact email: alex.henderson@manchester.ac.uk
%   Licenced under the GNU General Public License (GPL) version 3
%   http://www.gnu.org/copyleft/gpl.html
%   Other licensing options are available, please contact Alex for details
%   If you use this file in your work, please acknowledge the author(s) in
%   your publications. 
%
%   version 1.3

%   version 1.3 September 2016 Alex Henderson
%   Added cveigenvectors as an additional output
%   version 1.2 August 2016 Alex Henderson
%   Added cveigenvalues as an additional output
%   version 1.1 July 2016 Alex Henderson
%   improved error reporting. No functional change. 
%   version 1.0 June 2015 Alex Henderson
%   initial release

%% Perform principal components analysis

pca = ChiSpectralPCA(this);

%% Determine valid PCs
% Valid PCs determined by the number required to reach 95% explained
% variance, or using the user defined number. 
if ~exist('pcs','var')
    cumpcexplained = cumsum(pca.explained);
    pcs = find((cumpcexplained > 95), 1, 'first');
end

% Only use valid pcs
pca.loadings = pca.loadings(:,1:pcs);
pca.scores = pca.scores(:,1:pcs);

%% Determine number of valid canonical variates
% Number of cvs is number-of-groups - 1

numcvs = this.classmembership.numuniquelabels - 1;

if (pcs < numcvs)
    error(['Not enough valid principal components (' ,num2str(pcs), ') to discriminate between the groups (', num2str(numcvs+1), ')']);
end

%% Perform canonical variates analysis
[cveigenvectors,cveigenvalues,cvpercent_explained_variation] = ChiCVA(pca.scores,this.classmembership.labels);

%% Generate output by mapping back to the original data
cvloadings = pca.loadings * cveigenvectors;
cvscores = pca.scores * (cveigenvectors * diag(cveigenvalues));
cvexplained = cvpercent_explained_variation;

%% Create a class to hold the output
output = ChiSpectralCVAOutcome(cvscores,cvloadings,cvexplained,numcvs,...
                               cveigenvectors,cveigenvalues,pcs,pca);

