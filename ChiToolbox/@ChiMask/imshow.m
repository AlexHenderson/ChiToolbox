function varargout = imshow(varargin)

% imshow  Generates an image of the mask (for 2D data)
%
% Syntax
%   imshow();
%   imshow(Name,Value);
%   handle = imshow(____);
%
% Description
%   imshow() displays the mask as an image. 
% 
%   imshow(Name,Value) applies the Name/Value pairs to the image. See the
%   help for MATLAB's help on imshow for more details. 
%
%   handle = imshow(____) returns a handle to this figure.
% 
% Notes
%   This function only applies to 2D masks. 
% 
% Copyright (c) 2019, Alex Henderson.
% Licenced under the GNU General Public License (GPL) version 3.
%
% See also 
%   imshow.

% Contact email: alex.henderson@manchester.ac.uk
% Licenced under the GNU General Public License (GPL) version 3
% http://www.gnu.org/copyleft/gpl.html
% Other licensing options are available, please contact Alex for details
% If you use this file in your work, please acknowledge the author(s) in
% your publications. 

% The latest version of this file is available at:
% https://github.com/AlexHenderson/ChiToolbox


%% Error checking
this = varargin{1};
if isempty(this.data)
    err = MException(['CHI:',mfilename,':DisplayError'], ...
        'No data to display.');
    throw(err);
end

if (this.dims ~= 2)
    err = MException(['CHI:',mfilename,':DisplayError'], ...
        'This mask is not a 2D image.');
    throw(err);
end

%% Do we need a new figure?
argposition = find(cellfun(@(x) strcmpi(x, 'nofig') , varargin));
if argposition
    % Remove the parameter from the argument list
    varargin(argposition) = [];
else
    % No 'nofig' found so create a new figure
    figure;
end

%% Do we want to add a title?
titletext = '';
argposition = find(cellfun(@(x) strcmpi(x, 'title') , varargin));
if argposition
    titletext = varargin{argposition+1};
    % Remove the parameters from the argument list
    varargin(argposition+1) = [];
    varargin(argposition) = [];
end

%% Generate the image
imshow(this.asimage(),'InitialMagnification','fit',varargin{2:end});

%% Add a title if requested
if ~isempty(titletext)
    title(titletext)
end

%% Has the user asked for the figure handle?
if nargout
    varargout{1} = gcf();
end
    
end        
