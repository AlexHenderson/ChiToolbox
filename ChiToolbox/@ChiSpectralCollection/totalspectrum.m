function spectrum = totalspectrum(this)
% Sum of spectra
% Copyright (c) 2019-2021 Alex Henderson (alex.henderson@manchester.ac.uk)

    spectrumclass = str2func(this.spectrumclassname);
    spectrum = spectrumclass(this.xvals,sum(this.data),this.reversex,this.xlabelname,this.xlabelunit,this.ylabelname,this.ylabelunit);
    spectrum.history.add('Sum of spectra');
    this.history.add('Sum of spectra');
    
    if isprop(this,'iscentroided')
        spectrum.iscentroided = this.iscentroided;
    end

    spectrum.linearity = this.linearity;

end
