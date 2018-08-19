function spectrum = mean(this)
% MEAN

    spectrumclass = str2func(this.spectrumclassname);
    spectrum = spectrumclass(this.xvals,mean(this.data),this.reversex,this.xlabel,this.ylabel);
    spectrum.history.add('Mean spectrum of image');

end
