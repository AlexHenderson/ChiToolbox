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
    end
    
end
