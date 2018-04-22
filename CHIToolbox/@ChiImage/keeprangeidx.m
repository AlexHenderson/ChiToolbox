function obj = keeprangeidx(varargin)

% keeprangeidx  Retains one or more sections of the spectra. 
%
% Syntax
%   keeprangeidx(fromidx,toidx);
%   keeprangeidx(fromidx1,toidx1,fromidx2,toidx2,...);
%   modified = keeprangeidx(____);
%
% Description
%   keeprangeidx(fromidx,toidx) retains the region of the spectra
%   delimited by the values fromidx and toidx (inclusive). The parameters
%   fromidx and toidx are index values (not in xaxis units). This version
%   modifies the original object.
%
%   keeprangeidx(fromidx1,toidx1,fromidx2,toidx2,...) retains the
%   multiple regions. Regions are in pairs: fromidx -> toidx. This version
%   modifies the original object.
%
%   modified = keeprangeidx(____) first creates a clone of the object,
%   then retains the relevant portion of the spectra from the clone. The
%   original object is not modified.
%
% Copyright (c) 2017-2018, Alex Henderson.
% Licenced under the GNU General Public License (GPL) version 3.
%
% See also 
%   keeprange removerange ChiSpectralCollection.

% Contact email: alex.henderson@manchester.ac.uk
% Licenced under the GNU General Public License (GPL) version 3
% http://www.gnu.org/copyleft/gpl.html
% Other licensing options are available, please contact Alex for details
% If you use this file in your work, please acknowledge the author(s) in
% your publications. 

% The latest version of this file is available on Bitbucket
% https://bitbucket.org/AlexHenderson/chitoolbox


this = varargin{1};

if nargout
    obj = this.clone();
    % Not a great approach, but quite generic. 
    % Prevents errors if the function name changes. 
    command = [mfilename, '(varargin{:});'];
    eval(command);  
else
    % We are expecting to modify this object in situ

    ranges = varargin{2:end};

    if rem(length(ranges),2)
        err = MException(['CHI:',mfilename,':IOError'], ...
            'The from/to variables must be pairs of range limits.');
        throw(err);
    end

    ranges = reshape(ranges,2,[]);
    ranges = ranges';
    ranges = sort(ranges,2); %#ok<UDIM>
    numRanges = size(ranges,1);

    % We identify regions of the spectrum to remove by marking them on datamask
    datamask = true(size(this.xvals));
    for r = 1:numRanges    
        datamask(ranges(r,1):ranges(r,2)) = false;
    end

    this.xvals(datamask) = [];
    if (this.numspectra > 1)
        this.data(:,datamask) = [];
    else
        this.data(datamask) = [];
    end

    for r = 1:numRanges    
        this.history.add(['keeprangeidx: from ', num2str(ranges(r,1)), ' to ', num2str(ranges(r,2))]);
    end
end

end
