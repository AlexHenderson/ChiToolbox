function obj = remove(this)

% remove  Subtracts an asymmetric least squares baseline from the data.
%
% Syntax
%   remove()
%   obj = remove()
%
% Description
%   remove() computes an asymmetric least squares baseline for each
%   spectrum in the data, using the current lambda, asymmetry and penalty
%   values. These baselines are then subtracted from the spectra.
% 
%   obj = remove() first makes a clone of the data and then removes the
%   baselines from the clone. The original data is not modified. 
% 
% Copyright (c) 2018, Alex Henderson.
% Licenced under the GNU General Public License (GPL) version 3.
%
% See also 
%   model

% Contact email: alex.henderson@manchester.ac.uk
% Licenced under the GNU General Public License (GPL) version 3
% http://www.gnu.org/copyleft/gpl.html
% Other licensing options are available, please contact Alex for details
% If you use this file in your work, please acknowledge the author(s) in
% your publications. 

% Version 1.0, August 2018
% The latest version of this file is available on Bitbucket
% https://bitbucket.org/AlexHenderson/chitoolbox


% Calculate the baseline(s)
modelledbaseline = this.calculate();

if nargout
    % Result wanted in a separate Raman dataset
    obj = this.parent.clone();
    obj.data = obj.data - modelledbaseline;
    message = sprintf('Remove asymmetric least squares baseline (params: lambda=%f, asymm=%f, penalty=%f)', this.lambda, this.asymm, this.penalty);
    obj.history.add(message);
else
    % This dataset should be modified
    this.parent.data = this.parent.data - modelledbaseline;
    message = sprintf('Remove asymmetric least squares baseline (params: lambda=%f, asymm=%f, penalty=%f)', this.lambda, this.asymm, this.penalty);
    this.parent.history.add(message);
end
    
end
