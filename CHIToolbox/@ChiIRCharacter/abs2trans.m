function obj = abs2trans(this)
    if nargout
        % Want to send output to a new object so clone and re-enter
        % the function from the clone
        obj = this.clone(); 
        obj.abs2trans();
    else
        % %T = (10^-Abs)*100
        % http://www.sensafe.com/conversion-formulas/
        utilities.warningnobacktrace('Assuming data is in absorbance units.');
        this.data = (10.^(-this.data)) * 100; 
        this.ylabel = 'transmittance (%)'; 
        this.history.add('Converted to percentage transmittance');
    end
end
