function [themin,idx] = rangeminidx(this,fromidx,toidx)

% rangeminidx  Calculates the minimum of a spectral region. 
%
% Syntax
%   [themin,idx] = rangeminidx(fromidx,toidx);
%
% Description
%   [themin,idx] = rangeminidx(fromidx,toidx) calculates the minimum of the
%   spectra between fromidx and toidx inclusive. The parameters fromidx and
%   toidx are index values (not in xaxis units). themin and idx are column
%   vectors of the minimum intensity and its index position respectively.
%
% Copyright (c) 2019, Alex Henderson.
% Licenced under the GNU General Public License (GPL) version 3.
%
% See also 
%   rangemin rangesum rangemedian rangemean measurearea measureareaidx ChiSpectralCollection.

% Contact email: alex.henderson@manchester.ac.uk
% Licenced under the GNU General Public License (GPL) version 3
% http://www.gnu.org/copyleft/gpl.html
% Other licensing options are available, please contact Alex for details
% If you use this file in your work, please acknowledge the author(s) in
% your publications. 

% The latest version of this file is available on Bitbucket
% https://bitbucket.org/AlexHenderson/chitoolbox


    if ~exist('toidx','var')
        % Only have a single index value, so only use that position
        toidx = fromidx;
    end

    % Check for out-of-range values
    if (fromidx > this.numchannels) || (toidx > this.numchannels)
        err = MException(['CHI:',mfilename,':OutOfRange'], ...
            ['Requested range is too high. Max  = ', num2str(this.numchannels), '.']);
        throw(err);
    end            

    if (fromidx < 1) || (toidx < 1)
        err = MException(['CHI:',mfilename,':OutOfRange'], ...
            'Requested range is invalid');
        throw(err);
    end            

    % Swap if 'from' is higher than 'to'
    [fromidx,toidx] = utilities.forceincreasing(fromidx,toidx);

    [themin,idx] = min(this.data(:,fromidx:toidx),[],2);
    idx = idx + fromidx - 1;

end        
