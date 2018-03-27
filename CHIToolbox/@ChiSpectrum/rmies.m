function obj = rmies(this,varargin)

% rmies  Resonant Mie scattering correction for infrared spectroscopy
%
% Syntax
%   rmies();
%   rmies(____,options);
%   rmies(____,reference);
%   rmies(options,reference);
%
% Description
%   rmies() performs a resonant Mie scattering correction on the data.
%   Default values for the various options and the internal Matrigel
%   reference are used. 
% 
%   rmies(____,options) perform the correction using the provided options.
%   options is a rmiesoptions object. 
% 
%   rmies(____,reference) uses the provided reference spectrum. reference
%   is a ChiSpectrum. 
% 
% Version 5 of the RMieS algorithm used is available from
% https://github.com/GardnerLabUoM/RMieS. 
%
% Caution
%   Using a single iteration, each spectrum utilises the same reference
%   spectrum. For subsequent iterations each spectrum utilises its previous
%   iteration as a starting point. This means multiple iterations will take
%   a (*very*) long time to complete for many spectra. Therefore it may be
%   prudent to explore the time taken with a small number of spectra and
%   iterations before moving to larger datasets. 
%
% Copyright (c) 2018, Alex Henderson.
% Licenced under the GNU General Public License (GPL) version 3.
%
% See also 
%   RMieS_EMSC_v5, rmiesoptions.

% Contact email: alex.henderson@manchester.ac.uk
% Licenced under the GNU General Public License (GPL) version 3
% http://www.gnu.org/copyleft/gpl.html
% Other licensing options are available, please contact Alex for details
% If you use this file in your work, please acknowledge the author(s) in
% your publications. 

% Version 1.0, March 2018
% The latest version of this file is available on Bitbucket
% https://bitbucket.org/AlexHenderson/chitoolbox


if nargout
    obj = this.clone();
    obj.rmies(varargin{:});
else
    utilities.rmies(this,varargin{:});
end
