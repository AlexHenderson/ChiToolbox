function obj = rebin(varargin)

% rebin  Reduce spectral resolution. 
%
% Syntax
%   rebin();
%   rebin(xmode);
%   rebin(xmode,range);
%   rebin(xmode,range,sumormean);
%   rebin(xmode,range,sumormean,start);
%   rebin(xmode,range,sumormean,start,stop);
%   modified = rebin(____);
%
% Description
%   rebin(xmode,range,sumormean,start,stop) reduces the spectral resolution
%   of the data. Details of the parameters are below. This version modifies
%   the original object.
%
%   modified = rebin(____) first creates a clone of the object, then
%   reduces the spectral resolution. The original object is not modified.
% 
% Notes
%   The purpose of this function is to spread the data across a different
%   number of channels.
% 
%   The variable 'xmode' indicates which mode to operate in. If xmode ==
%   'mass' we spread nonlinear time channels across linear mass channels.
%   If xmode == 'time' we combine adjacent channels. The default is 'mass'.
% 
%   range: for xmode == 'mass' this is the new binwidth (2 * +/- halfwidth). 
%       The default is 1 amu, ie. (mass_value - 0.5) -> (mass_value + 0.5)
%       For xmode == 'time' this is the number of channels to combine. The
%       default is 2, ie. combine pairs of channels. 
% 
%   func:  either 'sum' or 'mean'. Determines how to combine the existing
%          channels. The default is 'sum'
% 
%   start: defines the beginning of the x-axis. The default == 0. 
%           This parameter has no effect when xmode == 'time'
% 
%   stop: defines the upper limit of the x-axis. The default is the last
%          value in the x-axis. 
%          This parameter has no effect when xmode == 'time'
%
% Caution
%   Currently, if the data is a time-of-flight data set, and xmode is
%   'mass' (the default), the output is still a time-of-flight mass
%   spectral data set. In fact is should be a mass spectral data set. This
%   has no knock-on effects at the moment and is being looked into.
%
% Copyright (c) 2013-2018, Alex Henderson.
% Licenced under the GNU General Public License (GPL) version 3.
%
% See also 
%   keeprange removerange ChiMassSpectrum

% Contact email: alex.henderson@manchester.ac.uk
% Licenced under the GNU General Public License (GPL) version 3
% http://www.gnu.org/copyleft/gpl.html
% Other licensing options are available, please contact Alex for details
% If you use this file in your work, please acknowledge the author(s) in
% your publications. 

% The latest version of this file is available on Bitbucket
% https://bitbucket.org/AlexHenderson/chitoolbox

%   version 1.0 June 2013
%   version 2.0 August 2018


% Just a wrapper around utilities.binspectra

    this = varargin{1};

    if nargout
        obj = this.clone();
        % Not a great approach, but quite generic. 
        % Prevents errors if the function name changes. 
        command = ['utilities.', mfilename, '(obj,varargin{2:end});'];
        eval(command);  
    else
        % We are expecting to modify this object in situ
        utilities.binspectra(varargin{:});
    end

end
