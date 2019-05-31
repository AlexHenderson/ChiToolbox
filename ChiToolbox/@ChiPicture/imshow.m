function varargout = imshow(varargin)

% imshow  Displays the image
%
% Syntax
%   imshow();
%   imshow('nofig');
%   imshow(____,'axes',desiredaxes);
%   imshow(____,'title',titletext);
%   handle = imshow(____);
%
% Description
%   imshow() displays the image in a figure window.
% 
%   imshow('nofig') displays the image in the currently active figure
%   window, or creates a new figure if none is available.
%
%   imshow(____,'axes',desiredaxes) displays the image in the desiredaxes.
%   Defaults to gca.
% 
%   imshow(____,'title',titletext) displays titletext as an image title.
% 
%   handle = imshow(____) returns a handle to this figure.
% 
%   Other parameters can be applied to customise the image. See the MATLAB
%   imshow function for more details. 
% 
% Copyright (c) 2019, Alex Henderson.
% Licenced under the GNU General Public License (GPL) version 3.
%
% See also 
%   display imagesc gca.

% Contact email: alex.henderson@manchester.ac.uk
% Licenced under the GNU General Public License (GPL) version 3
% http://www.gnu.org/copyleft/gpl.html
% Other licensing options are available, please contact Alex for details
% If you use this file in your work, please acknowledge the author(s) in
% your publications. 

% The latest version of this file is available on Bitbucket
% https://bitbucket.org/AlexHenderson/chitoolbox


%% Error checking
this = varargin{1};
if isempty(this.data)
    err = MException(['CHI:',mfilename,':DisplayError'], ...
        'No data to display.');
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

%% Get required axes
argposition = find(cellfun(@(x) strcmpi(x, 'axes') , varargin));
if argposition
    % Remove the parameters from the argument list
    ax = varargin{argposition+1};
    varargin(argposition + 1) = [];
    varargin(argposition) = [];
else
    ax = gca;
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
imshow(ax,this.data,'InitialMagnification','fit',varargin{2:end});

%% Add a title if requested
if ~isempty(titletext)
    title(ax,titletext)
end

%% Has the user asked for the figure handle?
if nargout
    varargout{1} = gcf();
end
    
end        
