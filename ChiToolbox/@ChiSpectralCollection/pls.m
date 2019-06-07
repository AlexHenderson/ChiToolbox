function plsresult = pls(this,depvar,ncomp)

% error('Not working yet');

% pca Principal Components Analysis
%
% Syntax
%   pcaresult = pca();
%
% Description
%   pcaresult = pca() performs principal components analysis on the spectra
%   in this collection. The data is mean centered internally. The output is
%   stored in a ChiSpectralPCAOutcome object.
%
% Copyright (c) 2017, Alex Henderson.
% Licenced under the GNU General Public License (GPL) version 3.
%
% See also 
%   princomp pca ChiSpectralPCAOutcome ChiSpectralCollection.

% Contact email: alex.henderson@manchester.ac.uk
% Licenced under the GNU General Public License (GPL) version 3
% http://www.gnu.org/copyleft/gpl.html
% Other licensing options are available, please contact Alex for details
% If you use this file in your work, please acknowledge the author(s) in
% your publications. 

% Version 1.0, July 2017
% The latest version of this file is available on Bitbucket
% https://bitbucket.org/AlexHenderson/chitoolbox


% ToDo: change inputs to accept ncomp without depvar


yblocklabelname = 'dependent variable';
yblocklabelunit = '';

if ~exist('depvar','var')
    if isnumeric(this.classmembership.labels(1))
        utilities.warningnobacktrace(['Using class membership "', this.classmembership.title, '" as the dependent variable.']);
        depvar = this.classmembership.labels;
        yblocklabelname = this.classmembership.title;
    else
        err = MException(['CHI:', mfilename,':InputError'], ...
            'The dependent variable is missing, or not numeric.');
        throw(err);
    end
end

if ~isvector(depvar)
    err = MException(['CHI:', mfilename,':InputError'], ...
        'The dependent variable must be a vector.');
    throw(err);
end    

if (length(depvar) ~= this.numspectra)
    err = MException(['CHI:', mfilename,':InputError'], ...
        'The dependent variable must have the same number of elements as there are spectra.');
    throw(err);
end

if ~exist('ncomp','var')
    ncomp = 10;
end

X = utilities.meancenter(this.data);
depvar = utilities.meancenter(depvar);

[b,R,xscores,xloadings,yloadings,yscores] = JChemometrics_23_2009_518.simpls1(X,depvar,ncomp); %#ok<ASGLU>

xexplained = 100 * sum(xloadings .* xloadings) ./ sum(sum(X .* X));
yexplained = 100 * sum(yloadings .* yloadings) ./ sum(sum(depvar .* depvar));

plsresult = ChiSpectralPLSOutcome(xscores,xloadings,...
                yscores,yloadings,...
                xexplained,yexplained,...
                ncomp,this.xvals,...
                this.xlabelname,this.xlabelunit,...
                yblocklabelname,yblocklabelunit,...
                this.reversex,this.classmembership,this.history);

% figure;plot(1:ncomp,cumsum(100*PCTVAR(2,:)),'-bo');

end
