function output = pccva(this,varargin)

% pccva Principal Components - Canonical Variates Analysis
%
% Syntax
%   cvaresult = pccva();
%   cvaresult = pccva(pcs);
%
% Description
%   cvaresult = pccva() performs principal components analysis on the
%   spectra in this collection followed by canonical variates analysis. The
%   data is mean centered internally. The number of principal components to
%   use for CVA is the number required to explain 95% of the variance in
%   the data. The output is stored in a ChiSpectralCVAOutcome object.
%
%   cvaresult = pccva(pcs) performs canonical variates analysis using pcs
%   principal components.
%
% Copyright (c) 2017, Alex Henderson.
% Licenced under the GNU General Public License (GPL) version 3.
%
% See also 
%   princomp pca ChiSpectralCVAOutcome ChiSpectralPCAOutcome ChiSpectralCollection.

% Contact email: alex.henderson@manchester.ac.uk
% Licenced under the GNU General Public License (GPL) version 3
% http://www.gnu.org/copyleft/gpl.html
% Other licensing options are available, please contact Alex for details
% If you use this file in your work, please acknowledge the author(s) in
% your publications. 

% Version 1.0, July 2017
% The latest version of this file is available on Bitbucket
% https://bitbucket.org/AlexHenderson/chitoolbox


output = ChiPCCVA(this,varargin{:});

end
