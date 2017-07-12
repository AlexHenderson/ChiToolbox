function varargout = removerangeidx(this,fromidx,toidx)

% removerangeidx  Removes a section of the spectrum (or spectra). 
%
% Syntax
%   removerangeidx(from,to);
%   CSC = removerangeidx(from,to);
%
% Description
%   removerangeidx(from,to) removes the region of the spectrum delimited by
%   the values from and to (inclusive). The parameters from and to are
%   index values (not in xaxis units). This version modifies the original
%   object.
%
%   CSC = removerangeidx(from,to) first creates a clone of the object, then
%   removes the relevant portion of the spectrum from the clone. The
%   original object is not modified.
%
% Copyright (c) 2017, Alex Henderson.
% Licenced under the GNU General Public License (GPL) version 3.
%
% See also 
%   removerange ChiSpectralCollection.

% Contact email: alex.henderson@manchester.ac.uk
% Licenced under the GNU General Public License (GPL) version 3
% http://www.gnu.org/copyleft/gpl.html
% Other licensing options are available, please contact Alex for details
% If you use this file in your work, please acknowledge the author(s) in
% your publications. 

% Version 1.0, July 2017
% The latest version of this file is available on Bitbucket
% https://bitbucket.org/AlexHenderson/agilent-file-formats


% Swap if 'from' is higher than 'to'
[fromidx,toidx] = ChiForceIncreasing(fromidx,toidx);

% Generating output by saving spectral pieces, rather than deleting the
% unwanted part, so need to step the limits outwards.
fromidx = fromidx - 1;
toidx = toidx + 1;

if (nargout > 0)
    % We are expecting to generate a modified clone of this object
    varargout{1} = clone(this);
    varargout{1}.xvals = [varargout{1}.xvals(1:fromidx),varargout{1}.xvals(toidx:end)];
    varargout{1}.data = [varargout{1}.data(:,1:fromidx),varargout{1}.data(:,toidx:end)];
    varargout{1}.history.add(['removerangefromindexvals: from ', num2str(fromidx), ' to ', num2str(toidx)]);    
else
    % We are expecting to modified this object in situ
    this.xvals = [this.xvals(1:fromidx),this.xvals(toidx:end)];
    this.data = [this.data(:,1:fromidx),this.data(:,toidx:end)];
    this.history.add(['removerangefromindexvals: from ', num2str(fromidx), ' to ', num2str(toidx)]);
end

end
