function obj = tocollection(this)

% tocollection  Converts the image into a spectral collection.
%
% Syntax
%   obj = tocollection();
%
% Description
%   obj = tocollection() converts the image into a spectral collection. 
% 
% Copyright (c) 2019, Alex Henderson.
% Licenced under the GNU General Public License (GPL) version 3.
%
% See also 
%   spectrumat hypercube crop.

% Contact email: alex.henderson@manchester.ac.uk
% Licenced under the GNU General Public License (GPL) version 3
% http://www.gnu.org/copyleft/gpl.html
% Other licensing options are available, please contact Alex for details
% If you use this file in your work, please acknowledge the author(s) in
% your publications. 

% The latest version of this file is available on Bitbucket
% https://bitbucket.org/AlexHenderson/chitoolbox


    if ~nargout
        err = MException(['CHI:',mfilename,':IOError'], ...
            'Nowhere to put the output.');
        throw(err);
    end
    
    collectionclass = str2func(this.spectralcollectionclassname);
    obj = collectionclass(this);
    obj.filenames = this.filenames;
    obj.history.add(['Data converted from a ',class(this)]);
    this.history.add(['Data converted to a ', this.spectralcollectionclassname]);
    
end % function
