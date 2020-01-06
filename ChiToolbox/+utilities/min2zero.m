function output = min2zero(input)
    
% min2zero  Shift the data such that the minimum becomes zero
% 
% Syntax
%   output = min2zero(input);
%
% Description
%   output = min2zero(input) shift the data in intensity such that the
%   minimum becomes zero.
% 
% Copyright (c) 2019, Alex Henderson.
% Licenced under the GNU General Public License (GPL) version 3.
%
% See also 
%   max, median, min, plus, minus, vectornorm, sumnorm, featurenorm

% Contact email: alex.henderson@manchester.ac.uk
% Licenced under the GNU General Public License (GPL) version 3
% http://www.gnu.org/copyleft/gpl.html
% Other licensing options are available, please contact Alex for details
% If you use this file in your work, please acknowledge the author(s) in
% your publications. 

% The latest version of this file is available on Bitbucket
% https://bitbucket.org/AlexHenderson/chitoolbox


    themin = min(input,[],2);
    output = input - repmat(themin,1,size(input,2));
        
end
