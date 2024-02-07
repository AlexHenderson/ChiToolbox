function imwrite(varargin)

% imwrite  Creates an image file. 
%
% Syntax
%   imwrite();
%   imwrite(filename);
%   imwrite(____,'colormap',cmap);
%   imwrite(filename,Name,Value);
%
% Description
%   imwrite() writes the data to an image file. A filename is requested
%   from the user. The default colormap is viridis. 
%
%   imwrite(filename) writes the data to the filename supplied in filename.
% 
%   imwrite(____,'colormap',cmap) uses the colormap supplied in cmap. The
%   default colormap is viridis.
% 
%   imwrite(filename,Name,Value) accepts additional parameters. See MATLAB
%   help on imwrite for more details. Note that the filename must be
%   supplied for this option.
% 
%   File formats supported: PNG, JPEG, BMP, TIFF. 
% 
% Copyright (c) 2018, Alex Henderson.
% Licenced under the GNU General Public License (GPL) version 3.
%
% See also 
%   imwrite colormap viridis.

% Contact email: alex.henderson@manchester.ac.uk
% Licenced under the GNU General Public License (GPL) version 3
% http://www.gnu.org/copyleft/gpl.html
% Other licensing options are available, please contact Alex for details
% If you use this file in your work, please acknowledge the author(s) in
% your publications. 

% The latest version of this file is available at:
% https://github.com/AlexHenderson/ChiToolbox


this = varargin{1};

% Was a specific colormap requested?
% Managing some British English spellings too ;-)
argposition = find(cellfun(@(x) strcmpi(x, 'colormap') , varargin));
if argposition
    cmapname = lower(varargin{argposition + 1});
    if strcmp('grey',cmapname)
        cmapname = 'gray';
    end
    eval(['cmap = ', cmapname, '(256);']);
    varargin(argposition+1) = [];
    varargin(argposition) = [];
else
    argposition = find(cellfun(@(x) strcmpi(x, 'colourmap') , varargin));
    if argposition
        cmapname = lower(varargin{argposition + 1});
        if strcmp('grey',cmapname)
            cmapname = 'gray';
        end
        eval(['cmap = ', cmapname, '(256);']);
        varargin(argposition+1) = [];
        varargin(argposition) = [];
    else
        % Set colormap to the default - viridis
        cmap = ChiContinuousColormap(256);
    end
end

if (length(varargin) < 2)
    % No filename supplied, so ask the user
    filename = utilities.savefilename(vertcat(...
            {'*.png',           'PNG Image Files (*.png)'}, ...
            {'*.jpg;*.jpeg',    'JPEG Image Files (*.jpeg)'}, ...
            {'*.bmp',           'Bitmap Image Files (*.bmp)'}, ...
            {'*.tif;*.tiff',    'TIFF Image Files (*.tiff)'} ...
        ));

% 3-D data not supported for GIF files. Data must be 2-D or 4-D.    
%             {'*.gif',  'GIF Image Files (*.gif)'}, ...
    
    if (isfloat(filename) && (filename == 0))
        return;
    end
else
    filename = varargin{2};
end

% Need to scale the data to match the colormap
% https://uk.mathworks.com/matlabcentral/answers/340408-save-an-intensity-image-created-with-imagesc-with-true-resolution
imwrite(ind2rgb(im2uint8(mat2gray(this.data)),cmap),filename,varargin{3:end});
