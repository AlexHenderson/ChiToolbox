function area = measureareaidx(this,fromidx,toidx)

% measureareaidx  Calculates the area under a section of the spectrum (or spectra). 
%
% Syntax
%   area = measureareaidx(fromidx,toidx);
%
% Description
%   area = measureareaidx(fromidx,toidx) calculates the area under the
%   region of the spectrum delimited by the values fromidx and toidx
%   (inclusive), using a linear baseline.
%   The parameters fromidx and toidx are index values (ie. not in xaxis
%   units).
%
% Copyright (c) 2017, Alex Henderson.
% Licenced under the GNU General Public License (GPL) version 3.
%
% See also 
%   measurearea rangesum rangesumidx ChiSpectralCollection.

% Contact email: alex.henderson@manchester.ac.uk
% Licenced under the GNU General Public License (GPL) version 3
% http://www.gnu.org/copyleft/gpl.html
% Other licensing options are available, please contact Alex for details
% If you use this file in your work, please acknowledge the author(s) in
% your publications. 

% Version 1.0, July 2017
% The latest version of this file is available on Bitbucket
% https://bitbucket.org/AlexHenderson/chitoolbox


    % Swap if 'fromidx' is higher than 'toidx'
    [fromidx,toidx] = ChiForceIncreasing(fromidx,toidx);

    % Determine minimum intensity in spectral range
    minvalue = min(this.data(:,fromidx:toidx),[],2);
    
    % Remove the minimum intensity
    shifteddata = this.data - repmat(minvalue,1,size(this.data, 2));
    
    % Calculate the area of the resulting region
    area = sum(shifteddata(:,fromidx:toidx),2);
    
    % Calculate the area of a triangle defined by the intensities of the
    % region's endpoints
    triangle = (abs(shifteddata(:,toidx) - shifteddata(:,fromidx)) * (toidx-fromidx + 1)) ./ 2;
    
    % Subtract the triangular area from the total area
    area = area - triangle;
    
end
