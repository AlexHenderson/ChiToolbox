function data = ChiMedian(data)

% ChiMedian  Calculates the median of a matrix
%
% Syntax
%   datamedian = ChiMedian(data);
%
% Description
%   datamedian = ChiMedian(data) calculates the median of a matrix. data is
%   a collection of spectra in rows. If data is a single spectrum (only 1
%   row) the (full) data is simply returned. Otherwise the columnwise
%   median is returned. If data is sparse, the full version of datamedian
%   is returned.
%
% Copyright (c) 2018, Alex Henderson.
% Licenced under the GNU General Public License (GPL) version 3.
%
% See also 
%   ChiSum ChiMean ChiStd sparse full.

% Contact email: alex.henderson@manchester.ac.uk
% Licenced under the GNU General Public License (GPL) version 3
% http://www.gnu.org/copyleft/gpl.html
% Other licensing options are available, please contact Alex for details
% If you use this file in your work, please acknowledge the author(s) in
% your publications. 

% The latest version of this file is available on Bitbucket
% https://bitbucket.org/AlexHenderson/chitoolbox


    if ~isrow(data)
        data = median(data);
    end
    
    data = full(data);

end
