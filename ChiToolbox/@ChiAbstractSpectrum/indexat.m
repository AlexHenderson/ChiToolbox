function idx = indexat(this, varargin)

% indexat  Finds closest index number in xvals requested xvalue. 
%
% Syntax
%   idx = indexat(xvalue);
%   idx = indexat(xvalue,'higherthan');
%   idx = indexat(xvalue,'lowerthan');
%
% Description
%   idx = indexat(xvalue) identifies the index position in the xvals array
%   that is the closest, in xvals units, to the requested xvalue. If
%   xvalue is a list of values, idx is the corresonding list of closest
%   positions.
%   
%   idx = indexat(xvalue,'higherthan') identifies the closest index
%   position that is higher than the requested xvalue.
%
%   idx = indexat(xvalue,'lowerthan') identifies the closest index
%   position that is lower than the requested xvalue.
%
% Copyright (c) 2017, Alex Henderson.
% Licenced under the GNU General Public License (GPL) version 3.
%
% See also 
%   keeprange removerange ChiSpectrum.

% Contact email: alex.henderson@manchester.ac.uk
% Licenced under the GNU General Public License (GPL) version 3
% http://www.gnu.org/copyleft/gpl.html
% Other licensing options are available, please contact Alex for details
% If you use this file in your work, please acknowledge the author(s) in
% your publications. 

% Version 1.0, July 2017
% The latest version of this file is available on Bitbucket
% https://bitbucket.org/AlexHenderson/chitoolbox


higherThan = false;
lowerThan = false;

argposition = find(cellfun(@(x) strcmpi(x, 'higherThan') , varargin));
if argposition
    % Remove the parameter from the argument list
    varargin(argposition) = [];
    higherThan = true;
end

argposition = find(cellfun(@(x) strcmpi(x, 'lowerThan') , varargin));
if argposition
    % Remove the parameter from the argument list
    varargin(argposition) = [];
    lowerThan = true;
end

if (higherThan && lowerThan)
    err = MException('CHI:ChiAbstractSpectrum:IOError', ...
        'Cannot determine both higher and lower values simultaneously. Select ''higherthan'' or ''lowerthan''.');
    throw(err);
end    

xvalues = cell2mat(varargin);

idx = zeros(size(xvalues));
for i = 1:length(xvalues)
    [dummy,idx(i)] = min(abs(this.xvals - xvalues(i))); %#ok<ASGLU>
    if higherThan
        if ((this.xvals(idx(i)) - xvalues(i)) < 0)
            % The next idx value is higher than the requested xvalue
            idx(i) = idx(i) + 1;
        end
    end
    if lowerThan
        if ((this.xvals(idx(i)) - xvalues(i)) > 0)
            % The previous idx value is lower than the requested xvalue
            idx(i) = idx(i) - 1;
        end
    end
end
    
end
