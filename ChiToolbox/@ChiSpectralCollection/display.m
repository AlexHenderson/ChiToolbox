function varargout = display(varargin) %#ok<DISPLAY>

% display  Plots one, or more, spectra. Multiple spectra are overlaid. 
%
% Syntax
%   display();
%   display('nofig');
%   display(____,'title',titletext);
%   handle = display(____);
%
% Description
%   display() creates a 2-D line plot of the data in a new figure window.
%
%   display('nofig') plots the data in the currently active figure
%   window, or creates a new figure if none is available.
% 
%   display(____,'title',titletext) displays titletext as a plot title.
% 
%   handle = display(____) returns a handle to the figure.
%
%   Other parameters can be applied to customise the plot. See the MATLAB
%   plot function for more details. 
%
% Copyright (c) 2017-2023, Alex Henderson.
% Licenced under the GNU General Public License (GPL) version 3.
%
% See also 
%   plot ChiSpectrum ChiSpectralCollection.

% Contact email: alex.henderson@manchester.ac.uk
% Licenced under the GNU General Public License (GPL) version 3
% http://www.gnu.org/copyleft/gpl.html
% Other licensing options are available, please contact Alex for details
% If you use this file in your work, please acknowledge the author(s) in
% your publications. 

% The latest version of this file is available at:
% https://github.com/AlexHenderson/ChiToolbox

% Passing the actual plotting functionality off to a separate function to
% co-locate the feature. 


this = varargin{1};
if isempty(this.data)
    err = MException(['CHI:',mfilename,':DisplayError'], ...
        'No data to display.');
    throw(err);
end

    % Do we want to add a title?
    titletext = '';
    argposition = find(cellfun(@(x) strcmpi(x, 'title') , varargin));
    if argposition
        titletext = varargin{argposition+1};
        % Remove the parameters from the argument list
        varargin(argposition+1) = [];
        varargin(argposition) = [];
    end
    
    % Generate the plot
    this.plot(varargin{2:end});
    
    % Add a title if requested
    if ~isempty(titletext)
        title(titletext)
    end
    
    % Has the user asked for the figure handle?
    if nargout
        varargout{1} = gcf();
    end
   
end
