function output = asimage(this)

% asimage  The mask as a 2D array.
%
% Syntax
%   output = asimage();
%
% Description
%   output = asimage() returns the mask as a 2D array.
% 
% Copyright (c) 2019, Alex Henderson.
% Licenced under the GNU General Public License (GPL) version 3.
%
% See also 
%   asvector ashypercube.

% Contact email: alex.henderson@manchester.ac.uk
% Licenced under the GNU General Public License (GPL) version 3
% http://www.gnu.org/copyleft/gpl.html
% Other licensing options are available, please contact Alex for details
% If you use this file in your work, please acknowledge the author(s) in
% your publications. 

% The latest version of this file is available on Bitbucket
% https://bitbucket.org/AlexHenderson/chitoolbox


    switch this.dims
        case 1
            % We have a vector mask
            err = MException(['CHI:',mfilename,':DimensionalityError'], ...
                'This mask is only 1D');
            throw(err);
        case 2
            % We have an image mask, so all OK
            output = reshape(this.mask, this.rows, this.cols);
        case 3
            % We have a hypercube mask
            err = MException(['CHI:',mfilename,':DimensionalityError'], ...
                'This mask is 3D');
            throw(err);
        otherwise
            % We should never get here
            err = MException(['CHI:',mfilename,':DimensionalityError'], ...
                'Problem encountered. Please inform Alex');
            throw(err);
    end
    
end
