function data = ChiSum(data)

% ChiSum  Calculates the sum of a matrix
%
% Syntax
%   datasum = ChiSum(data);
%
% Description
%   datasum = ChiSum(data) calculates the sum of a matrix. data is a
%   collection of spectra in rows. If data is a single spectrum (only 1
%   row) the (full) data is simply returned. Otherwise the columnwise sum
%   is returned. If data is sparse, the full version of datasum is
%   returned.
%
% Copyright (c) 2018, Alex Henderson.
% Licenced under the GNU General Public License (GPL) version 3.
%
% See also 
%   ChiMedian ChiMean ChiStd sparse full.

% Contact email: alex.henderson@manchester.ac.uk
% Licenced under the GNU General Public License (GPL) version 3
% http://www.gnu.org/copyleft/gpl.html
% Other licensing options are available, please contact Alex for details
% If you use this file in your work, please acknowledge the author(s) in
% your publications. 

% The latest version of this file is available at:
% https://github.com/AlexHenderson/ChiToolbox


    if ~isrow(data)
        data = sum(data);
    end
    
    data = full(data);

end
