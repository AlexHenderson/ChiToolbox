function varargout = display(varargin) %#ok<DISPLAY>

% display  Generates an image of the data
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
%   disp imagesc colormap ChiContinuousColormap.

% Contact email: alex.henderson@manchester.ac.uk
% Licenced under the GNU General Public License (GPL) version 3
% http://www.gnu.org/copyleft/gpl.html
% Other licensing options are available, please contact Alex for details
% If you use this file in your work, please acknowledge the author(s) in
% your publications. 

% The latest version of this file is available on Bitbucket
% https://bitbucket.org/AlexHenderson/chitoolbox


this = varargin{1};
if isempty(this.data)
    err = MException(['CHI:',mfilename,':DisplayError'], ...
        'No data to display.');
    throw(err);
end

%  Do not create a figure since this will be done in ChiPicture.display()
%     % Do we need a new figure?
%     argposition = find(cellfun(@(x) strcmpi(x, 'nofig') , varargin));
%     if argposition
%         % Remove the parameter from the argument list
%         varargin(argposition) = [];
%     else
%         % No 'nofig' found so create a new figure
%         figure;
%     end
    
    % Do we want to add a title?
    titletext = '';
    argposition = find(cellfun(@(x) strcmpi(x, 'title') , varargin));
    if argposition
        titletext = varargin{argposition+1};
        % Remove the parameters from the argument list
        varargin(argposition+1) = [];
        varargin(argposition) = [];
    end

    % Generate the image
    imagesc(this.totalimage(),varargin{2:end});
    axis image;
    axis off;

    % Use a colour vision deficiency aware colormap
    if exist('parula.m','file')
        colormap(parula);
    else
        colormap(ChiContinuousColormap());
    end
    
    % Add a title if requested
    if ~isempty(titletext)
        title(titletext)
    end
    
    % Has the user asked for the figure handle?
    if nargout
        varargout{1} = gcf();
    end
    
end
