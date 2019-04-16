function spectrum = sum(this)

% SUM

    spectrumclass = str2func(this.spectrumclassname);
    spectrum = spectrumclass(this.xvals,ChiSum(this.data),this.reversex,...
        this.xlabelname,this.xlabelunit,this.ylabelname,this.ylabelunit,...
        this.classmembership,this.filenames,this.history);
    spectrum.history.add('Sum spectrum of image');

end
