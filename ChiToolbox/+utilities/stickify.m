function [stickx, sticky] = stickify(x,y,varargin)

% stickify  Generate sticks from data
%
% Syntax
%   [stickx,sticky] = stickify(x,y);
%   [stickx,sticky] = stickify(x,y,yvalue);
%
% Description
%   [stickx,sticky] = stickify(x,y) adds new points to the data that have
%   zero intensity and x-axis positions a very small amount below and above
%   the original data. This allows for the data to be plotted as though the
%   data points were rising from a zero baseline.
% 
%   [stickx,sticky] = stickify(x,y,yvalue) uses yvalue for the inserted y
%   values instead of zero. 
% 
% Copyright (c) 2005-2019, Alex Henderson.
% Licenced under the GNU General Public License (GPL) version 3.
%
% See also 
%   plot eps.

% Contact email: alex.henderson@manchester.ac.uk
% Licenced under the GNU General Public License (GPL) version 3
% http://www.gnu.org/copyleft/gpl.html
% Other licensing options are available, please contact Alex for details
% If you use this file in your work, please acknowledge the author(s) in
% your publications. 

% The latest version of this file is available on Bitbucket
% https://bitbucket.org/AlexHenderson/chitoolbox


%% Force x and y to be in columns so we can use sortrows later
[x,xtransposed] = utilities.force2col(x);
numpts = length(x);

[rows,cols] = size(y);
ytransposed = false;
if rows == cols
    % y is square, so assume y is in rows and transpose
    y = y';
    ytransposed = true;
    utilities.warningnobacktrace('Assuming data is in rows');    
else
    if numpts == cols
        % Data is in rows, so transpose
        y = y';
        ytransposed = true;
    end
    % Otherwise it is already in columns, so leave it alone
end

%% Put x and y together and make space for the added/subtracted positions
data = horzcat(x,y);

% If we have a preferred yvalue, use it here
if (nargin == 3)
    lower = ones(size(data)) * varargin{1};
    upper = ones(size(data)) * varargin{1};
else
    lower = zeros(size(data));
    upper = zeros(size(data));
end

%% Determine the minimum amount we can add/subtract from an x-position
delta = eps(max(x));

%% Create a collection of x positions above and below the real ones
lower(:,1) = data(:,1) - delta;
upper(:,1) = data(:,1) + delta;

%% Put the new positions and original data together
data = vertcat(lower,data,upper);
data = sortrows(data,1);

%% Export the results
stickx = data(:,1);
sticky = data(:,2:end);

if xtransposed
    stickx = stickx';
end
if ytransposed
    sticky = sticky';
end

%% Done
end % function
