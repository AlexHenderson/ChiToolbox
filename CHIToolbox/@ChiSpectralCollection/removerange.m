function varargout = removerange(this,varargin)

% removerange  Removes one or more sections of the spectra. 
%
% Syntax
%   removerange(from,to);
%   removerange(from1,to1,from2,to2,...);
%   modified = removerange(____);
%
% Description
%   removerange(from,to) removes the region of the spectra delimited by the
%   values from and to (inclusive). The parameters from and to are in xaxis
%   units (not index values). This version modifies the original object.
%
%   removerange(from1,to1,from2,to2,...) removes the multiple regions.
%   Regions are in pairs: from -> to. This version modifies the original
%   object.
%
%   modified = removerange(____) first creates a clone of the object,
%   then removes the relevant portion(s) of the spectra from the clone. The
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


ranges = cell2mat(varargin);
if rem(length(ranges),2)
    err = MException('CHI:ChiSpectralCollection:IOError', ...
        'The ranges variable must be pairs of range limits.');
    throw(err);
end

ranges = reshape(ranges,2,[]);
ranges = ranges';
ranges = sort(ranges,2); %#ok<UDIM>
numRanges = size(ranges,1);

% Sanity check
% closest = zeros(size(range));
% closest(:,1) = this.indexat(ranges(:,1));
% closest(:,2) = this.indexat(ranges(:,2));

% Convert x-axis units to index values making sure the range limits are
% within the values of the range
rangesidx(:,1) = this.indexat(ranges(:,1),'higherthan');
rangesidx(:,2) = this.indexat(ranges(:,2),'lowerthan');

if (nargout > 0)
    % We are expecting to generate a modified clone of this object
    varargout{1} = clone(this);
    % Record what we have done (are about to do)
    for r = 1:numRanges    
        varargout{1}.history.add(['removerange: from ', num2str(ranges(r,1)), ' to ', num2str(ranges(r,2))]);
    end
    % Re-order the ranges into ascending order
    rangesidx = reshape(rangesidx',1,[]);
    % Hand off the actual range removal to removerangeidx
    removerangeidx(varargout{1},rangesidx);
else
    % We are expecting to modified this object in situ
    % Record what we have done (are about to do)
    for r = 1:numRanges    
        this.history.add(['removerange: from ', num2str(ranges(r,1)), ' to ', num2str(ranges(r,2))]);
    end
    % Re-order the ranges into ascending order
    rangesidx = reshape(rangesidx',1,[]);
    % Hand off the actual range removal to removerangeidx
    removerangeidx(this,rangesidx);
end

end % function removerange
