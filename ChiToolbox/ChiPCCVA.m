function model = ChiPCCVA(this,varargin)
% function [cvloadings,cvscores,cvexplained,cvs,pcloadings,pcscores,pcexplained,pcs,cveigenvectors,cveigenvalues] = ChiPCCVA(this,pcs,varargin)
% 
% ChiPCCVA Principal Components - Canonical Variates Analysis
% usage:
%     [cvloadings,cvscores,cvexplained,cvs,pcloadings,pcscores,pcexplained,pcs,cveigenvectors,cveigenvalues] = ChiPCCVA(data,groupmembership);
%     [____] = ChiPCCVA(____,pcs);
%     [____] = ChiPCCVA(____,'sample', 'undersample');
%     [____] = ChiPCCVA(____,'sample', 'none');
%
% input:
%     data - rows of spectra
%     groupmembership - vector of labels, one per row of data
%     pcs - (optional) number of principal components to use in the CVA
%       calculation. If not supplied then this is calculated at 95%
%       explained variance
%     'sample', 'undersample' - performs under-sampling to balance class
%       sizes (default)
%     'sample', 'none' - no under-sampling or over-sampling performed
%     
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
%   Copyright (c) 2015-2022, Alex Henderson 
%   Contact email: alex.henderson@manchester.ac.uk
%   Licenced under the GNU General Public License (GPL) version 3
%   http://www.gnu.org/copyleft/gpl.html
%   Other licensing options are available, please contact Alex for details
%   If you use this file in your work, please acknowledge the author(s) in
%   your publications. 
%
%   version 2.1

%   version 2.1 July 2022 Alex Henderson
%   Added flag for undersampling
%   version 2.0 August 2021 Alex Henderson
%   Added check for class membership, centroided data, linearity and
%   converted errors to exceptions
%   version 1.3 September 2016 Alex Henderson
%   Added cveigenvectors as an additional output
%   version 1.2 August 2016 Alex Henderson
%   Added cveigenvalues as an additional output
%   version 1.1 July 2016 Alex Henderson
%   improved error reporting. No functional change. 
%   version 1.0 June 2015 Alex Henderson
%   initial release


%% Check we have class membership, a requirement for CVA
if isempty(this.classmembership)
    err = MException(['CHI:',mfilename,':InputError'], ...
        'No class membership is available, a requirement for discriminant analysis.');
    throw(err);
end

%% Do we want to specify sampling a protocol?
sampling = 'undersample';
argposition = find(cellfun(@(x) strcmpi(x, 'sample') , varargin));
if argposition
    sampling = lower(varargin{argposition+1});
    % Remove the parameters from the argument list
    varargin(argposition+1) = [];
    varargin(argposition) = [];
end

%% Perform principal components analysis
pca = ChiSpectralPCA(this);

%% Determine valid PCs
% Valid PCs determined by the number required to reach 95% explained
% variance, or using the user defined number. 
if ~isempty(varargin)
    pcs = varargin{1};
end
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
    message = ['Not enough valid principal components (' ,num2str(pcs), ') to discriminate between the groups (', num2str(numcvs+1), ').'];
    err = MException(['CHI:',mfilename,':InputError'], ...
        message');
    throw(err);    
end

%% Perform canonical variates analysis
[cveigenvectors,cveigenvalues,cvpercent_explained_variation] ...
    = ChiCVA(pca.scores,this.classmembership.labels, 'sample', sampling);

%% Generate output by mapping back to the original data
cvloadings = pca.loadings * cveigenvectors;
cvscores = pca.scores * (cveigenvectors * diag(cveigenvalues));
cvexplained = cvpercent_explained_variation;

%% Create a class to hold the output
model = ChiPCCVAModel(cvscores,cvloadings,cvexplained,numcvs,...
                               cveigenvectors,cveigenvalues,pcs,pca);

if isprop(this,'iscentroided')
    model.iscentroided = this.iscentroided;
end

model.linearity = this.linearity;

