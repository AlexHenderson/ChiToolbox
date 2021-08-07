function spectrum = spectrumat(this,which)
% Get spectrum at the location in the list
% Copyright (c) 2014-2021 Alex Henderson (alex.henderson@manchester.ac.uk)

    % Handle error where xpos and/or ypos are outside image
    if ((which > this.numspectra) || (which < 1))
        err = MException(['CHI:',mfilename,':OutOfRange'], ...
            'Requested spectrum is outside collection');
        throw(err);
    end            

    spectrumclass = str2func(this.spectrumclassname);
    spectrum = spectrumclass(this.xvals,this.data(which,:),this.reversex,this.xlabelname,this.xlabelunit,this.ylabelname,this.ylabelunit);
    spectrum.history.add(['Spectrum at pos=', num2str(which)]);
    this.history.add(['Spectrum at pos=', num2str(which)]);

    if ~isempty(this.classmembership)
        spectrum.classmembership = this.classmembership.extractentries(which);
    end    
    
    if isprop(this,'iscentroided')
        spectrum.iscentroided = this.iscentroided;
    end

    spectrum.linearity = this.linearity;
    
end
