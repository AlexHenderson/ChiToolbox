function [themin,position] = rangemin(this,from,to)

% rangemin  Calculates the minimum of a spectral region. 
%
% Syntax
%   [themin,position] = rangemin(from,to);
%
% Description
%   [themin,position] = rangemin(from,to) calculates the minimum of the
%   spectra between from and to inclusive. The parameters from and to are
%   in xaxis units. themin and position are column vectors of the minimum
%   intensity and its x-axis value respectively.
%
% Copyright (c) 2019, Alex Henderson.
% Licenced under the GNU General Public License (GPL) version 3.
%
% See also 
%   rangeminidx rangesum rangemedian rangemean measurearea measureareaidx ChiSpectralCollection.

% Contact email: alex.henderson@manchester.ac.uk
% Licenced under the GNU General Public License (GPL) version 3
% http://www.gnu.org/copyleft/gpl.html
% Other licensing options are available, please contact Alex for details
% If you use this file in your work, please acknowledge the author(s) in
% your publications. 

% The latest version of this file is available at:
% https://github.com/AlexHenderson/ChiToolbox


    if ~exist('to','var')
        % Only have a single x value, so only use that position
        to = from;
    end

    % Determine the index values of the xvalue limits
    fromidx = indexat(this, from);
    toidx = indexat(this, to);
%     this.history.add(['rangemin: from ', num2str(from), ' to ', num2str(to)]);
    [themin,idx] = rangeminidx(this,fromidx,toidx);
    position = this.xvals(idx');
end        
