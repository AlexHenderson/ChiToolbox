function varargout = me_emsc(this,varargin)

% me_emsc  ME-EMSC Mie scattering correction for infrared spectroscopy
%
% Syntax
%   me_emsc();
%   me_emsc(options);
%   me_emsc(reference);
%   me_emsc(options,reference);
%   [corrected] = me_emsc(____);
%   [corrected,info] = me_emsc(____);
%   [____] = me_emsc(____,Name,Value);
%
% Description
%   me_emsc() performs a Mie scattering correction on the data using the
%   ME-EMSC algorithm. A default options struct and the internal Matrigel
%   reference are used.
% 
%   me_emsc(options) perform the correction using the provided options
%   struct and the default Matrigel reference.
% 
%   me_emsc(reference) uses the provided reference spectrum as a
%   ChiSpectrum. Default options are applied.
% 
%   [corrected] = me_emsc(____) clones the data and performs the correction
%   on the clone. The original data is not modified. 
% 
%   [corrected,info] = me_emsc(____) returns info, a struct containing many
%   parameters used in the calculation.
% 
%   [____] = me_emsc(____,Name,Value) allows the user to provide specific
%   options rather than (or in addition to) an options struct. These
%   Name/Value options override any set in an options struct. 
% 
% Any options not set in either an options struct, or Name/Value pairs will
% fall back to their default values. 
% 
% Default option struct values are:
% 
%     maxIterationNumber = 45; % Int: Maximal number of iterations 
%     scaleRef = true;
%     PCnumber = false; % Int/False: Number of loadings used in the EMSC-model. Overwrites ExplainedVariance if both are set. 
%     PositiveRefSpectrum = true; % True/False: Set negative parts of the reference spectrum to zero 
%     fixIterationNumber = false; % Int: Fixed number of iterations 
%     mode = 'Correction'; 
%     Weights = true; 
%     Weights_InflectionPoints = {[3700 2550], [1900 0]}; % Inflection points of weight function, decreasing order 
%     Weights_Kappa = {[1 1], [1 0]}; % Slope of weight function at corresponding inflection points (options.Weights_InflectionPoints)
%     minRadius = 2;
%     maxRadius = 7.1;
%     minRefractiveIndex = 1.1;
%     maxRefractiveIndex = 1.4;
%     samplingSteps = 10;
%     h = 0.25; % scale index in gamma range
%     ExplainedVariance = 99.96; % Float/False: Explained varance in the set of Mie extinction curves. Used to determine number of loadings in the EMSC-model.  
%     plotResults = false; 
% 
% option struct fields are case-sensitive. 
% 
% The ME-EMSC algorithm is available from 
% https://gitlab.com/BioSpecNorway/me-emsc
%
% Caution
%   Using a single iteration, each spectrum utilises the same reference
%   spectrum. For subsequent iterations each spectrum utilises its previous
%   iteration as a starting point. This means multiple iterations will take
%   a long time to complete for many spectra. Therefore it may be prudent
%   to explore the time taken with a small number of spectra and iterations
%   before moving to larger datasets.
%
% Copyright (c) 2019, Alex Henderson.
% Licenced under the GNU General Public License (GPL) version 3.
%
% See also 
%   me_emsc.ME_EMSC ChiIRSpectrum.rmies

% Contact email: alex.henderson@manchester.ac.uk
% Licenced under the GNU General Public License (GPL) version 3
% http://www.gnu.org/copyleft/gpl.html
% Other licensing options are available, please contact Alex for details
% If you use this file in your work, please acknowledge the author(s) in
% your publications. 

% Version 1.0, February 2019
% The latest version of this file is available at:
% https://github.com/AlexHenderson/ChiToolbox


%%  See whether the user passed in a reference spectrum
reference = []; % Dealt with in me_emsc_calculation.m
if ~isempty(varargin)
    argposition = find(cellfun(@(x) isa(x, 'ChiSpectrum'), varargin));
    if argposition
        reference = varargin{argposition};
        varargin(argposition) = [];
    end
end

%% See whether the user passed in an options struct
% Default options taken directly from ME_EMSC.m
options.maxIterationNumber = 45; % Int: Maximal number of iterations 
options.scaleRef = true;
options.PCnumber = false; % Int/False: Number of loadings used in the EMSC-model. Overwrites ExplainedVariance if both are set. 
options.PositiveRefSpectrum = true; % True/False: Set negative parts of the reference spectrum to zero 
options.fixIterationNumber = false; % Int: Fixed number of iterations 
options.mode = 'Correction'; 
options.Weights = true; 

options.Weights_InflectionPoints = {[3700 2550], [1900 0]}; % Inflection points of weight function, decreasing order 
options.Weights_Kappa = {[1 1], [1 0]}; % Slope of weight function at corresponding inflection points (options.Weights_InflectionPoints)

options.minRadius = 2;
options.maxRadius = 7.1;
options.minRefractiveIndex = 1.1;
options.maxRefractiveIndex = 1.4;
options.samplingSteps = 10;

options.h = 0.25; % scale index in gamma range
options.ExplainedVariance = 99.96; % Float/False: Explained varance in the set of Mie extinction curves. Used to determine number of loadings in the EMSC-model.  

options.plotResults = false; 

if ~isempty(varargin)
    argposition = find(cellfun(@(x) isstruct(x), varargin));
    if argposition
        useroptions = varargin{argposition};
        % Double-check the user options are actually real options. 
        % It's easy to make a typographical error.
        userfieldnames = fieldnames(useroptions);
        for i = 1:length(userfieldnames)
            if isfield(options,userfieldnames{i})
                options.(userfieldnames{i}) = useroptions.(userfieldnames{i});
            else
                err = MException(['CHI:',mfilename,':IOError'], ...
                    ['Option field ''', userfieldnames{i}, ''' not recognised']);
                throw(err);
            end
        end
        varargin(argposition) = [];
    end
end

% Did the user pass in a collection of options
if ~isempty(varargin)
    lenargs = length(varargin);
    if rem(lenargs,2)
        err = MException(['CHI:',mfilename,':IOError'], ...
            'Options should be in pairs');
        throw(err);
    else
        while ~isempty(varargin)
            % Double-check the parameter is a real option. It's easy to
            % make a typographical error.
            if isfield(options,varargin{1})
                options.(varargin{1}) = varargin{2};
                varargin(2) = [];
                varargin(1) = [];
            else
                err = MException(['CHI:',mfilename,':IOError'], ...
                    ['Option field ''', varargin{1}, ''' not recognised']);
                throw(err);
            end
        end
    end
end

%% Perform the calculation
[corrected, wn, info] = this.me_emsc_calculation(options,reference);

%% Collect log entries
optionfields = fieldnames(options);
log = {};
log = vertcat(log,'me-emsc correction:');

if isempty(reference)
    log = vertcat(log,'    Internal reference (Matrigel)');
else
    if isempty(reference.filenames)
        log = vertcat(log,'    External reference: user supplied');
    else
        log = vertcat(log,['    External reference: ', reference.filenames{1}]);
    end
end
for i = 1:length(optionfields)
    str = utilities.tostring(options.(optionfields{i}));
    historyString = ['    ', optionfields{i},' = ', str];
    log = vertcat(log,historyString); %#ok<AGROW>
end

%% Route the various output options
switch nargout
    case 0
        % We wish to scatter-correct this object in-situ
        this.xvals = wn;
        this.data = corrected;
        this.history.add(log);
    case 1
        % We wish to create a new object (a clone) and scatter-correct that
        temp = this.clone();
        temp.xvals = wn;
        temp.data = corrected;
        temp.history.add(log);
        varargout{1} = temp;
    case 2
        % We wish to create a new object (a clone), scatter-correct that
        % and save the correction information
        temp = this.clone();
        temp.xvals = wn;
        temp.data = corrected;
        temp.history.add(log);
        varargout{1} = temp;
        varargout{2} = info;
    otherwise
        err = MException(['CHI:',mfilename,':IOError'], ...
            'Too many output arguments');
        throw(err);
end
    
end % function me_emsc
