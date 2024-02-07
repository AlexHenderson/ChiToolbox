function [themax,position] = rangemax(this,from,to)

% rangemax  Calculates the maximum of a spectral region. 
%
% Syntax
%   [themax,position] = rangemax(from,to);
%
% Description
%   [themax,position] = rangemax(from,to) calculates the maximum of the
%   spectra between from and to inclusive. The parameters from and to are
%   in xaxis units. themax and position are column vectors of the maximum
%   intensity and its x-axis value respectively.
%
% Copyright (c) 2019, Alex Henderson.
% Licenced under the GNU General Public License (GPL) version 3.
%
% See also 
%   rangemaxidx rangesum rangemedian rangemean measurearea measureareaidx ChiSpectralCollection.

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
%     this.history.add(['rangemax: from ', num2str(from), ' to ', num2str(to)]);
    [themax,idx] = rangemaxidx(this,fromidx,toidx);
    position = this.xvals(idx)';
    
end        
