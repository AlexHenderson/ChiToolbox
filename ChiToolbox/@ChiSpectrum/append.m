function obj = append(this,varargin)

% append  Combines this spectrum with other data into a spectral collection. 
%
% Syntax
%   collection = append(newaddition);
%   collection = append(xvals,data,...);
%
% Description
%   collection = append(newaddition) first creates a spectral collection of
%   the appropriate type. This data is assigned to the collection and then
%   the newaddition is appended to that. newaddition can be a type of
%   ChiSpectrum, or ChiSpectralCollection.
% 
%   collection = append(xvals,data,...) creates a spectral collection of
%   the same base type as this object, then creates either a spectrum, or
%   spectral collection, of the appropriate type from the xvals, data and
%   other appropriate variables, and appends that. 
%
% Notes
%   If newaddition, or xvals, have different spectral limits, then the
%   entire collection is modified to truncate the limits to the maximal
%   overlapped spectral range. If the appended data has a different number
%   of data points, then it is linearly interpolated to match the original
%   object.
%
% Copyright (c) 2019-2020, Alex Henderson.
% Licenced under the GNU General Public License (GPL) version 3.
%
% See also 
%   ChiSpectrum ChiSpectralCollection.

% Contact email: alex.henderson@manchester.ac.uk
% Licenced under the GNU General Public License (GPL) version 3
% http://www.gnu.org/copyleft/gpl.html
% Other licensing options are available, please contact Alex for details
% If you use this file in your work, please acknowledge the author(s) in
% your publications. 

% Version 1.0, February 2019
% The latest version of this file is available at:
% https://github.com/AlexHenderson/ChiToolbox


if ~nargout
    err = MException(['CHI:',mfilename,':InputError'], ...
        ['We cannot append to this ChiSpectrum. Create a ChiSpectralCollection of type ''', ...
        this.spectralcollectionclassname, ''', and append to that.']);
    throw(err);
end    

if (nargin == 2)
    % We only have a single entry, so check if it is a spectrum, or a
    % spectral collection and we are appending appropriate types of data
    ok = false;
    if strcmpi(class(this), class(varargin{1}))
        ok = true;
    else
        if strcmpi(this.spectralcollectionclassname, class(varargin{1}))
            ok = true;
        end
    end
    if ~ok
        err = MException(['CHI:',mfilename,':InputError'], ...
            ['Data type mis-match: ', ...
            class(this), ' and ', class(varargin{1})]);
        throw(err);
    end
    
    % Create a new collection of the same basic type as this
    obj = feval(this.spectralcollectionclassname);

    % Append this to the new collection
    obj.append(this);

    % Append the additional data to the new collection
    obj.append(varargin{:});
    
else
    % We must have a raw data set, so convert to a Chi object of the
    % same type as this and re-run
    utilities.warningnobacktrace('Assuming appended data is of appropriate type');
    % varargin{1} is xvals, varargin{2} is data
    if isvector(varargin{2})
        % We have a vector of data so generate a Chi*Spectrum
        newdata = feval(class(this),varargin{:});
    else
        % We have a matrix of data so generate a Chi*SpectralCollection
        newdata = feval(this.spectralcollectionclassname,varargin{:});
    end
    obj = this.append(newdata);
end
    
end % function: append
