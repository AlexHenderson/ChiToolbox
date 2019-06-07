function obj = or(this,another)
    
% or  Performs a logical OR with another mask.
%
% Syntax
%   or(another);
%   obj = or(another);
%
% Description
%   or(another) performs a logical OR with another mask in-situ.
% 
%   obj = or(another) clones the object before ORing the mask. The
%   original ChiMask is not modified
%
% Copyright (c) 2019, Alex Henderson.
% Licenced under the GNU General Public License (GPL) version 3.
%
% See also 
%   and not.

% Contact email: alex.henderson@manchester.ac.uk
% Licenced under the GNU General Public License (GPL) version 3
% http://www.gnu.org/copyleft/gpl.html
% Other licensing options are available, please contact Alex for details
% If you use this file in your work, please acknowledge the author(s) in
% your publications. 

% The latest version of this file is available on Bitbucket
% https://bitbucket.org/AlexHenderson/chitoolbox


    if (nargin ~= 2)
        err = MException(['CHI:',mfilename,':IOError'], ...
            'Nothing to OR with.');
        throw(err);
    end
    
    if (length(this.mask) ~= length(another.mask))
        err = MException(['CHI:',mfilename,':DimensionalityError'], ...
            'Masks are different sizes.');
        throw(err);
    end
    
    if (this.dims ~= another.dims)
        err = MException(['CHI:',mfilename,':DimensionalityError'], ...
            'Masks are of different dimensionality.');
        throw(err);
    end

    if nargout
        obj = this.clone();
        command = [mfilename, '(obj,another);'];
        eval(command);  
    else
        this.mask = this.mask | another.mask;
        message = 'Two masks ORed';
        this.history.add(message);
    end
    
end
