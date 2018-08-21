function baseline = calculate(this, data) %#ok<INUSD>

% calculate  Calculates an asymmetric least squares baseline from the data.
%
% Syntax
%   baseline = calculate(data);
%
% Description
%   baseline = calculate(this, data) computes an asymmetric least squares baseline for each
%   spectrum in the data.
% 
% Notes
%   This function is a wrapper around code from the
%   Biospec/cluster-toolbox-v2.0 library:
%   https://github.com/Biospec/cluster-toolbox-v2.0/tree/master/cluster_toolbox
% 
% Copyright (c) 2018, Alex Henderson.
% Licenced under the GNU General Public License (GPL) version 3.
%
% See also 
%   model, remove

% Contact email: alex.henderson@manchester.ac.uk
% Licenced under the GNU General Public License (GPL) version 3
% http://www.gnu.org/copyleft/gpl.html
% Other licensing options are available, please contact Alex for details
% If you use this file in your work, please acknowledge the author(s) in
% your publications. 

% Version 1.0, August 2018
% The latest version of this file is available on Bitbucket
% https://bitbucket.org/AlexHenderson/chitoolbox


% asysm works on columns of data, hence the double transposition

    if exist('data','var')
        baseline = biospec.cluster_toolbox.asysm(this.datatomodel.data', this.lambda, this.asymm, this.penalty)';
    else
        baseline = biospec.cluster_toolbox.asysm(this.parent.data', this.lambda, this.asymm, this.penalty)';
    end
    
end
