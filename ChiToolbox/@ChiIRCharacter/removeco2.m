function obj = removeco2(varargin)

% removeco2  Removes the CO2 region from the spectrum. 
%
% Syntax
%   removeco2();
%   modified = removeco2();
%
% Description
%   removeco2() removes the CO2 region of the spectrum delimited by 2250
%   and 2450 wavenumbers. This version modifies the original object.
%
%   modified = removeco2() first creates a clone of the object, then
%   removes the CO2 region of the spectrum from the clone. The original
%   object is not modified.
%
% Copyright (c) 2017-2019, Alex Henderson.
% Licenced under the GNU General Public License (GPL) version 3.
%
% See also 
%   removewax removediamond removerange ChiIRSpectrum.

% Contact email: alex.henderson@manchester.ac.uk
% Licenced under the GNU General Public License (GPL) version 3
% http://www.gnu.org/copyleft/gpl.html
% Other licensing options are available, please contact Alex for details
% If you use this file in your work, please acknowledge the author(s) in
% your publications. 

% The latest version of this file is available at:
% https://github.com/AlexHenderson/ChiToolbox


    this = varargin{1};

    if nargout
        obj = this.clone();
        command = [mfilename, '(obj,varargin{2:end});'];
        eval(command);  
    else
        this.removerange(2250,2450);
        message = 'CO2 region removed';
        this.history.add(message);
    end


end % function removeco2
