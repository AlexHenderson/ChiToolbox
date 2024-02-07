function meanspectrum = mean(this)

% mean  Calculates the mean of the spectral collection. 
%
% Syntax
%   meanspectrum = mean();
%
% Description
%   meanspectrum = mean() calculates the mean of the spectral collection.
%   meanspectrum is the appropriate Chi*Spectrum
%
% Copyright (c) 2018, Alex Henderson.
% Licenced under the GNU General Public License (GPL) version 3.
%
% See also 
%   median sum.

% Contact email: alex.henderson@manchester.ac.uk
% Licenced under the GNU General Public License (GPL) version 3
% http://www.gnu.org/copyleft/gpl.html
% Other licensing options are available, please contact Alex for details
% If you use this file in your work, please acknowledge the author(s) in
% your publications. 

% The latest version of this file is available at:
% https://github.com/AlexHenderson/ChiToolbox


    spectrumclass = str2func(this.spectrumclassname);
    meanspectrum = spectrumclass(this.xvals,ChiMean(this.data),this.reversex,...
        this.xlabelname,this.xlabelunit,this.ylabelname,this.ylabelunit);
    
    if isprop(this,'history')
        meanspectrum.history = this.history.clone;
    end
    
    meanspectrum.history.add('Mean of spectral collection');

end
