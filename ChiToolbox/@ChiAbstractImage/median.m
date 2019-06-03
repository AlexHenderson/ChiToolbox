function medianspectrum = median(this)

% median  Calculates the median of the spectra in the image. 
%
% Syntax
%   medianspectrum = median();
%
% Description
%   medianspectrum = median() calculates the median of the spectra in the
%   image. medianspectrum is the appropriate Chi*Spectrum
%
% Copyright (c) 2018, Alex Henderson.
% Licenced under the GNU General Public License (GPL) version 3.
%
% See also 
%   mean sum.

% Contact email: alex.henderson@manchester.ac.uk
% Licenced under the GNU General Public License (GPL) version 3
% http://www.gnu.org/copyleft/gpl.html
% Other licensing options are available, please contact Alex for details
% If you use this file in your work, please acknowledge the author(s) in
% your publications. 

% The latest version of this file is available on Bitbucket
% https://bitbucket.org/AlexHenderson/chitoolbox


    spectrumclass = str2func(this.spectrumclassname);
    medianspectrum = spectrumclass(this.xvals,ChiMedian(this.data),this.reversex,...
        this.xlabelname,this.xlabelunit,this.ylabelname,this.ylabelunit,...
        this.classmembership,this.filenames,this.history);
    medianspectrum.history.add('Median spectrum of image');

end
