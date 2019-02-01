function output = ratio(this,numerator,denominator)

% ratio  The ratio of under a linear baseline
%
% Syntax
%   areapicture = area(lowx, highx);
%
% Description
%   areapicture = area(lowx, highx) calculates the area under the spectrum
%   of each pixel between the limits provided in lowx and highx in x-axis
%   units. A linear baseline is removed. A ChiPicture is produced in
%   areapicture.
%
% Copyright (c) 2014-2018, Alex Henderson.
% Licenced under the GNU General Public License (GPL) version 3.
%
% See also 
%   ChiImage.areaidx ChiPicture.

% Contact email: alex.henderson@manchester.ac.uk
% Licenced under the GNU General Public License (GPL) version 3
% http://www.gnu.org/copyleft/gpl.html
% Other licensing options are available, please contact Alex for details
% If you use this file in your work, please acknowledge the author(s) in
% your publications. 

% The latest version of this file is available on Bitbucket
% https://bitbucket.org/AlexHenderson/chitoolbox

    if isscalar(numerator)
        % Single x value
        numeratoridx = indexat(this, numerator);
    else
        if (isvector(numerator) && (length(numerator) == 2))
            % Range of x values to sum over
            numeratoridx1 = indexat(this, numerator(1));
            numeratoridx2 = indexat(this, numerator(2));
            numeratoridx = [numeratoridx1, numeratoridx2];
        else
            % Error
            err = MException('CHI:ChiImage:DimensionalityError', ...
                'Numerator range is not a single value, or simple range.');
            throw(err);
        end
    end

    if isscalar(denominator)
        % Single x value
        denominatoridx = indexat(this, denominator);
    else
        if (isvector(denominator) && (length(denominator) == 2))
            % Range of x values to sum over
            denominatoridx1 = indexat(this, denominator(1));
            denominatoridx2 = indexat(this, denominator(2));
            denominatoridx = [denominatoridx1, denominatoridx2];
        else
            % Error
            err = MException('CHI:ChiImage:DimensionalityError', ...
                'Numerator range is not a single value, or simple range.');
            throw(err);
        end
    end

    this.history.add(['ratio of xvals, ', num2str(numerator), ' / ', num2str(denominator)]);
    output = ratioidx(this,numeratoridx,denominatoridx);
    
end % ratioxvals
