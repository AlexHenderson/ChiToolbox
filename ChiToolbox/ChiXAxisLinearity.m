classdef ChiXAxisLinearity
    
% ChiXAxisLinearity  Enumeration of x-axis shapes
%
% Syntax
%   discrete = ChiXAxisLinearity.discrete;
%   linear = ChiXAxisLinearity.linear;
%   quadratic = ChiXAxisLinearity.quadratic;
% 
% Description
%   The spectral x-axis can be of differing order. For example, centroided
%   data has discrete x-values, IR spectra have first order (linear) shape,
%   while time-of-flight mass spectrometry data are quadratic in mass, but
%   linear in time.
%
% Copyright (c) 2021, Alex Henderson.
% Licenced under the GNU General Public License (GPL) version 3.
%
% See also 
%   enumeration

% Contact email: alex.henderson@manchester.ac.uk
% Licenced under the GNU General Public License (GPL) version 3
% http://www.gnu.org/copyleft/gpl.html
% Other licensing options are available, please contact Alex for details
% If you use this file in your work, please acknowledge the author(s) in
% your publications. 

% Version 1.0, August 2021
% The latest version of this file is available at:
% https://github.com/AlexHenderson/ChiToolbox


    enumeration
        discrete; 
        linear; 
        quadratic;
    end
    
end
