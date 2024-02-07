function obj = full(varargin)

% full  Makes the data full.
%
% Syntax
%   full();
%   obj = full();
%
% Description
%   full() makes the data full (a dense matrix).
% 
%   obj = full() clones the object before making the data full. 
%
% Copyright (c) 2018, Alex Henderson.
% Licenced under the GNU General Public License (GPL) version 3.
%
% See also 
%   full sparse.

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
    % Not a great approach, but quite generic. 
    % Prevents errors if the function name changes. 
    command = [mfilename, '(obj,varargin{2:end});'];
    eval(command);  
else
    try
        this.data = full(this.data);
        message = 'Data made full';
        this.history.add(message);
    catch ex
        if (strcmp(ex.identifier,'MATLAB:array:SizeLimitExceeded'))
            disp('Not enough memory available to make data full.');
            disp('Try truncating the spectra (eg. keeprange) to reduce the number of channels.')
        end
        rethrow(ex);
    end
        
end

end
