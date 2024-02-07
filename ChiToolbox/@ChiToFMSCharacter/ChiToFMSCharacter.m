classdef ChiToFMSCharacter < ChiMSCharacter

% ChiToFMSCharacter  Features specific to time-of-flight mass spectral data
%
% Description
%   This class is used internally to imbue data with characteristics of
%   time-of-flight mass spectrometry.
% 
% Copyright (c) 2018-2021, Alex Henderson.
% Licenced under the GNU General Public License (GPL) version 3.
%
% See also 
%   ChiToFMSSpectrum ChiToFMSSpectralCollection ChiToFMSImage
%   ChiMSCharacter ChiXAxisLinearity.

% Contact email: alex.henderson@manchester.ac.uk
% Licenced under the GNU General Public License (GPL) version 3
% http://www.gnu.org/copyleft/gpl.html
% Other licensing options are available, please contact Alex for details
% If you use this file in your work, please acknowledge the author(s) in
% your publications. 

% Version 3.0, August 2021
% The latest version of this file is available at:
% https://github.com/AlexHenderson/ChiToolbox


    properties
%         timeresolution  % in picoseconds
%         constanta       % a in ax^2 + bx + c
%         constantb       % b in ax^2 + bx + c
%         constantc       % c in ax^2 + bx + c
    end

    methods
        function this = ChiToFMSCharacter()
            this.linearity = ChiXAxisLinearity.quadratic;
        end
    end

end
