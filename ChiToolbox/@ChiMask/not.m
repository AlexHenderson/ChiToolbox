function obj = not(this)
    
% not  Performs a logical NOT on the mask.
%
% Syntax
%   not();
%   obj = not();
%
% Description
%   not() performs a logical NOT on the mask in-situ.
% 
%   obj = not() clones the object before NOTing the mask. The
%   original ChiMask is untouched.
%
% Copyright (c) 2019, Alex Henderson.
% Licenced under the GNU General Public License (GPL) version 3.
%
% See also 
%   and or.

% Contact email: alex.henderson@manchester.ac.uk
% Licenced under the GNU General Public License (GPL) version 3
% http://www.gnu.org/copyleft/gpl.html
% Other licensing options are available, please contact Alex for details
% If you use this file in your work, please acknowledge the author(s) in
% your publications. 

% The latest version of this file is available at:
% https://github.com/AlexHenderson/ChiToolbox


    if (nargin ~= 1)
        err = MException(['CHI:',mfilename,':IOError'], ...
            'Too many arguments.');
        throw(err);
    end
    
    if nargout
        obj = this.clone();
        command = [mfilename, '(obj);'];
        eval(command);  
    else
        this.mask = ~this.mask;
        message = 'Got NOTed';
        this.history.add(message);
end
    
end
