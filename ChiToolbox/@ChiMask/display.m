function varargout = display(varargin) %#ok<DISPLAY>

% display  Generates an image of the data, or a list of parameters, as appropriate
%
% Syntax
%   display();
%   display('nofig');
%   display(____,'title',titletext);
%   handle = display(____);
%
% Description
%   display() generates an image of the data.
% 
%   display('nofig') shows the image in the currently active figure window,
%   or creates a new figure if none is available.
%
%   display(____,'title',titletext) displays titletext as a plot title.
% 
%   handle = display(____) returns a handle to the figure.
%
% Copyright (c) 2019, Alex Henderson.
% Licenced under the GNU General Public License (GPL) version 3.
%
% See also 
%   disp imshow.

% Contact email: alex.henderson@manchester.ac.uk
% Licenced under the GNU General Public License (GPL) version 3
% http://www.gnu.org/copyleft/gpl.html
% Other licensing options are available, please contact Alex for details
% If you use this file in your work, please acknowledge the author(s) in
% your publications. 

% The latest version of this file is available at:
% https://github.com/AlexHenderson/ChiToolbox


this = varargin{1};
if isempty(this.data)
    err = MException(['CHI:',mfilename,':DisplayError'], ...
        'No data to display.');
    throw(err);
end

if (this.dims == 2)
    if nargout
        varargout{:} = this.imshow(varargin{2:end});
    else
        this.imshow(varargin{2:end});
    end
else
    disp(this)
end

end
