function varargout = removerange(this,from,to)

% removerange  Removes a section of the spectrum (or spectra). 
%
% Syntax
%   removerange(from,to);
%   CSC = removerange(from,to);
%
% Description
%   removerange(from,to) removes the region of the spectrum delimited by
%   the values from and to (inclusive). The parameters from and to are in
%   xaxis units (not index values). This version modifies the original
%   object.
%
%   CSC = removerange(from,to) first creates a clone of the object, then
%   removes the relevant portion of the spectrum from the clone. The
%   original object is not modified.
%
% Copyright (c) 2017, Alex Henderson.
% Licenced under the GNU General Public License (GPL) version 3.
%
% See also 
%   removerangeidx ChiSpectralCollection.

% Contact email: alex.henderson@manchester.ac.uk
% Licenced under the GNU General Public License (GPL) version 3
% http://www.gnu.org/copyleft/gpl.html
% Other licensing options are available, please contact Alex for details
% If you use this file in your work, please acknowledge the author(s) in
% your publications. 

% Version 1.0, July 2017
% The latest version of this file is available on Bitbucket
% https://bitbucket.org/AlexHenderson/chitoolbox


% Swap if 'from' is higher than 'to'
[from,to] = ChiForceIncreasing(from,to);

% Determine the index values of the xvalue limits
fromidx = indexat(this, from);
toidx = indexat(this, to);

if (nargout > 0)
    % We are expecting to generate a modified clone of this object
    varargout{1} = clone(this);
    varargout{1}.history.add(['removerange: from ', num2str(from), ' to ', num2str(to)]);
    removerangeidx(varargout{1},fromidx,toidx);
else
    % We are expecting to modified this object in situ
    this.history.add(['removerange: from ', num2str(from), ' to ', num2str(to)]);
    removerangeidx(this,fromidx,toidx);
end

end
