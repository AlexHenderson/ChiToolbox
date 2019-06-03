function themean = rangemean(this,from,to)

% rangemean  Calculates the mean of a spectral region. 
%
% Syntax
%   themean = rangemean(from,to);
%
% Description
%   themean = rangemean(from,to) calculates the mean of the spectra between
%   from and to inclusive. The parameters from and to are in xaxis units.
%   themean is a column vector of mean intensities.
%
% Copyright (c) 2019, Alex Henderson.
% Licenced under the GNU General Public License (GPL) version 3.
%
% See also 
%   rangemeanidx rangesum rangemedian measurearea measureareaidx ChiSpectralCollection.

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
%     this.history.add(['rangemean: from ', num2str(from), ' to ', num2str(to)]);
    themean = rangemeanidx(this,fromidx,toidx);
end        
