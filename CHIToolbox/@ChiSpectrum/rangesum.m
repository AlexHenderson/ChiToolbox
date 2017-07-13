function thesum = rangesum(this,from,to)

% rangesum  Calculates the sum of the spectral region. 
%
% Syntax
%   thesum = rangesum(from,to);
%
% Description
%   thesum = rangesum(from,to) calculates the sum of the spectrum between
%   from and to inclusive. The parameters from and to are in xaxis units.
%   It returns a scalar summed intensity.
%
% Copyright (c) 2017, Alex Henderson.
% Licenced under the GNU General Public License (GPL) version 3.
%
% See also 
%   rangesumidx measurearea measureareaidx ChiSpectrum.

% Contact email: alex.henderson@manchester.ac.uk
% Licenced under the GNU General Public License (GPL) version 3
% http://www.gnu.org/copyleft/gpl.html
% Other licensing options are available, please contact Alex for details
% If you use this file in your work, please acknowledge the author(s) in
% your publications. 

% Version 1.0, July 2017
% The latest version of this file is available on Bitbucket
% https://bitbucket.org/AlexHenderson/chitoolbox


    if ~exist('to','var')
        % Only have a single x value, so only use that position
        to = from;
    end

    % Determine the index values of the xvalue limits
    fromidx = indexat(this, from);
    toidx = indexat(this, to);
%     this.history.add(['rangesum: from ', num2str(from), ' to ', num2str(to)]);
    thesum = rangesumidx(this,fromidx,toidx);
end        
