function thesum = rangesumidx(this,fromidx,toidx)

% rangesumidx  Calculates the sum of a spectral region. 
%
% Syntax
%   thesum = rangesumidx(fromidx,toidx);
%
% Description
%   thesum = rangesumidx(fromidx,toidx) calculates the sum of the spectra
%   between fromidx and toidx inclusive. The parameters fromidx and toidx
%   are index values (not in xaxis units). thesum is a ChiPicture of
%   summed intensities.
%
% Copyright (c) 2014-2017, Alex Henderson.
% Licenced under the GNU General Public License (GPL) version 3.
%
% See also 
%   rangesum rangemean rangemedian measurearea measureareaidx ChiImage ChiPicture.

% Contact email: alex.henderson@manchester.ac.uk
% Licenced under the GNU General Public License (GPL) version 3
% http://www.gnu.org/copyleft/gpl.html
% Other licensing options are available, please contact Alex for details
% If you use this file in your work, please acknowledge the author(s) in
% your publications. 

% The latest version of this file is available on Bitbucket
% https://bitbucket.org/AlexHenderson/chitoolbox


    if ~exist('toidx','var')
        % only have a single index value so only use that position
        toidx = fromidx;
    end

    % Check for out-of-range values
    if (fromidx > this.numchannels) || (toidx > this.numchannels)
        err = MException(['CHI:',mfilename,':OutOfRange'], ...
            'Requested range is too high');
        throw(err);
    end            

    if (fromidx < 1) || (toidx < 1)
        err = MException(['CHI:',mfilename,':OutOfRange'], ...
            'Requested range is invalid');
        throw(err);
    end            

    % Swap if 'from' is higher than 'to'
    [fromidx,toidx] = utilities.forceincreasing(fromidx,toidx);

    rowsums = sum(this.data(:,fromidx:toidx),2);

%     if this.masked
%         unmasked = zeros(size(rowsums));
%         totindex = 1;
%         for i = 1:length(this.mask)
%             if this.mask(i)
%                 % ToDo: This is really inefficient, look at insertdummyrows
%                 % code
%                 % Insert the non-zero values back into the required
%                 % locations. 
%                 unmasked(i) = rowsums(totindex);
%                 totindex = totindex + 1;
%             end
%         end
%         rowsums = unmasked;
%     end

    thesum = ChiPicture(rowsums,this.xpixels,this.ypixels);
    thesum.history.add(['rangesumidx, from ', num2str(fromidx), ' to ', num2str(toidx)]);
    this.history.add(['rangesumidx, from ', num2str(fromidx), ' to ', num2str(toidx)]);
end        
