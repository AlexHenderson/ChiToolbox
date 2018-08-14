function output = areaidx(this,lowidx,highidx)

% areaidx  The area under a linear baseline
%
% Syntax
%   areapicture = areaidx(lowidx, highidx);
%
% Description
%   areapicture = areaidx(lowidx, highidx) calculates the area under the
%   spectrum of each pixel between the index limits provided in lowidx and
%   highidx. A linear baseline is removed. A ChiPicture is produced in
%   areapicture.
%
% Copyright (c) 2017-2018, Alex Henderson.
% Licenced under the GNU General Public License (GPL) version 3.
%
% See also 
%   ChiImage.area ChiPicture.

% Contact email: alex.henderson@manchester.ac.uk
% Licenced under the GNU General Public License (GPL) version 3
% http://www.gnu.org/copyleft/gpl.html
% Other licensing options are available, please contact Alex for details
% If you use this file in your work, please acknowledge the author(s) in
% your publications. 

% The latest version of this file is available on Bitbucket
% https://bitbucket.org/AlexHenderson/chitoolbox

    % Swap if 'from' is higher than 'to'
    [lowidx,highidx] = ChiForceIncreasing(lowidx,highidx);

    minvalue = min(this.data(:,lowidx:highidx),[],2);
    shifteddata = this.data - repmat(minvalue,1,size(this.data, 2));
    area = sum(shifteddata(:,lowidx:highidx),2);
    triangle = (abs(shifteddata(:,highidx) - shifteddata(:,lowidx)) * (highidx-lowidx + 1)) ./ 2;
    area = area - triangle;
    output = ChiPicture(area,this.xpixels,this.ypixels);
    output.history.add(['measured area: from ', num2str(lowidx), ' to ', num2str(highidx), ' index postions']);
    this.history.add(['measured area: from ', num2str(lowidx), ' to ', num2str(highidx), ' index postions']);
end
