function obj = createmask(varargin)

% createmask  Generates a logical mask of the data at a given value.
%
% Syntax
%   createmask(value);
%   obj = createmask(value);
%
% Description
%   createmask(value) generates a logical mask of the data at the given
%   value. 
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

% The latest version of this file is available on Bitbucket
% https://bitbucket.org/AlexHenderson/chitoolbox


    if (nargin ~= 2)
        err = MException(['CHI:',mfilename,':IOError'], ...
            'Value is missing');
        throw(err);
    end

    this = varargin{1};
    value = varargin{2};

    if (length(value) ~= this.numchannels)
        err = MException(['CHI:',mfilename,':IOError'], ...
            'Value is the wrong length');
        throw(err);
    else
        % Assume we have a sensible value
    end

    % Need to store the image dimensions since we're about to reshape the
    % data and the x-/y-pixels are dynamically calculated. 
    x = this.xpixels;
    y = this.ypixels;
    
    this.data = reshape(this.data,y*x,[]);
    
    % Get the masked pixels
    mask = ismember(this.data,value,'rows');
    
    % Reshape the data back
    this.data = reshape(this.data,y,x,[]);
    mask = reshape(mask,y,x);
    
    % Build a ChiMask object
    obj = ChiMask(mask);
    
    % Log what happened. 
    message = ['createmask using [', num2str(value(1))];
    for i = 2:length(value)
        message = [message, ',', num2str(value(i))]; %#ok<AGROW>
    end
        message = [message, ']'];
    this.history.add(message);

end
