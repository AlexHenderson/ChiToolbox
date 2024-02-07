function obj = createmask(varargin)

% createmask  Generates a logical mask of the data at a given value.
%
% Syntax
%   createmask(value);
%   obj = createmask(value);
%
% Description
%   createmask(value) generates a logical mask of the data at the given
%   value. value can be a ChiSpectrum, or a vector of values of the same
%   length as a spectrum in the collection. 
% 
%   obj = createmask() clones the object before generating the mask. 
%
% Copyright (c) 2019, Alex Henderson.
% Licenced under the GNU General Public License (GPL) version 3.
%
% See also 
%   ChiMask.

% Contact email: alex.henderson@manchester.ac.uk
% Licenced under the GNU General Public License (GPL) version 3
% http://www.gnu.org/copyleft/gpl.html
% Other licensing options are available, please contact Alex for details
% If you use this file in your work, please acknowledge the author(s) in
% your publications. 

% The latest version of this file is available at:
% https://github.com/AlexHenderson/ChiToolbox


    if (nargin ~= 2)
        err = MException(['CHI:',mfilename,':IOError'], ...
            'Value is missing');
        throw(err);
    end

    this = varargin{1};
    value = varargin{2};

    valueisspectrum = false;
    if isa(value,'ChiSpectrum')
        valuedata = value.data;
        valueisspectrum = true;
    else
        valuedata = value;        
    end
    
    if (length(valuedata) ~= this.numchannels)
        err = MException(['CHI:',mfilename,':IOError'], ...
            'Value is the wrong length');
        throw(err);
    else
        % Assume we have a sensible value
    end

    mask = ismember(this.data,valuedata,'rows');
    obj = ChiMask(mask);

    % Log the process
    if valueisspectrum
        message = 'createmask from spectrum';
        if ~isempty(value.filenames)
            message = [message, ' (', value.filenames{1}, ')'];
        end
    else
        message = 'createmask';
    end
    this.history.add(message);

end
