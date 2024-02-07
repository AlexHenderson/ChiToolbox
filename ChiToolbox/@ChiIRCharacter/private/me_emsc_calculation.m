function [correctedSpectra,wn,info] = me_emsc_calculation(this,varargin)

% me_emsc_calculation  ME-EMSC Mie scattering correction for infrared spectroscopy
%
% Syntax
%   [correctedSpectra,wn,info] = me_emsc_calculation();
%   [correctedSpectra,wn,info] = me_emsc_calculation(options);
%   [correctedSpectra,wn,info] = me_emsc_calculation(reference);
%   [correctedSpectra,wn,info] = me_emsc_calculation(options,reference);
%
% Description
%   [correctedSpectra,wn,info] = me_emsc_calculation() performs a Mie
%   scattering correction on the data using the ME-EMSC algorithm. A
%   default options struct and the internal Matrigel reference are used.
%   correctedSpectra are the corrected intensity values, wn are the
%   corrected wavenumber values and info is a struct of parameters returned
%   by the ME-EMSC calculation. See me_emsc.ME_EMSC for more information.
% 
%   [correctedSpectra,wn,info] = me_emsc_calculation(options) perform the
%   correction using the provided options struct and the default Matrigel
%   reference.
% 
%   [correctedSpectra,wn,info] = me_emsc_calculation(reference) uses the
%   provided reference spectrum as a ChiSpectrum. Default options are
%   applied. 
% 
%   [correctedSpectra,wn,info] = me_emsc_calculation(____) clones the data
%   and performs the correction on the clone. The original data is not
%   modified.
% 
% Any options not set in an options struct will fall back to their default
% values.
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


import me_emsc.*

%% Is a reference supplied?
argposition = find(cellfun(@(x) isa(x, 'ChiSpectrum'), varargin));
if argposition
    reference = varargin{argposition};
else
    % Use built-in matrigel spectrum
    [filepath,name,ext] = fileparts(mfilename('fullpath')); %#ok<ASGLU>
    matrigelfile = fullfile(filepath,'../../external/gitlab/BioSpec_Norway/+me_emsc/data/MatrigelSpectrum.mat');
    matrigel = load(matrigelfile);
    reference = ChiIRSpectrum(matrigel.Mat_1000_4000(:,1),matrigel.Mat_1000_4000(:,2));
end

%% Are options supplied?
options = struct;   % Default to an empty user-defined struct
argposition = find(cellfun(@(x) isstruct(x), varargin));
if argposition
    options = varargin{argposition};
end

%% Data converting
referenceSpectrum = reference.data; % Reference spectrum (Matrigel), row vector 
normalizedReferenceSpectrum = referenceSpectrum/max(referenceSpectrum); % Normalize reference spectrum 
wn_ref = reference.wavenumbers'; % Wavenumbers, coloumn vector 
measuredSpectra = this.data; % Spectra to be corrected, one spectrum per row
wn_raw = this.wavenumbers'; % Wavenumbers, coloumn vector 

%% Adjust the wavenumber region and values of the reference spectrum to be compatible with the raw dataset
[normalizedReferenceSpectrum, measuredSpectra, wn] = me_emsc.adjustWavenumbers(normalizedReferenceSpectrum, wn_ref, measuredSpectra, wn_raw); 

%% Run Mie correction 
[correctedSpectra, residuals, EMSCparameters, numberOfIterations, options] = me_emsc.ME_EMSC(normalizedReferenceSpectrum, measuredSpectra, wn, options);

%% Gather together the outputs
info.residuals = residuals;
info.EMSCparameters = EMSCparameters;
info.numberOfIterations = numberOfIterations;
info.options = options;

end % function: me_emsc_calculation
