function spectrum = mean(this)

% MEAN

    spectrumclass = str2func(this.spectrumclassname);
    spectrum = spectrumclass(this.xvals,ChiMean(this.data),this.reversex,...
        this.xlabelname,this.xlabelunit,this.ylabelname,this.ylabelunit,...
        this.classmembership,this.filenames,this.history);
    spectrum.history.add('Mean of spectral collection');

end
