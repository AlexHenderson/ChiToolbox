function output = peakareaidx(this,lowidx,highidx)

% peakareaidx  The area above a zero intensity baseline
%
% Syntax
%   values = peakareaidx(lowidx, highidx);
%
% Description
%   values = peakareaidx(lowidx, highidx) calculates the area under each
%   spectrum between the index limits provided in lowidx and highidx. No
%   baseline is removed.
%   The type of values is a scalar if the input is a spectrum, a vector if
%   the input is a spectral collection and a ChiPicture if the input is an
%   image.
%
% Copyright (c) 2017-2019, Alex Henderson.
% Licenced under the GNU General Public License (GPL) version 3.
%
% See also 
%   peakarea area

% Contact email: alex.henderson@manchester.ac.uk
% Licenced under the GNU General Public License (GPL) version 3
% http://www.gnu.org/copyleft/gpl.html
% Other licensing options are available, please contact Alex for details
% If you use this file in your work, please acknowledge the author(s) in
% your publications. 

% The latest version of this file is available at:
% https://github.com/AlexHenderson/ChiToolbox


    % Swap if 'from' is higher than 'to'
    [lowidx,highidx] = utilities.forceincreasing(lowidx,highidx);

    % Accommodate data type
    if isa(this, 'ChiAbstractSpectrum')
        output = sum(this.data(lowidx:highidx));
    else
        if isa(this, 'ChiAbstractSpectralCollection')
            output = sum(this.data(:,lowidx:highidx),2);
        else
            if isa(this, 'ChiAbstractImage')
                output = sum(this.data(:,lowidx:highidx),2);
                output = ChiPicture(output,this.xpixels,this.ypixels);            
                output.history.add(['measured area (without baseline): from ', num2str(lowidx), ' to ', num2str(highidx), ' index postions']);
            else
                err = MException(['CHI:',mfilename,':TypeError'], ...
                    'Unknown data type');
                throw(err);
            end
        end
    end
    
    this.history.add(['measured area (without baseline): from ', num2str(lowidx), ' to ', num2str(highidx), ' index postions']);
    
end
