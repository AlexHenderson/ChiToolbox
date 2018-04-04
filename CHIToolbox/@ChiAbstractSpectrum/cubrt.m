function obj = cubrt(this)

% cubrt  Takes the cube root of the data.
%
% Syntax
%   cubrt();
%   obj = cubrt();
%
% Description
%   cubrt() takes the cube root of the data.
% 
%   obj = cubrt() clones the object before taking the cube root. 
%
% Copyright (c) 2018, Alex Henderson.
% Licenced under the GNU General Public License (GPL) version 3.
%
% See also 
%   sqrt nthroot.

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
    command = ['obj.', mfilename, '();'];
    eval(command);  
else
    % We are expecting to modified this object in situ
    this.data = nthroot(this.data,3);
    message = 'Cube root taken';
    this.history.add(message);
end

end
