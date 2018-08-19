function spectrum = median(this)

% MEDIAN 

    spectrumclass = str2func(this.spectrumclassname);
    spectrum = spectrumclass(this.xvals,median(this.data),this.reversex,this.xlabel,this.ylabel);
    spectrum.history.add('Median spectrum of image');

end
