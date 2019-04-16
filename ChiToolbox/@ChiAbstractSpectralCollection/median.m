function spectrum = median(this)

% MEDIAN 

    spectrumclass = str2func(this.spectrumclassname);
    spectrum = spectrumclass(this.xvals,ChiMedian(this.data),this.reversex,...
        this.xlabelname,this.xlabelunit,this.ylabelname,this.ylabelunit,...
        this.classmembership,this.filenames,this.history);
    spectrum.history.add('Median of spectral collection');

end
