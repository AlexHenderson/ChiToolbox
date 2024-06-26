classdef ChiModel < ChiBase

% ChiModel  Simply a base class for algorithmic models.
% 
% Description
%   This class exists to identify objects that are models resulting from
%   classification or regression algorithms. 
% 
% Copyright (c) 2021, Alex Henderson.
% Licenced under the GNU General Public License (GPL) version 3.
%
% See also 
%   ChiPCAModel ChiPCCVAModel ChiMLModel ChiBase

% Contact email: alex.henderson@manchester.ac.uk
% Licenced under the GNU General Public License (GPL) version 3
% http://www.gnu.org/copyleft/gpl.html
% Other licensing options are available, please contact Alex for details
% If you use this file in your work, please acknowledge the author(s) in
% your publications. 

% Version 2.0, August 2021
% The latest version of this file is available at:
% https://github.com/AlexHenderson/ChiToolbox

    properties
        iscentroided = false;   % Is the source data centroided
        linearity;              % Shape of x-axis (discrete, linear, quadratic)
    end    

end
