function [cmap,previouscolormap] = ChiSequentialColormap(varargin)

% ChiSequentialColormap  Produces a colormap generated using Cynthia Brewer's colormap generator
%
% Syntax
%   [cmap,previouscolormap] = ChiSequentialColormap();
%   [____] = ChiSequentialColormap(____, numlevels);
%   [____] = ChiSequentialColormap(____, colourscheme);
%   [____] = ChiSequentialColormap(____, 'reverse');
%
% Description
%   [cmap,previouscolormap] = ChiSequentialColormap() develops a colormap in
%   cmap that runs from magenta through black to green with 256 levels
%   and where each is the cube root of the linear value (rootvalue == 3).
%   previouscolormap is the previous colormap :-)
% 
%   [____] = ChiSequentialColormap(____, 'levels',numlevels) produces a
%   colormap with numlevels.
%
%   [____] = ChiSequentialColormap(____, 'root',rootvalue) uses rootvalue to
%   determine the nth root.
% 
% Notes
%   Initially a colormap is produced where there is a linear drop in
%   magenta, from 1 to 0 at the halfway point, whereupon it continues at 0.
%   Green is initially 0 until the halfway point then it increases linearly
%   to 1. Example: 
%     figure; plot(ChiSequentialColormap('root',1)); axis tight
%   
%   For principal components analysis, the main usage of a bimodal
%   colormap, many of the values are around the midpoint. Therefore, the
%   images appears very dark. Here we use the cube root of the colormap to
%   reduce the darkness of the values near the midpoint and therefore
%   enhance the differences in the data. Now there is no longer a linear
%   relationship between colour and intensity (principal component score),
%   but the images are more easily visualised. Example:
%     figure; plot(ChiSequentialColormap()); axis tight
% 
%   The choice of magenta and green is to assist those users with red/green
%   colour visual deficiency, sometimes called colour blindness. 
% 
% Copyright (c) 2014-2019, Alex Henderson.
% Licenced under the GNU General Public License (GPL) version 3.
%
% See also 
%   colormap nthroot.

% Contact email: alex.henderson@manchester.ac.uk
% Licenced under the GNU General Public License (GPL) version 3
% http://www.gnu.org/copyleft/gpl.html
% Other licensing options are available, please contact Alex for details
% If you use this file in your work, please acknowledge the author(s) in
% your publications. 

% The latest version of this file is available on Bitbucket
% https://bitbucket.org/AlexHenderson/chitoolbox


%% Defaults
levels = 256;
scheme = 'Blues';
reverse = '';   % Not reversed, '*' means reversed

%% Parse command line
if nargin
    % Check for reverse text first since this is a string that is not a
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

    % Check that the colour scheme is one oferred by Cindy Brewer
    schemes = brewermap('list');
    schemeindex = find(ismember(lower(schemes), lower(scheme)));
    if isempty(schemeindex)
        err = MException(['CHI:',mfilename,':InputError'], ...
            'Colour scheme not recognised.');
        throw(err);
    end
        
    if ~isempty(varargin)
        err = MException(['CHI:',mfilename,':InputError'], ...
            'Some parameters wer not interpreted.');
        throw(err);
    end
end

%% Produce the colormap
previouscolormap = colormap;
cmap = colormap(brewermap(levels,[reverse,scheme]));

end % function ChiSequentialColormap
