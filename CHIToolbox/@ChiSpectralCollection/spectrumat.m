function output = spectrumat(this,spectrumNumber)
% Get spectrum at the location in the list
% Copyright (c) 2014 Alex Henderson (alex.henderson@manchester.ac.uk)

    % Handle error where xpos and/or ypos are outside image
    if ((spectrumNumber > this.numSpectra) || (spectrumNumber < 1))
        err = MException('CHI:ChiSpectralCollection:OutOfRange', ...
            'Requested spectrum is outside collection');
        throw(err);
    end            

    output = ChiSpectrum(this.xvals,this.data(spectrumNumber,:),this.reversex,this.xlabel,this.ylabel);
    output.history.add(['spectrumat, pos=', num2str(spectrumNumber)]);
    this.history.add(['spectrumat, pos=', num2str(spectrumNumber)]);

end
