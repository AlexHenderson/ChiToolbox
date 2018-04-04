function obj = nthroot(this,level)

% nthroot  Reduces the data to the given root
%
% Syntax
%   nthroot(level);
%   obj = nthroot(level);
%
% Description
%   nthroot(level) reduces the data to the given root. 
% 
%   obj = nthroot(level) clones the object before reducing the data. 
%
% Copyright (c) 2018, Alex Henderson.
% Licenced under the GNU General Public License (GPL) version 3.
%
% See also 
%   nthroot.

% Contact email: alex.henderson@manchester.ac.uk
% Licenced under the GNU General Public License (GPL) version 3
% http://www.gnu.org/copyleft/gpl.html
% Other licensing options are available, please contact Alex for details
% If you use this file in your work, please acknowledge the author(s) in
% your publications. 

% Version 1.0, April 2018
% The latest version of this file is available on Bitbucket
% https://bitbucket.org/AlexHenderson/chitoolbox


if nargout
    obj = this.clone();
    % Not a great approach, but quite generic. Prevents errors if the
    % function name changes
    command = ['obj.', mfilename, '(level);'];
    eval(command);  
else
    % We are expecting to modified this object in situ
    this.data = nthroot(this.data,level);
    message = ['Reduce to root ', num2str(level)];
    this.history.add(message);
end

end
