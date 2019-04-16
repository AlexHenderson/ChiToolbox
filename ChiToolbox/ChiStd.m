function data = ChiStd(data)

% ChiStd  Calculates the standard deviation of a matrix
%
% Syntax
%   datastd = ChiStd(data);
%
% Description
%   datastd = ChiStd(data) calculates the standard deviation of a matrix.
%   data is a collection of spectra in rows. If data is a single spectrum
%   (only 1 row) the (full) data is simply returned. Otherwise the
%   columnwise standard deviation is returned. If data is sparse, the full
%   version of datastd is returned.
%
% Copyright (c) 2018, Alex Henderson.
% Licenced under the GNU General Public License (GPL) version 3.
%
% See also 
%   ChiMedian ChiMean ChiSum sparse full.

% Contact email: alex.henderson@manchester.ac.uk
% Licenced under the GNU General Public License (GPL) version 3
% http://www.gnu.org/copyleft/gpl.html
% Other licensing options are available, please contact Alex for details
% If you use this file in your work, please acknowledge the author(s) in
% your publications. 

% The latest version of this file is available on Bitbucket
% https://bitbucket.org/AlexHenderson/chitoolbox


    if ~isrow(data)
        data = std(data);
    end
    
    data = full(data);
    
end
