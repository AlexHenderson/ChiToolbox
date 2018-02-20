function [cvloadings,cvscores,cvexplained,cvs,pcloadings,pcscores,pcexplained,pcs,cveigenvectors,cveigenvalues] = deprecated_pccva(data,groupmembership,pcs)

warning('Please consider using the ChiToolbox instead. Ask Alex for details')

% PCCVA Principal Components - Canonical Variates Analysis
% usage:
%     [cvloadings,cvscores,cvexplained,cvs,pcloadings,pcscores,pcexplained,pcs,cveigenvectors,cveigenvalues] = pccva(data,groupmembership);
%     [cvloadings,cvscores,cvexplained,cvs,pcloadings,pcscores,pcexplained,pcs,cveigenvectors,cveigenvalues] = pccva(data,groupmembership,pcs);
%     [cvloadings,cvscores,cvexplained,cvs,pcloadings,pcscores,pcexplained,pcs,cveigenvectors,cveigenvalues] = pccva(data,groupmembership);
%     [cvloadings,cvscores,cvexplained,cvs,pcloadings,pcscores,pcexplained,pcs,cveigenvectors,cveigenvalues] = pccva(data,groupmembership,pcs);
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
[pcloadings, pcscores, pcvariances] = princomp(data, 'econ');
explained_variance = pcvariances / sum(pcvariances);
pcexplained = 100 * explained_variance;
cumulative_explained_variance = cumsum(explained_variance);

%% Determine valid PCs
% Valid PCs determined by the number required to reach 95% explained
% variance, or using the user defined number. 
if (~exist('pcs','var'))
    pcs = find((cumulative_explained_variance > 0.95), 1, 'first');
end

% Only use valid pcs
pcloadings = pcloadings(:,1:pcs);
pcscores = pcscores(:,1:pcs);

%% Determine number of valid canonical variates
% Number of cvs is number-of-groups - 1
% Unique rows doesn't work for cell arrays, so need two versions of the
% code here. 
if (size(groupmembership,2) > 1)
    uniquegroups = unique(groupmembership, 'rows');
else
    uniquegroups = unique(groupmembership);
end
    
cvs = size(uniquegroups,1) - 1;

if (pcs < cvs)
    error(['Not enough valid principal components (' ,num2str(pcs), ') to discriminate between the groups (', num2str(cvs+1), ')']);
end

%% Perform canonical variates analysis
[cveigenvectors,cveigenvalues,cvpercent_explained_variation] = cva(pcscores,groupmembership);

%% Generate output by mapping back to the original data
cvloadings = pcloadings * cveigenvectors;
cvscores = pcscores * (cveigenvectors * diag(cveigenvalues));
cvexplained = cvpercent_explained_variation;
