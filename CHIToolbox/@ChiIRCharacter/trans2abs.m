function obj = trans2abs(this)
    if nargout
        % Want to send output to a new object so clone and re-enter
        % the function from the clone
        obj = this.clone(); 
        obj.trans2abs();
    else
        % Absorbance = 2 - log10(%T)
        % http://www.sensafe.com/conversion-formulas/
        utilities.warningnobacktrace('Assuming data is in percentage transmittance units.');
        this.data = 2 - log10(this.data); 
        this.ylabel = 'absorbance'; 
        this.history.add('Converted to absorbance'); 
    end
end
