function setparent(this,parent)

% setparent  Determines the data that the class will model.
%
% Syntax
%   setparent(parent);
%
% Description
%   setparent(parent) determines the data that the class will model.
% 
% Copyright (c) 2018, Alex Henderson.
% Licenced under the GNU General Public License (GPL) version 3.
%
% See also 
%   model, remove

% Contact email: alex.henderson@manchester.ac.uk
% Licenced under the GNU General Public License (GPL) version 3
% http://www.gnu.org/copyleft/gpl.html
% Other licensing options are available, please contact Alex for details
% If you use this file in your work, please acknowledge the author(s) in
% your publications. 

% Version 1.0, August 2018
% The latest version of this file is available on Bitbucket
% https://bitbucket.org/AlexHenderson/chitoolbox


    if ~isa(parent, 'ChiRamanCharacter')
        err = MException(['CHI:',mfilename,':InputError'], ...
            'Cannot initialise a ChiRamanAsymmBaseline object without a Raman dataset.');
        throw(err);
    end
    this.parent = parent;
    
end
