function [registered,transform] = registerto(this,that,varargin)
    
% registerto  Performs image registration using spatial referencing.
%
% Syntax
%   [registered,transform] = registerto(target);
%   [registered,transform] = registerto(target,inittransform);
%   [registered,transform] = registerto(____,'vis');
%
% Description
%   [registered,transform] = registerto(target) opens a spatial transform
%   interface window, allowing the user to select control points on each of
%   the source and target images. target is a ChiImage, or ChiPicture. If
%   target is a ChiImage, the total intensity image is used to generate the
%   target image.
%   The registered, cropped and resampled image is returned in the
%   registered variable as a ChiPicture. A ChiImageTransform object is
%   returned in transform. This transform variable can be passed to this
%   function again to allow for additional control points to be added.
% 
%   [registered,transform] = registerto(target,inittransform) initialises
%   the spatial transform interface window, using the provided
%   inittransform.
%
%   [registered,transform] = registerto(____,'vis') displays the registered
%   image, cropped and resampled to match the target. It also displays the
%   registered image at its original resolution without cropping. 
%
% Notes
%   This function uses the cpselect tool in the Image Processing Toolbox.
%   Users can select points of correspondence in both the static target
%   image (right) and the source image to be registered (left).
% 
%   The function performs an affine projection, using the user-selected
%   points of correspondence. The registered image will be a
%   rotated/skewed/translated/cropped version of the source image.
% 
%   The target image is scaled in intensity to reduce the influence of
%   outliers. Neither the target object nor source image are modified. 
% 
%   The registered image will have the spatial resolution of the source
%   image reduced to that of the target image. If you wish to preserve the
%   full spatial resolution of the source image, try interpolating the
%   target image to match the spatial resolution of the source image first.
% 
%   This function expects the source image to have higher spatial
%   resolution than the target image.
% 
% Copyright (c) 2013-2019, Alex Henderson.
% Licenced under the GNU General Public License (GPL) version 3.
%
% See also 
%   cpselect.

% Contact email: alex.henderson@manchester.ac.uk
% Licenced under the GNU General Public License (GPL) version 3
% http://www.gnu.org/copyleft/gpl.html
% Other licensing options are available, please contact Alex for details
% If you use this file in your work, please acknowledge the author(s) in
% your publications. 

% The latest version of this file is available on Bitbucket
% https://bitbucket.org/AlexHenderson/chitoolbox
    
%   version 1.0 July 2013
%   version 2.0 October 2019. Added to ChiToolbox


%% Do we have the image processing toolbox
if ~exist('cpselect','file')
    err = MException(['CHI:',mfilename,':InputError'], ...
        'The Image Processing Toolbox is required for this function.');
    throw(err);
end

%% Do we want visual output?
vis = false;
argposition = find(cellfun(@(x) strcmpi(x, 'vis') , varargin));
if argposition
    vis = true;
    varargin(argposition) = [];
end

%% Convert a hyperspectral image to a ChiPicture
if isa(that, 'ChiImage')
    that = that.totalimage;
end

%% Scale variance to omit outliers
that.data = utilities.scaleimage(that.data);

% Get some limits for scaling
themax = max(max(max(that.data)));
themin = min(min(min(that.data)));

% scale between 0 and 1
that.data = (that.data-themin)/(themax-themin);
%figure;imshow(ftirimage);

%% Collect control points
if ~isempty(varargin) 
    if isa(varargin{1},'ChiImageTransform')
        inputtransform = varargin{1}.clone;
        [movingcontrolpoints,staticcontrolpoints] = cpselect(this.data,that.data,inputtransform.movingcontrolpoints,inputtransform.staticcontrolpoints,'Wait',true);
    else
        error('Not a ChiImageTransform')
    end        
else
    [movingcontrolpoints,staticcontrolpoints] = cpselect(this.data,that.data,'Wait',true);
end

%% Generate transform
mytform = cp2tform(movingcontrolpoints,staticcontrolpoints,'affine'); %#ok<DCPTF>
transform = ChiImageTransform(mytform,staticcontrolpoints,movingcontrolpoints,'affine',that.xpixels,that.ypixels);

%% Create registered output
registered = ChiPicture;
registered.data = imtransform(this.data, mytform, 'XData',[1, that.xpixels],'YData',[1, that.ypixels]); %#ok<DIMTRNS>
registered.xpixels = that.xpixels;
registered.ypixels = that.ypixels;
registered.history.add('From image registration process')
registered.history.add(['Source image: ', this.filenames{1}]);
% registered.history.add(['Target image: ', that.filenames{1}]);

%% Generate images if requested
if vis
    % Calculate and show image output
    registered.display; title('Registered image (cropped and resampled)');

    fullresolutionregistered = imtransform(this.data,mytform); %#ok<DIMTRNS>
    figure;imshow(fullresolutionregistered);axis image;axis off;title('Registered image (at original resolution)');
end
