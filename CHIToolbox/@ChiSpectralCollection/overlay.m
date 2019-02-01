function overlay(varargin)

% overlay  Produces a plot with overlaid data.
%
% Syntax
%   overlay(other);
%   overlay(other,parameters);
%
% Description
%   overlay(other) creates a plot of this data with data from other
%   overlaid. other can be any Chi data type. 
% 
%   overlay(other,parameters) allows the user to customise the output plot
%   using standard plotting options.
% 
% Copyright (c) 2019, Alex Henderson.
% Licenced under the GNU General Public License (GPL) version 3.
%
% See also 
%   plot legend

% Contact email: alex.henderson@manchester.ac.uk
% Licenced under the GNU General Public License (GPL) version 3
% http://www.gnu.org/copyleft/gpl.html
% Other licensing options are available, please contact Alex for details
% If you use this file in your work, please acknowledge the author(s) in
% your publications. 

% The latest version of this file is available on Bitbucket
% https://bitbucket.org/AlexHenderson/chitoolbox


this = varargin{1};
that = varargin{2};

this.plot();
hold on;
that.plot('nofig',varargin{3:end});

if ~strcmpi(class(this),class(that))
    utilities.warningnobacktrace('These data sets may be incompatible.')
end

if ~strcmpi(this.xlabel,that.xlabel)
    utilities.warningnobacktrace('The x-axes of these data sets may not match.')
end
if ~strcmpi(this.ylabel,that.ylabel)
    utilities.warningnobacktrace('The y-axes of these data sets may not match.')
end


end % function overlay
