function model = ChiImagePCA(this)

% ChiImagePCA Principal Components Analysis on a Chiimage
%
% Syntax
%   model = ChiImagePCA(obj);
%   model = ChiImagePCA(obj,meanc);
%
% Description
%   model = ChiImagePCA(obj) performs principal components analysis on
%   the ChiImage obj. The data is mean centered internally
%   (meanc == true). The output is stored in a ChiPCAModel object.
%
%   model = ChiImagePCA(obj,meanc) if meanc is false, the data is not
%   mean centered prior to analysis.
%
%   Copyright (c) 2015-2021, Alex Henderson 
%   Contact email: alex.henderson@manchester.ac.uk
%   Licenced under the GNU General Public License (GPL) version 3
%   http://www.gnu.org/copyleft/gpl.html
%   Other licensing options are available, please contact Alex for details
%   If you use this file in your work, please acknowledge the author(s) in
%   your publications. 
%
%   version 4.0 August 2021

%   version 4.0 August 2021 Alex Henderson
%     Added linearity property
%   version 3.0 April 2018 Alex Henderson
%     Centralised the PCA calculations
%   version 2.0 June 2017 Alex Henderson
%     Managed the deprecation of princomp
%     Introduced Octave compatibility
%     Added option to output an object
%   version 1.0 June 2015 Alex Henderson
%   initial release


if ~isa(this,'ChiImage')
    err = MException('CHI:ChiImagePCA:InputError', ...
        'A ChiImage is required');
    throw(err);
end
    
[pcloadings, pcscores, pcvariances, pcexplained] = utilities.chi_pca(this.data); 

model = ChiImagePCAModel(pcscores,pcloadings,pcexplained,pcvariances,this.xvals,this.xlabelname,this.xlabelunit,this.reversex,this.xpixels,this.ypixels);
if ~isempty(this.filenames)
    model.history.add(['PCA of ', this.filenames{1}]);
end

if isprop(this,'iscentroided')
    model.iscentroided = this.iscentroided;
end

model.linearity = this.linearity;

end
