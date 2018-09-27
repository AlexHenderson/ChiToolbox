function append(this,varargin)

% append  Appends data to this ChiSpectralCollection. 
%
% Syntax
%   append(newaddition);
%   newcollection = append(newaddition);
%
% Description
%   append(newaddition) appends the newaddition to the
%   ChiSpectralCollection
%
%   newobject = append(newaddition) first create a clone of the collection
%   and appends the newaddition to that. The original collection is
%   untouched.
%
%   newaddition can be either a ChiSpectrum, or a ChiSpectralCollection.
%
% Notes
%   If the newaddition has different spectral limits, then the entire
%   collection is modified to truncate the limits to the maximal overlapped
%   spectral range. If the new addition has a different number of data
%   points, then it is linearly interpolated to match the original object.
%
% Copyright (c) 2017, Alex Henderson.
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

% Version 1.0, July 2017
% The latest version of this file is available on Bitbucket
% https://bitbucket.org/AlexHenderson/chitoolbox

if (nargin == 2)
    % We only have a single entry, so check if it is a spectrum or a
    % spectral collection

    if isa(varargin{1},'ChiSpectrum')
        % Append this spectrum
        appendspectrum(this,varargin{:});
    end

    if isa(varargin{1},'ChiSpectralCollection')
        % Append this spectralcollection
        this = appendcollection(this,varargin{:});        
    end

else
    % We must have a raw data set, so convert to a ChiSpectrum and re-run
    newspectrum = ChiSpectrum(varargin{:});
    this.append(newspectrum);
end

end

%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
function this = appendspectrum(this,varargin)

% If we have an empty collection, we simply need to set the values
if isempty(this.xvals)
    this.xvals = varargin{1}.xvals;
    this.data = varargin{1}.data;
    this.reversex = varargin{1}.reversex;
    this.xlabelname = varargin{1}.xlabelname;
    this.xlabelunit = varargin{1}.xlabelunit;
    this.ylabelname = varargin{1}.ylabelname;
    this.ylabelunit = varargin{1}.ylabelunit;
else
    newspectrum = varargin{1}.clone();

    % ToDo: Check that the spectrum is of the same type Check that the
    % spectrum has the same length and xvalues, otherwise interpolate

    needtointerpolate = false;
    if (length(this.xvals) ~= length(newspectrum.xvals))
        % Different number of data points, so we need to interpolate
        % the data. This is examined separately otherwise, if the two
        % vectors are of different length, MATLAB raises an error.
        needtointerpolate = true;
    else
        if (this.xvals ~= newspectrum.xvals)
            % Different x-values, so we need to interpolate the data
            needtointerpolate = true;
        end
    end

    if needtointerpolate
        % First determine the range over which the mismatched spectra
        % overlap. Then truncate both the x-vector and data matrix for
        % the data already processed in addition to the new data.

        lowx = max(this.xvals(1), newspectrum.xvals(1));
        highx = min(this.xvals(end), newspectrum.xvals(end));

        lowidx = this.indexat(lowx);
        highidx = this.indexat(highx);
        this.xvals = this.xvals(lowidx:highidx);
        this.data = this.data(:,lowidx:highidx);

        lowidx = newspectrum.indexat(lowx);
        highidx = newspectrum.indexat(highx);
        newspectrum.xvals = newspectrum.xvals(lowidx:highidx);
        newspectrum.data = newspectrum.data(:,lowidx:highidx);

        % Now interpolate the new spectrum vector to match the existing
        % data.

        newspectrum.data = interp1(newspectrum.xvals,newspectrum.data,this.xvals,'linear');
    end

    this.data = vertcat(this.data,newspectrum.data);

    % Sometimes the interpolation turns up a NaN in either the first or
    % last channel. Possibly both. Here we truncate the data to remove
    % them.
    if find(isnan(this.data(:,1)))
        this.xvals = this.xvals(2:end);
        this.data = this.data(:,2:end);
    end
    if find(isnan(this.data(:,end)))
        this.xvals = this.xvals(1:end-1);
        this.data = this.data(:,1:end-1);
    end

    % ToDo: If classmemberhsip exists, it is now invalid as it isn't
    % the same length as the data

end
end

%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
function this = appendcollection(this,varargin)

% If we have an empty collection, we simply need to set the values
if isempty(this.xvals)
    % Effectively create a clone, except doing that doesn't work. Grrr
    this.xvals = varargin{1}.xvals;
    this.data = varargin{1}.data;
    this.reversex = varargin{1}.reversex;
    this.xlabelname = varargin{1}.xlabelname;
    this.xlabelunit = varargin{1}.xlabelunit;
    this.ylabelname = varargin{1}.ylabelname;
    this.ylabelunit = varargin{1}.ylabelunit;
    if ~isempty(varargin{1}.classmembership)
        this.classmembership = varargin{1}.classmembership.clone();
    end
    this.filenames  = varargin{1}.filenames;
    if ~isempty(varargin{1}.history)
        this.history = varargin{1}.history.clone();
    end
else
        
    newcoll = varargin{1}.clone();

    % ToDo: Check that the spectrum is of the same type Check that the
    % spectrum has the same length and xvalues, otherwise interpolate

    needtointerpolate = false;
    if (length(this.xvals) ~= length(newcoll.xvals))
        % Different number of data points, so we need to interpolate
        % the data. This is examined separately otherwise, if the two
        % vectors are of different length, MATLAB raises an error.
        needtointerpolate = true;
    else
        if (this.xvals ~= newcoll.xvals)
            % Different x-values, so we need to interpolate the data
            needtointerpolate = true;
        end
    end

    if needtointerpolate
        % First determine the range over which the mismatched spectra
        % overlap. Then truncate both the x-vector and data matrix for
        % the data already processed in addition to the new data.

        lowx = max(this.xvals(1), newcoll.xvals(1));
        highx = min(this.xvals(end), newcoll.xvals(end));

        lowidx = this.indexat(lowx);
        highidx = this.indexat(highx);
        this.xvals = this.xvals(lowidx:highidx);
        this.data = this.data(:,lowidx:highidx);

        lowidx = newcoll.indexat(lowx);
        highidx = newcoll.indexat(highx);
        newcoll.xvals = newcoll.xvals(lowidx:highidx);
        newcoll.data = newcoll.data(:,lowidx:highidx);

        % Now interpolate the new spectrum vector to match the existing
        % data.

        % ToDO: check we can interpolate a matrix
        newcoll.data = interp1(newcoll.xvals,newcoll.data,this.xvals,'linear');
    end

    this.data = vertcat(this.data,newcoll.data);

    % Sometimes the interpolation turns up a NaN in either the first or
    % last channel. Possibly both. Here we truncate the data to remove
    % them.
    if find(isnan(this.data(:,1)))
        this.xvals = this.xvals(2:end);
        this.data = this.data(:,2:end);
    end
    if find(isnan(this.data(:,end)))
        this.xvals = this.xvals(1:end-1);
        this.data = this.data(:,1:end-1);
    end

    % ToDo: If classmemberhsip exists, it it now invalid as it isn't
    % the same length as the data
end

end

