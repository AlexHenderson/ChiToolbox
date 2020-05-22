function plsresult = pls(this,varargin)

% pls  Partial Least Squares Regression
%
% Syntax
%   plsresult = pls();
%   plsresult = pls(____,ncomp);
%   plsresult = pls(____,depvar);
%
% Description
%   plsresult = pls() performs partial least squares regression on the
%   spectra in this collection. Uses plsregress internally. The data (both
%   x and y blocks) are mean centered internally. By default the current
%   classmembership is used as the dependent variable (Y block) and ncomp =
%   10 for the number of pls components to calculate. The output is stored
%   in a ChiPLSModel object.
%
%   plsresult = pls(____,ncomp) uses ncomp for the number of pls
%   components to calculate. 
% 
%   plsresult = pls(____,depvar) uses depvar as the dependent variable (Y
%   block). depvar is a ChiClassMembership object with numeric labels.
% 
% Copyright (c) 2020, Alex Henderson.
% Licenced under the GNU General Public License (GPL) version 3.
%
% See also 
%   plsregress ChiPLSModel ChiSpectralCollection.

% Contact email: alex.henderson@manchester.ac.uk
% Licenced under the GNU General Public License (GPL) version 3
% http://www.gnu.org/copyleft/gpl.html
% Other licensing options are available, please contact Alex for details
% If you use this file in your work, please acknowledge the author(s) in
% your publications. 

% Version 1.0, May 2020
% The latest version of this file is available on Bitbucket
% https://bitbucket.org/AlexHenderson/chitoolbox


% Do we have the statistics toolbox
if ~exist('plsregress','file')
    err = MException(['CHI:',mfilename,':InputError'], ...
        'The Statistics and Machine Learning Toolbox is required for this function.');
    throw(err);
end

% Defaults
ncomp = 10;
depvar = [];

% Has a number of components been supplied?
argposition = find(cellfun(@(x) isscalar(x) , varargin));
if argposition
    ncomp = varargin{argposition};
    varargin(argposition) = [];
end

% Has depvar been provided as a ChiClassMembership object
argposition = find(cellfun(@(x) isa(x, 'ChiClassMembership') , varargin));
if argposition
    depvar = varargin{argposition}.clone();
    varargin(argposition) = []; %#ok<NASGU>
end

if isempty(depvar)
    % Use the object's classmembership, if available
    if isempty(this.classmembership)
        err = MException(['CHI:', mfilename,':InputError'], ...
            'No dependent variable provided, or classmembership available.');
        throw(err);
    else
        depvar = this.classmembership.clone();
    end
end

% depvar classmembership is available, but is it useful?
if ~isnumeric(depvar.labels(1))
    err = MException(['CHI:', mfilename,':InputError'], ...
        'The dependent variable is not numeric.');
    throw(err);
end

if (depvar.numentries ~= this.numspectra)
    err = MException(['CHI:', mfilename,':InputError'], ...
        'The dependent variable must have the same number of elements as there are spectra.');
    throw(err);
end

% meanX = mean(this.data);
% meanY = mean(depvar);

% X = utilities.meancenter(this.data);        % a matrix
% y = utilities.meancenter(depvar.labels);    % a vector (PLS1)

X = this.data;        % a matrix
y = depvar.labels;    % a vector (PLS1)

% Just use plsregress for now and migrate to an open source version later. 

% Both X and Y are mean centered by plsregress anyway
[xloadings,yloadings,xscores,yscores,beta,PCTVAR,MSE,stats] = plsregress(X,y,ncomp); %#ok<ASGLU>

% [b,R,xscores,xloadings,yloadings,yscores] = JChemometrics_23_2009_518.simpls1(X,depvar,ncomp); %#ok<ASGLU>
% [b,R,xscores,xloadings,yloadings,yscores] = JChemometrics_23_2009_518.simpls1Alex(X,depvar,ncomp); %#ok<ASGLU>
% [b,R,xscores,xloadings,yloadings,yscores] = JChemometrics_23_2009_518.plsr(X,depvar,ncomp); %#ok<ASGLU>

% Convert to percentages
xexplained = 100 * PCTVAR(1,:);
yexplained = 100 * PCTVAR(2,:);

weights = stats.W;
regressioncoeffs = beta;
y_hat = horzcat(ones(this.numspectra,1), this.data) * regressioncoeffs;
residuals = y - y_hat;

algorithm = 'plsregress';
this.history.add('PLS algorithm: plsregress');

plsresult = ChiPLSModel(xscores,xloadings,...
                yscores,yloadings,...
                xexplained,yexplained,...
                regressioncoeffs,weights,...
                ncomp,residuals,...
                this.xvals,...
                this.xlabelname,this.xlabelunit,...
                this.reversex,...
                depvar,...
                algorithm,...
                this.history);

end % function: pls
