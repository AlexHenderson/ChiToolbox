classdef ChiIRCharacter < handle

% ChiIRCharacter  Features of IR data
% Copyright (c) 2017 Alex Henderson (alex.henderson@manchester.ac.uk)

    
    methods
        %~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
        function obj = abs2trans(this)
            if nargout
                % Want to send output to a new object so clone and re-enter
                % the function from the clone
                obj = this.clone(); %#ok<MCNPN>
                obj.abs2trans();
            else
                % %T = (10^-Abs)*100
                % http://www.sensafe.com/conversion-formulas/
                utilities.warningnobacktrace('Assuming data is in absorbance units.');
                this.data = (10.^(-this.data)) * 100; %#ok<MCNPN,MCNPR>
                this.ylabel = 'transmittance (%)'; %#ok<MCNPR>
                this.history.add('Converted to percentage transmittance'); %#ok<MCNPN>
            end
        end

        % ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
        function obj = trans2abs(this)
            if nargout
                % Want to send output to a new object so clone and re-enter
                % the function from the clone
                obj = this.clone(); %#ok<MCNPN>
                obj.trans2abs();
            else
                % Absorbance = 2 - log10(%T)
                % http://www.sensafe.com/conversion-formulas/
                utilities.warningnobacktrace('Assuming data is in percentage transmittance units.');
                this.data = 2 - log10(this.data); %#ok<MCNPN,MCNPR>
                this.ylabel = 'absorbance'; %#ok<MCNPR>
                this.history.add('Converted to absorbance'); %#ok<MCNPN>
            end
        end
        
        % ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
        function varargout = removeco(this,varargin)

        % removeco  Removes the CO region from the spectrum (2250-2450 cm^{-1}). 
        %
        % Syntax
        %   removeco();
        %   modified = removeco();
        %
        % Description
        %   removeco() removes the CO region of the spectrum delimited 2250 and 2450
        %   wavenumbers. This version modifies the original object.
        %
        %   modified = removeco() first creates a clone of the object, then removes
        %   the CO region of the spectrum from the clone. The original object is not
        %   modified.
        %
        % Copyright (c) 2017, Alex Henderson.
        % Licenced under the GNU General Public License (GPL) version 3.
        %
        % See also 
        %   removerange ChiSpectrum.

        % Contact email: alex.henderson@manchester.ac.uk
        % Licenced under the GNU General Public License (GPL) version 3
        % http://www.gnu.org/copyleft/gpl.html
        % Other licensing options are available, please contact Alex for details
        % If you use this file in your work, please acknowledge the author(s) in
        % your publications. 

        % Version 1.0, August 2017
        % The latest version of this file is available on Bitbucket
        % https://bitbucket.org/AlexHenderson/chitoolbox


        if nargout
            varargout{:} = removerange(this,2250,2450);
        else
            removerange(this,2250,2450);
        end

        end % function removeco
        
        % ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
        function obj = rmies(this,varargin)

        % rmies  Resonant Mie scattering correction for infrared spectroscopy
        %
        % Syntax
        %   rmies();
        %   rmies(____,options);
        %   rmies(____,reference);
        %   rmies(options,reference);
        %
        % Description
        %   rmies() performs a resonant Mie scattering correction on the data.
        %   Default values for the various options and the internal Matrigel
        %   reference are used. 
        % 
        %   rmies(____,options) perform the correction using the provided options.
        %   options is a rmiesoptions object. 
        % 
        %   rmies(____,reference) uses the provided reference spectrum. reference
        %   is a ChiSpectrum. 
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
        % Copyright (c) 2018, Alex Henderson.
        % Licenced under the GNU General Public License (GPL) version 3.
        %
        % See also 
        %   RMieS_EMSC_v5, rmiesoptions.

        % Contact email: alex.henderson@manchester.ac.uk
        % Licenced under the GNU General Public License (GPL) version 3
        % http://www.gnu.org/copyleft/gpl.html
        % Other licensing options are available, please contact Alex for details
        % If you use this file in your work, please acknowledge the author(s) in
        % your publications. 

        % Version 1.0, March 2018
        % The latest version of this file is available on Bitbucket
        % https://bitbucket.org/AlexHenderson/chitoolbox


        if nargout
            obj = this.clone();
            obj.rmies(varargin{:});
        else
            utilities.rmies(this,varargin{:});
        end
        
        end % function rmies
        
    end % methods
    
end % class
