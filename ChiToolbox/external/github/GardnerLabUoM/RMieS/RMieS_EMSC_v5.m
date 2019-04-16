function [WN_out,ZCorr,history] = RMieS_EMSC_v5(WN,ZRaw,correction_options,WN_Ref_in,Ref_in)

% RMieS_EMSC_v5 Resonant Mie Scattering Correction
% 
% Syntax
%   [WN_out,ZCorr,history] =
%       RMieS_EMSC_v5(WN,ZRaw,correction_options);
%   [WN_out,ZCorr,history] =
%       RMieS_EMSC_v5(WN,ZRaw,correction_options,WN_Ref_in,Ref_in);
%
% Description
%   [WN_out,ZCorr,history] = RMieS_EMSC_v5(WN,ZRaw,correction_options)
%   performs a correction to mid-infrared spectra corresponding to resonant
%   Mie theory. WN is the wavenumber vector. ZRaw is a 2D matrix containing
%   absorbance spectra in rows. correction_options is a vector containing
%   options (see below). WN_out is the wavenumber vector of the corrected
%   spectra. ZCorr is a 2D matrix of corrected spectra in rows. history is
%   a 3D matrix of dimension; numberOfSpectra x length(WN_out) x
%   iterations. 
%
%   [WN_out,ZCorr,history] =
%   RMieS_EMSC_v5(WN,ZRaw,correction_options,WN_Ref_in,Ref_in) utilises a
%   user supplied reference spectrum. WN_Ref_in is a wavenumber vector
%   corresponding to the reference spectrum. Ref_in is a vector of absorbance
%   values of the reference sample.
%
%   correction options is a vector with the following default parameters:
%   correction_options = [ ...
%     0    ; % 1. Desired resolution, (0 keeps original resolution)
%     1000 ; % 2. Lower wavenumber range (min value is 1000)
%     4000 ; % 3. Upper wavenumber range (max value is 4000)
%     1    ; % 4. Number of iterations
%     2    ; % 5. Mie theory option (smooth or RMieS)
%     7    ; % 6. Number of principal components used (8 recommended)
%     2    ; % 7. Lower range for scattering particle diameter / um
%     8    ; % 8. Upper range for scattering particle diamter / um
%     1.1  ; % 9. Lower range for average refractive index
%     1.5  ; % 10. Upper range for average refractive index
%     10   ; % 11. Number of values for each scattering parameter default 10
%     1    ; % 12. Orthogonalisation, 0 = no, 1 = yes. (1 recommended)
%     1   ]; % 13. Which reference spectrum, 1 = Matrigel, 2 = Simulated
%
%   The correction_options must be supplied by the user, defaults are not
%   provided by this function. 
%
% Notes
%   Further details of the RMieS method can be found in:
%    Resonant Mie Scattering (RMieS) correction of infrared spectra from
%    highly scattering biological samples. Paul Bassan, Achim Kohler,
%    Harald Martens, Joe Lee, Hugh J. Byrne, Paul Dumas, Ehsan Gazi,
%    Michael Brown, Noel Clarke and Peter Gardner 
%    Analyst 135 (2010) 268-277. https://doi.org/10.1039/B921056C
%   
%   Source code available from https://github.com/GardnerLabUoM/RMieS
%
% Copyright (c) 2010 Paul Bassan
% Modifications Copyright (c) 2017 Alex Henderson
% Licenced under the GNU Lesser General Public License (LGPL) version 3.

% Contact email: Alex Henderson <alex.henderson@manchester.ac.uk>
% Licenced under the GNU Lesser General Public License (LGPL) version 3
% https://www.gnu.org/copyleft/lesser.html
% Other licensing options are available, please contact Alex for details


%% Designate correction options

desired_res = correction_options(1);
lower_WN = correction_options(2);
upper_WN = correction_options(3);
iterations = correction_options(4);
mie_theory = correction_options(5);
NCOMP = correction_options(6);
r_min = correction_options(7);
r_max = correction_options(8);
n_min = correction_options(9);
n_max = correction_options(10);
spacings = correction_options(11);
GSP_flag = correction_options(12);
ref_option = correction_options(13);

%% Sort out resolution

WN = make_column(WN);

if (desired_res > 0)
    [WN,ZRaw] = new_res(WN, ZRaw, desired_res);
end

[a,b] = find_value_min_max(WN, lower_WN, upper_WN);

WN = WN(a:b);
ZRaw = ZRaw(:, a:b);

[N,K] = size(ZRaw);
spectra_names = num2str((1:N)');

%% Reference spectrum

if (nargin == 3)
    if (ref_option == 1)
        load Matrigel_Reference_Raw
        ZRef = spline(ZRef_Raw(:,1), ZRef_Raw(:,2), WN)'; %#ok<NODEF>
        clear ZRef_Raw
    elseif (ref_option == 2)
        load Simulated_ZRef_Raw; 
        ZRef = spline(ZRef_Raw(:,1), ZRef_Raw(:,2), WN)';  %#ok<NODEF>
        clear ZRef_Raw
    else
        error('No reference spectrum option selected')
    end
end

if (nargin == 5)
    if ((length(WN) == length(WN_Ref_in)) ...
            && (length(ZRaw) == length(Ref_in)))
        ref_length_check = 1;
    else
        ref_length_check = 0;
    end
    
    if (ref_length_check == 0)
        ZRef = spline(WN_Ref_in, Ref_in, WN)';
    else
        ZRef = Ref_in;
    end
end

ZRef = ZRef / max(ZRef);

%% Make Saisir Structures & Weights

temp = ZRaw; 
clear ZRaw;

ZRaw.d = temp; 
clear temp;

ZRaw.v = num2str(WN);
ZRaw.i = spectra_names;

temp = ZRef; 
clear ZRef

ZRef.d = temp;
ZRef.v = ZRaw.v;
ZRef.i = 'Ref';

initial_ref = ZRef; %#ok<NASGU>

ZWeightsSpec = Spectrum_Weights(ZRaw);

ZWeightsSpec = Down_weight_spectrum(ZWeightsSpec, 2300, 2400, 0.01);

if (mie_theory == 1)
    ZWeightsSpec = Down_weight_spectrum(ZWeightsSpec, 1500, 2000, 0.01);
end

if (iterations > 1)
    history = zeros(N, K, iterations);    
end

%% Correction

if (mie_theory == 1)
    ZCorr = Mie_maths(ZRef, ZRaw, ZWeightsSpec, NCOMP, mie_theory, ...
                        GSP_flag, r_min, r_max, n_min, n_max, spacings);
    history = ZCorr.d;
elseif (mie_theory == 2)
    [ZCorr,mod_para] = Mie_maths(ZRef, ZRaw, ZWeightsSpec, ...
        NCOMP, mie_theory, GSP_flag, r_min, r_max, n_min, n_max, spacings);
    history(:,:,1) = ZCorr.d;
    res_hist(:,:,1) = mod_para.residual; %#ok<NASGU>
    
    if (iterations > 1)
        for j = 1:N
            ZRaw2.d = ZRaw.d(j, :);
            for i = 2:iterations
                try %#ok<TRYNC>
                    ZRef.d = history(j, :, i-1);

                    ZRef.d = fit_gauss_whole_spec_split(WN, ZRef.d')';
                    [ZCorr,mod_para] = Mie_maths(ZRef, ZRaw2, ZWeightsSpec, ...
                        NCOMP, mie_theory, GSP_flag, r_min, r_max, n_min, n_max, spacings); %#ok<ASGLU>
                    history(j,:,i) = ZCorr.d;

                    disp(['Spectrum ', num2str(j), ' Iteration ', num2str(i), '  ', datestr(now)])
                end
            end
            ZCorr.d = history(:, :, end);
            disp(' ')
        end
    end
end

ZCorr.d = history(:, :, end);

WN_out = WN;
ZCorr = ZCorr.d;

end % end of function RMieS_EMSC_v5
