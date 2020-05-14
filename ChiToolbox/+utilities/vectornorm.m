function [vn_data,vectorlength] = vectornorm(data)

% VECTORNORM Vector normalisation
% usage:
%     [vn_data,vectorlength] = vectornorm(data);
%
% input:
%     data - rows of spectra
% output:
%     vn_data - vector normalised version of data
%     vectorlength - the vector length of the data before normalisation
%
%   The data is normalised such that the vector length in N-d space (where
%   N is the number of data points in each row) is unity (1).
%
%   Copyright (c) 2015, Alex Henderson 
%   Contact email: alex.henderson@manchester.ac.uk
%   Licenced under the GNU General Public License (GPL) version 3
%   http://www.gnu.org/copyleft/gpl.html
%   Other licensing options are available, please contact Alex for details
%   If you use this file in your work, please acknowledge the author(s) in
%   your publications. 
%
%   version 3.0 July 2017 Alex Henderson

%   version 3.0 July 2017 Alex Henderson
%   Handled 3D data
%   version 2.0 October 2015 Alex Henderson
%   Corrected for sparseness of data
%   version 1.0 June 2015 Alex Henderson
%   initial release

% Calculates the following:
%   1. Squares each variable in 'data'.
%   2. Sums these squares and calculates the square root of the result.
%      This is the 'vector length' (L2-norm). 
%   3. Divides each of the original data variables by the vector length.
%   4. Outputs the result to a MATLAB variable

sparseinput = false;
if (issparse(data))
    sparseinput = true;
end

is3D = false;
dims = size(data);
if (length(dims) == 3)
    is3D = true;
    data = reshape(data,dims(1)*dims(2),dims(3));
end


squares = data .^ 2;                % square of each variable ([n,m])
sum_of_squares = sum(squares, 2);   % sum of the squares along the rows ([n,1])

divisor = sqrt(sum_of_squares);     % ([n,1]) == L2-Norm

divisor(divisor == 0) = 1;          % avoid divide by zero error

% Generate a sparse matrix where the diagonal is of the inverse of the divisor
multiplier = 1 ./ divisor;
multiplierdiag = spdiags(multiplier,0,length(multiplier),length(multiplier));

data = multiplierdiag * data; % divide the data by the vector length ([n,m])

if sparseinput
    data = sparse(data);
else
    data = full(data);
end

vn_data = data;
vectorlength = full(divisor);

if is3D
    vn_data = reshape(vn_data,dims(1),dims(2),dims(3));
    vectorlength = reshape(vectorlength,dims(1),dims(2));
end

%% Notes
% This is vector normalisation of each pixel in a hyperspectral image,
% independent of any other pixel. 

%% Explanation
% If the L2Norm is 0 we can set it to 1. This is because the only way in
% which we can get a value of 0 for the L2norm is if all the values that
% are involved in its generation are 0. Therefore we would be dividing 0 by
% 0. Dividing 0 by 1 gives, effectively, the same result, but without the
% error.
