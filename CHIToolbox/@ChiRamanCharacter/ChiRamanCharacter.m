classdef ChiRamanCharacter < handle

% ChiRamanCharacter  Features specific to Raman data
%
% Description
%   This class is used internally to imbue data with characteristics of
%   Raman spectroscopy.
% 
% Copyright (c) 2018, Alex Henderson.
% Licenced under the GNU General Public License (GPL) version 3.
%
% See also 
%   ChiRamanSpectrum ChiRamanSpectralCollection ChiRamanImage 

% Contact email: alex.henderson@manchester.ac.uk
% Licenced under the GNU General Public License (GPL) version 3
% http://www.gnu.org/copyleft/gpl.html
% Other licensing options are available, please contact Alex for details
% If you use this file in your work, please acknowledge the author(s) in
% your publications. 

% Version 1.0, August 2018
% The latest version of this file is available on Bitbucket
% https://bitbucket.org/AlexHenderson/chitoolbox


    properties
        baseline    % A model of the Raman baseline
    end
    
    methods
        %~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
        function this = ChiRamanCharacter()
            % ChiRamanCharacter  Adds Raman spectroscopy characteristics to a dataset
            % 
            % Syntax
            %   obj = ChiRamanCharacter();
            % 
            % Description
            %   obj = ChiRamanCharacter() signals that the data is produced
            %   by Raman spectroscopy. The baseline property defaults to a
            %   ChiRamanAsymmBaseline
            
            this.baseline = ChiRamanAsymmBaseline(this);
        end

        % ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
        function obj = clone(this)
            % clone  Make a deep copy of this object 
            % 
            % Syntax
            %   obj = clone(this);
            % 
            % Description
            %   obj = clone(this) makes a deep copy of this object

            obj = ChiRamanCharacter();
            obj.baseline = this.baseline.clone();
        end
        % ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    end
    
end
