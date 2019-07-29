function obj = meancenter(this,varargin)

% meancenter  Subtracts the mean of each variable from the data
%
% Syntax
%   meancenter();
%   output = meancenter();
%
% Description
%   meancenter() calculates the mean of the data and subtracts that from
%   each spectrum.
% 
%   output = meancenter() creats a clone of teh data prior to mean
%   centering. The original data is not modified.
%
% Copyright (c) 2019, Alex Henderson.
% Licenced under the GNU General Public License (GPL) version 3.
%
% See also 
%   utilities.meancenter.

% Contact email: alex.henderson@manchester.ac.uk
% Licenced under the GNU General Public License (GPL) version 3
% http://www.gnu.org/copyleft/gpl.html
% Other licensing options are available, please contact Alex for details
% If you use this file in your work, please acknowledge the author(s) in
% your publications. 

% Version 1.0, March 2019
% The latest version of this file is available on Bitbucket
% https://bitbucket.org/AlexHenderson/chitoolbox


if nargout
    obj = this.clone();
    obj.meancenter(varargin{:});
else
    % We are expecting to modified this object in situ
    this.data = utilities.meancenter(this.data);
    
    this.ylabelname = [this.ylabelname, ' (mean centered)'];

    message = 'mean centered';
    this.history.add(message);
end
    
end
