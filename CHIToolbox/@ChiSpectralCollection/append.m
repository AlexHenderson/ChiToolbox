function append(this,varargin)
% append Appends a spectrum or a spectral collection to this collection

if (nargin == 2)
    % We only have a single entry, so check if it is a spectrum or a
    % spectral collection

    if isa(varargin{1},'ChiSpectrum')
        % Append this spectrum
        appendspectrum(this,varargin{:});
    end

    if isa(varargin{1},'ChiSpectralCollection')
        % Append this spectralcollection
        appendcollection(this,varargin{:});        
    end

else
    % We must have a raw data set, so convert to a ChiSpectrum and re-run
    
    newspectrum = ChiSpectrum(varargin{:});
    
%     narg = length(varargin);
%     switch narg
%         case 2
%             newspectrum = ChiSpectrum(varargin{:});
%         case 3
%             newspectrum = ChiSpectrum(varargin{1},varargin{1},varargin{1});
%         case 5
%             newspectrum = ChiSpectrum(varargin{1},varargin{1},varargin{1},varargin{1},varargin{1});
%         case 6
%             newspectrum = ChiSpectrum(xvals,data,reversex,xlabel,ylabel,filename);
%         otherwise
%             err = MException('CHI:ChiSpectralCollection:IOError', ...
%             'Not enough information to append these data');
%             throw(err);           
%    end
   this.append(newspectrum);
end

end

%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
function appendspectrum(this,varargin)

% If we have an empty collection, we simply need to set the values
if isempty(this.xvals)
    this.xvals = varargin{1}.xvals;
    this.data = varargin{1}.data;
    this.reversex = varargin{1}.reversex;
    this.xlabel = varargin{1}.xlabel;
    this.ylabel = varargin{1}.ylabel;
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
        % the data already processed as well as the new data.

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

    % ToDo: If classmemberhsip exists, it it now invalid as it isn't
    % the same length as the data

end
end

%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
function appendcollection(this,varargin)

% If we have an empty collection, we simply need to set the values
if isempty(this.xvals)
    this = varargin{1}.clone();
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
        % the data already processed as well as the new data.

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

        % ToDO: cehck we can interpolate a matrix
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

