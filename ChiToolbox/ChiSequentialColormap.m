function [cmap,previouscolormap,scheme] = ChiSequentialColormap(varargin)

% ChiSequentialColormap  Produces a colormap generated using Cynthia Brewer's colormap generator
%
% Syntax
%   [cmap,previouscolormap,scheme] = ChiSequentialColormap();
%   [____] = ChiSequentialColormap(____, numlevels);
%   [____] = ChiSequentialColormap(____, colourscheme);
%   [____] = ChiSequentialColormap(____, 'reverse');
%   [____] = ChiSequentialColormap(____, 'view');
%
% Description
%   [cmap,previouscolormap,scheme] = ChiSequentialColormap() exposes Cynthia 
%   Brewer's colormaps using 'Blues' with 256 levels (white to blue) as a
%   default. The current colormap is returned in previouscolormap. The name
%   of the selected colormap is returned in scheme. 
% 
%   [____] = ChiSequentialColormap(____, numlevels) produces a colormap
%   with numlevels steps.
%
%   [____] = ChiSequentialColormap(____, colourscheme) uses Cynthia
%   Brewer's colormap specified by colourscheme. 
% 
%   [____] = ChiSequentialColormap(____, 'reverse') changes the direction
%   of the colormap. By default the colormap is not reversed. 
% 
%   [____] = ChiSequentialColormap(____, 'view') opens a figure to show all
%   possible colour spaces. When the window is closed, cmap,
%   previouscolormap and scheme contain the selected options.
% 
% Notes
%   Cynthia Brewer's website http://colorbrewer2.org/ is a tremendous
%   resource for developing appropriate colour spaces that can be
%   configured to be colourblind safe, print friendly and photocopy safe. 
% 
% Copyright (c) 2020, Alex Henderson.
% Licenced under the GNU General Public License (GPL) version 3.
%
% See also 
%   colormap brewermap brewermap_view.

% Contact email: alex.henderson@manchester.ac.uk
% Licenced under the GNU General Public License (GPL) version 3
% http://www.gnu.org/copyleft/gpl.html
% Other licensing options are available, please contact Alex for details
% If you use this file in your work, please acknowledge the author(s) in
% your publications. 

% The latest version of this file is available at:
% https://github.com/AlexHenderson/ChiToolbox


%% Defaults
levels = 256;
scheme = 'Blues';
reverse = '';   % Not reversed, '*' means reversed

%% Parse command line to see if we're in interactive mode
if nargin
    % Check for 'view' first since this is a different way of operating
    % this function
    argposition = find(cellfun(@(x) strcmpi(x, 'view') , varargin));
    if argposition
        previouscolormap = colormap;
        [cmap,scheme] = brewermap_view();
        return
    end
end

%% If not interactive mode, parse command line again
if nargin
    % Next check for reverse text since this is a string that is not a
    % colour space
    argposition = find(cellfun(@(x) strcmpi(x, 'reverse') , varargin));
    if argposition
        reverse = '*';  % reverse is true
        varargin(argposition) = [];
    end

    % Any numeric value should be the number of levels
    argposition = find(cellfun(@(x) isnumeric(x) , varargin));
    if argposition
        levels = varargin{argposition};
        varargin(argposition) = [];
    end
    
    % At this point the first string left in the argument list should be a
    % colour space
    if ~isempty(varargin)
        if ~ischar(varargin{1})
            err = MException(['CHI:',mfilename,':InputError'], ...
                'The colour scheme appears to be missing.');
            throw(err);
        else
            scheme = varargin{1};
            varargin(1) = [];
        end
    end

    % If the user provided a reverse colormap, remove the asterisk to check
    % the colormap exists, then flag it to be reversed later. 
    if (scheme(1) == '*')
        scheme = scheme(2:end);
        reverse = '*';
    end
    
    % Check that the colour scheme is one offered by Cindy Brewer
    schemes = brewermap('list');
    schemeindex = find(ismember(lower(schemes), lower(scheme)), 1);
    if isempty(schemeindex)
        err = MException(['CHI:',mfilename,':InputError'], ...
            'Colour scheme not recognised. \nTo see the options try: \n[cmap,previouscolormap,scheme] = ChiSequentialColormap(''view'');');
        throw(err);
    end
    
    if ~isempty(varargin)
        err = MException(['CHI:',mfilename,':InputError'], ...
            'Some parameters were not interpreted.');
        throw(err);
    end
end

%% Produce the colormap
previouscolormap = colormap;
cmap = colormap(brewermap(levels,[reverse,scheme]));

end % function ChiSequentialColormap
