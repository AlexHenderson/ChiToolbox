function themedian = rangemedian(this,from,to)

% rangemedian  Calculates the median of a spectral region. 
%
% Syntax
%   themedian = rangemedian(from,to);
%
% Description
%   themedian = rangemedian(from,to) calculates the median of the spectra
%   between from and to inclusive. The parameters from and to are in xaxis
%   units. themedian is a ChiPicture of median intensities.
%
% Copyright (c) 2019, Alex Henderson.
% Licenced under the GNU General Public License (GPL) version 3.
%
% See also 
%   rangemedianidx rangesum rangemean measurearea measureareaidx ChiImage ChiPicture.

% Contact email: alex.henderson@manchester.ac.uk
% Licenced under the GNU General Public License (GPL) version 3
% http://www.gnu.org/copyleft/gpl.html
% Other licensing options are available, please contact Alex for details
% If you use this file in your work, please acknowledge the author(s) in
% your publications. 

% The latest version of this file is available on Bitbucket
% https://bitbucket.org/AlexHenderson/chitoolbox


    if ~exist('to','var')
        % Only have a single x value, so only use that position
        to = from;
    end

    % Determine the index values of the xvalue limits
    fromidx = indexat(this, from);
    toidx = indexat(this, to);
%     this.history.add(['rangemedian: from ', num2str(from), ' to ', num2str(to)]);
    themedian = rangemedianidx(this,fromidx,toidx);
    
end        
