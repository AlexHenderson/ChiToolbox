function thesum = rangesumidx(this,fromidx,toidx)

% rangesumidx  Calculates the sum of a spectral region. 
%
% Syntax
%   thesum = rangesumidx(fromidx,toidx);
%
% Description
%   thesum = rangesumidx(fromidx,toidx) calculates the sum of the spectra
%   between fromidx and toidx inclusive. The parameters fromidx and toidx
%   are index values (not in xaxis units). thesum is a column vector of
%   summed intensities.
%
% Copyright (c) 2017, Alex Henderson.
% Licenced under the GNU General Public License (GPL) version 3.
%
% See also 
%   rangesum rangemedian rangemean measurearea measureareaidx ChiSpectralCollection.

% Contact email: alex.henderson@manchester.ac.uk
% Licenced under the GNU General Public License (GPL) version 3
% http://www.gnu.org/copyleft/gpl.html
% Other licensing options are available, please contact Alex for details
% If you use this file in your work, please acknowledge the author(s) in
% your publications. 

% Version 1.0, July 2017
% The latest version of this file is available at:
% https://github.com/AlexHenderson/ChiToolbox


    if ~exist('toidx','var')
        % Only have a single index value, so only use that position
        toidx = fromidx;
    end

    % Check for out-of-range values
    if (fromidx > this.numchannels) || (toidx > this.numchannels)
        err = MException('CHI:ChiSpectralCollection:OutOfRange', ...
            ['Requested range is too high. Max  = ', num2str(this.numchannels), '.']);
        throw(err);
    end            

    if (fromidx < 1) || (toidx < 1)
        err = MException('CHI:ChiSpectralCollection:OutOfRange', ...
            'Requested range is invalid');
        throw(err);
    end            

    % Swap if 'from' is higher than 'to'
    [fromidx,toidx] = utilities.forceincreasing(fromidx,toidx);

    thesum = sum(this.data(:,fromidx:toidx),2);

end        
