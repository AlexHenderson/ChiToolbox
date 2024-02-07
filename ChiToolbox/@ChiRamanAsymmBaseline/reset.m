function reset(this)

% reset  Reverts the model parameters to their defaults.
%
% Syntax
%   reset();
%
% Description
%   reset() reverts the model parameters to their defaults. These are: 
%       - lambda = 1e6 (note that the gui uses log10 of this value for
%           convenience)
%       - asymmetry = 0.001
%       - penalty = 2
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
% The latest version of this file is available at:
% https://github.com/AlexHenderson/ChiToolbox

    this.lambda  = this.defaultlambda;
    this.asymm   = this.defaultasymm;
    this.penalty = this.defaultpenalty;
    
end
