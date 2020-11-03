function model = ChiSpectralPCA(input,varargin)

% ChiSpectralPCA Principal Components Analysis on a ChiSpectralCollection
%
% Syntax
%   model = ChiSpectralPCA(obj);
%   model = ChiSpectralPCA(obj,meanc);
%
% Description
%   model = ChiSpectralPCA(obj) performs principal components analysis
%   ChiSpectralCollection obj. The data is mean centered internally (meanc
%   == true). The output is stored in a ChiPCAModel object.
%
%   model = ChiSpectralPCA(obj,meanc) if meanc is false, the data is not
%   mean centered prior to analysis.
%
% Copyright (c) 2015-2020, Alex Henderson.
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

% Version 4.0, July 2020
%   version 4.0 July 2020 Alex Henderson
%     Added option to not mean center
%   version 3.0 April 2018 Alex Henderson
%     Centralised the PCA calculations
%   version 2.0 June 2017 Alex Henderson
%     Managed the deprecation of princomp
%     Introduced Octave compatibility
%     Added option to output an object
%   version 1.0 June 2015 Alex Henderson
%   initial release

% The latest version of this file is available on Bitbucket
% https://bitbucket.org/AlexHenderson/chitoolbox


if ~isa(input,'ChiSpectralCollection')
    err = MException(['CHI:',mfilename,':InputError'], ...
        'A ChiSpectralCollection is required.');
    throw(err);
end

meanc = true;
if (nargin > 1)
    meanc = false;
end

trainingmean = input.mean;

if ~meanc
    % Do not meancenter
    % Set the training mean to zeros since mean not removed. 
    trainingmean.data = zeros(size(trainingmean.data));
end    

[pcloadings, pcscores, pcvariances, pcexplained] = utilities.chi_pca(input.data,meanc); 

model = ChiPCAModel(pcscores,pcloadings,pcexplained,pcvariances,input.xvals,input.xlabelname,input.xlabelunit,input.reversex,trainingmean);
if ~isempty(input.classmembership)
    model.classmembership = input.classmembership;
end

end % function ChiSpectralPCA
