function varargout = rmiescalculation(this,varargin)

% rmiescalculation  Resonant Mie scattering correction for infrared spectroscopy
%
% Syntax
%   rmiescalculation();
%   rmiescalculation(____,options);
%   rmiescalculation(____,reference);
%   rmiescalculation(options,reference);
%   [corrected] = rmiescalculation(____);
%   [corrected,iterations] = rmiescalculation(____);
%
% Description
%   rmiescalculation() performs a resonant Mie scattering correction on the
%   data. A default rmiesoptions object and the internal Matrigel reference
%   are used.
% 
%   rmiescalculation(____,options) perform the correction using the
%   provided options. options is a rmiesoptions object.
% 
%   rmiescalculation(____,reference) uses the provided reference spectrum.
%   reference is a ChiSpectrum.
% 
%   [corrected] = rmiescalculation(____) clones the data and performs the
%   correction on the clone. The original data is not modified.
% 
%   [corrected,iterations] = rmiescalculation(____) return the iteration
%   history in a ChiRmiesIterations object.
% 
% Version 5 of the RMieS algorithm used is available from
% https://github.com/GardnerLabUoM/RMieS. 
%
% Caution
%   Using a single iteration, each spectrum utilises the same reference
%   spectrum. For subsequent iterations each spectrum utilises its previous
%   iteration as a starting point. This means multiple iterations will take
%   a (*very*) long time to complete for many spectra. Therefore it may be
%   prudent to explore the time taken with a small number of spectra and
%   iterations before moving to larger datasets. 
%
% Copyright (c) 2018-2019, Alex Henderson.
% Licenced under the GNU General Public License (GPL) version 3.
%
% See also 
%   RMieS_EMSC_v5, rmies, rmiesoptions.

% Contact email: alex.henderson@manchester.ac.uk
% Licenced under the GNU General Public License (GPL) version 3
% http://www.gnu.org/copyleft/gpl.html
% Other licensing options are available, please contact Alex for details
% If you use this file in your work, please acknowledge the author(s) in
% your publications. 

% Version 2.0, February 2019
% The latest version of this file is available on Bitbucket
% https://bitbucket.org/AlexHenderson/chitoolbox


% Set some defaults
% rmiesOptions = rmiesoptions(); % Now this is always passed in
reference = [];

if ~isempty(varargin)
    % Is an options object supplied?
    argposition = find(cellfun(@(x) isa(x, 'rmiesoptions'), varargin));
    if argposition
        rmiesOptions = varargin{argposition};
    end
    % Is a reference supplied?
    argposition = find(cellfun(@(x) isa(x, 'ChiSpectrum'), varargin));
    if argposition
        reference = varargin{argposition};
    end
end

% Add correction info to this object
log = {};
log = vertcat(log,'rmies correction:');

if isempty(reference)
    log = vertcat(log,'    Internal reference (Matrigel)');
else
    if isempty(reference.filenames)
        log = vertcat(log,'    External reference: user supplied');
    else
        log = vertcat(log,['    External reference: ', reference.filenames{1}]);
    end
end

props = properties(rmiesOptions);
for i = 1:length(props)
    str = ['rmiesOptions.',props{i}];
    val = eval(str);
    historyString = ['    ', props{i},' = ', num2str(val)];
    log = vertcat(log,historyString); %#ok<AGROW>
end

% Perform the correction
correction_options = rmiesOptions.exportv1();
disp(['Spectrum 1 Iteration 1  ', datestr(now)]);
if isempty(reference)
    correctionHistory = [];
    if rmiesOptions.savehistory
        [correctedX,correctedY,correctionHistory,ZRaw] = RMieS_EMSC_v5(this.xvals, this.data, correction_options);
    else
        [correctedX,correctedY] = RMieS_EMSC_v5(this.xvals, this.data, correction_options);
    end
else
    if rmiesOptions.savehistory
        [correctedX,correctedY,correctionHistory,ZRaw] = RMieS_EMSC_v5(this.xvals, this.data, correction_options, reference.xvals, reference.data);
    else
        [correctedX,correctedY] = RMieS_EMSC_v5(this.xvals, this.data, correction_options, reference.xvals, reference.data);
    end
end

% Manage the iterations output
if ~isempty(correctionHistory)
    numiterations = size(correctionHistory,3);
    output = ChiRmiesIterations(numiterations);
    for i = 1:numiterations
        iteration = this.clone();
        iteration.xvals = correctedX;
        iteration.data = squeeze(correctionHistory(:,:,i));
        iteration.history.add(['RMieS iteration ', num2str(i)]);
        iteration.history.add(log);
        output.append(iteration);
    end
    
    % Add the original data to the ChiRmiesIterations object
    output.original = this.clone();
    output.original.data = ZRaw.d;
    output.original.xvals = str2num(ZRaw.v)'; %#ok<ST2NM>
    
    % Add correction info to the iterations object
    output.history.add(log);
end

% Manage the corrected data output
if nargout
    varargout{1} = this.clone();
    varargout{1}.xvals = correctedX;
    varargout{1}.data = correctedY;
    varargout{1}.history.add(log);    
else
    this.xvals = correctedX;
    this.data = correctedY;
    this.history.add(log);
end

% Output the iterations if requested
if nargin
    if rmiesOptions.savehistory
        varargout{2} = output;
    end
end

end % function rmiescalculation
