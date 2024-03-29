function model = pca(this,varargin)

% pca Principal Components Analysis
%
% Syntax
%   pcaresult = pca();
%   pcaresult = pca(meanc);
%
% Description
%   pcaresult = pca() performs principal components analysis on the spectra
%   in this collection. The data is mean centered internally (meanc ==
%   true). The output is stored in a ChiPCAModel object.
%
%   pcaresult = pca(meanc) if meanc is false, the data is not mean
%   centered prior to analysis.
%
% Copyright (c) 2017-2021, Alex Henderson.
% Licenced under the GNU General Public License (GPL) version 3.
%
% See also 
%   princomp pca ChiPCAModel ChiSpectralCollection.

% Contact email: alex.henderson@manchester.ac.uk
% Licenced under the GNU General Public License (GPL) version 3
% http://www.gnu.org/copyleft/gpl.html
% Other licensing options are available, please contact Alex for details
% If you use this file in your work, please acknowledge the author(s) in
% your publications. 

% Version 2.0, August 2021
% The latest version of this file is available at:
% https://github.com/AlexHenderson/ChiToolbox


model = ChiSpectralPCA(this,varargin{:});

end
