function [meancellspectra, cells, info] = cellfinder(this, varargin)

% cellfinder  Thresholds an image to identify the location of cells
%
% Syntax
%   [meancellspectra, cells, info] = cellfinder();
%   [meancellspectra, cells, info] = cellfinder('lipid');
%   [meancellspectra, cells, info] = cellfinder('amide1');
%   [meancellspectra, cells, info] = cellfinder(____,lowerlimit,upperlimit);
%   [meancellspectra, cells, info] = cellfinder(____,'threshold',thresholdvalue);
%   [meancellspectra, cells, info] = cellfinder(____,'verbose');
%   [meancellspectra, cells, info] = cellfinder(____,'auto');
%
% Description
%   [meancellspectra, cells, info] = cellfinder() uses the lipid region
%   (3000-2800 wavenumbers) to generate a source image. The initial
%   threshold value is calculated internally by the thresh_tool function.
% 
%   [____] = cellfinder('lipid') uses the lipid region (3000-2800
%   wavenumbers) to generate a source image. The initial threshold value is
%   calculated internally by the thresh_tool function.
%
%   [____] = cellfinder('amide1') uses the amide1 region
%   (1738-1597 wavenumbers) to generate a source image. The initial
%   threshold value is calculated internally by the thresh_tool function.
%
%   [____] = cellfinder(____,lowerlimit,upperlimit) uses the lowerlimit and
%   upperlimit (in wavenumbers) to generate a source image. The initial
%   threshold value is calculated internally by the thresh_tool function.
% 
%   [____] = cellfinder(____,'threshold',thresholdvalue) uses
%   thresholdvalue as the initial threshold value in the thresh_tool
%   function.
% 
%   [____] = cellfinder(____,'verbose') produces 11 images to show the
%   progression of the cell identification process.
% 
%   [____] = cellfinder(____,'auto') uses the default value for the
%   intensity level threshold, as would be calculated by the thresholding
%   tool. The GUI is not displayed.
% 
%   meancellspectra is a ChiIRSpectralCollection containing the mean
%   spectrum of each cell discovered in the image.
% 
%   cells is a struct containing:
%      -cells.spectra a MATLAB cell array of ChiIRSpectralCollection
%       objects. Each object contains the spectra of the pixels contained
%       in each of the biological cells identified.
%      -cells.spectraCount is a list containing the number of pixels in
%       each biologiocal cell identified.
%      -cells.masks is a MATLAB cell array containing a logical mask image
%       of the original data where true values represent the location of
%       the pixels in each biological cell.
% 
%   info is a struct containing the following information about the
%   thresholding calculation:
%      -info.lowerwavenumber is the lower limit of the wavenumber range
%      -info.upperwavenumber is the upper limit of the wavenumber range
%      -info.threshold is the threshold level 
%      -info.binarymask is a binary representation of the original image
%       above and below the threshold
%      -info.auto is a logical to indicate whether the auto option was
%       invoked
%      -info.chiimage is the original ChiIRImage
% 
% Notes
%   This code was originally generated by Melody Jimenez-Hernandez during
%   her PhD: https://pure.manchester.ac.uk/admin/files/54556038/FULL_TEXT.PDF
%   The code was modified by others, most recently by Caryn Hughes. 
%   This version of the code is based on cellfinder2015.m and converted to
%   accommodate the ChiToolbox and some default values. 
% 
% Copyright (c) 2019, Alex Henderson.
% Licenced under the GNU General Public License (GPL) version 3.
%
% See also 
%   Thresholding_Tool.thresh_tool.

% Contact email: alex.henderson@manchester.ac.uk
% Licenced under the GNU General Public License (GPL) version 3
% http://www.gnu.org/copyleft/gpl.html
% Other licensing options are available, please contact Alex for details
% If you use this file in your work, please acknowledge the author(s) in
% your publications. 

% The latest version of this file is available on Bitbucket
% https://bitbucket.org/AlexHenderson/chitoolboxmanchester/


%% step 1: Image thresholding
% this is to zero(or NaN) pixels corresponding to regions of non-biological
% interest i.e. the substrate 
% Filik paper uses the amide I peak area threshold
% We use the lipid range instead(but this is your choice)

%% Defaults
lowlimit = 2800;  % Set for lipid region
highlimit = 3000; % Set for lipid region
showimages = false;     % verbose off
threshold = [];
builtinlimit = false;
autothreshold = false;

%% Process arguments and remove from the list
argposition = find(cellfun(@(x) strcmpi(x, 'auto') , varargin));
if argposition
    varargin(argposition) = [];
    autothreshold = true;
end

argposition = find(cellfun(@(x) strcmpi(x, 'verbose') , varargin));
if argposition
    varargin(argposition) = [];
    showimages = true;
end

argposition = find(cellfun(@(x) strcmpi(x, 'lipid') , varargin));
if argposition
    % Use default lipid range
    builtinlimit = true;
    varargin(argposition) = [];
end

argposition = find(cellfun(@(x) strcmpi(x, 'amide1') , varargin));
if argposition
    lowlimit = 1597;
    highlimit = 1738;
    builtinlimit = true;
    varargin(argposition) = [];
end

argposition = find(cellfun(@(x) strcmpi(x, 'threshold') , varargin));
if argposition
    threshold = varargin{argposition+1};
    varargin(argposition+1) = [];
    varargin(argposition) = [];
end

switch length(varargin)
    case 0
        % All user inputs have been handled
    case 1
        err = MException(['CHI:',mfilename,':IOError'], ...
            'Both low and high image limits must be supplied, or a built-in range eg ''lipid''.');
        throw(err);
    case 2
        if builtinlimit
            utilities.warningnobacktrace('A built-in spectral range has also been selected. Using supplied limits instead.');
        end
        [lowlimit, highlimit] = ChiForceIncreasing(varargin{1},varargin{2});
    otherwise
        err = MException(['CHI:',mfilename,':IOError'], ...
            ['User input not recognised: ', utilities.tostring(varargin{1})]);
        throw(err);
end

%%
data = this.data;

peak_area_image = this.area(lowlimit, highlimit);

if threshold
    if autothreshold
        utilities.warningnobacktrace('Using user-supplied threshold');
        binary = (peak_area_image.data > threshold);
    else
        [threshold, binary] = Thresholding_Tool.thresh_tool(peak_area_image.data, cividis, threshold);
    end
        
else
    % No threshold supplied, so calculate the appropriate value
    if autothreshold
        im = peak_area_image.data;
        themin = min(min(im));
        themax = max(max(im));
        imscaled = (im - themin) ./ (themax-themin);
        level = graythresh(imscaled);
        threshold = (level .* (themax-themin)) + themin;
        binary = (im > threshold);
    else
        [threshold, binary] = Thresholding_Tool.thresh_tool(peak_area_image.data, cividis);
    end
end

peak_area_image2 = peak_area_image.clone();
peak_area_image2.data = peak_area_image2.data .* binary;
if showimages
    peak_area_image2.display(); 
    title('Lipid Integration Image');
end

% SMOOTH IMAGE WITH MEDIAN FILTER
peak_area_smoothed  = peak_area_image2.clone();
peak_area_smoothed.data = medfilt2(peak_area_smoothed.data, [3,3]);
if showimages
    peak_area_smoothed.display(); 
    title('Smoothed Lipid Integration Image');
end

%% filter to enhance edges 
I = mat2gray(peak_area_smoothed.data);
hy = fspecial('Laplacian',0);
hx = hy';
Iy = imfilter(double(I), hy, 'replicate');
Ix = imfilter(double(I), hx, 'replicate');

%% defining cell boundaries
gradmag = sqrt(Ix.^2 + Iy.^2);
if showimages
    figure; 
    imshow(gradmag,[],'InitialMagnification','fit'); 
    title('Gradient Magnitude (gradmag)');
end

%% finds the hotspots within the cell boundaries 
fgm = imregionalmax(I);
if showimages
    figure; 
    imshow(fgm,'InitialMagnification','fit');
    rgb = imoverlay(I, fgm, [0 1 0]);
    imshow(rgb,'InitialMagnification','fit'); 
    title('Regional Maxima Superimposed on Lipid Integration Image');
end

%% threshold and watershed
bw = im2bw(I, graythresh(I)); %#ok<IM2BW>
if showimages
    figure; 
    imshow(bw,'InitialMagnification','fit'); 
    title('Thresholded opening-closing by reconstruction (bw)');
end

%%
D = bwdist(bw);
DL = watershed(D);
if showimages
    figure; 
    imagesc(DL); 
    axis image; axis off; 
    title('Cell separation lines and cell-to-background borders');  
end
bgm = (DL == 0); % 0 = border lines
if showimages
    figure; 
    imshow(bgm,'InitialMagnification','fit'); 
    title('Watershed ridge lines (bgm)');
end

%% make improved gradient magnitude
gradmag2 = imimposemin(gradmag, bgm | fgm);
L = watershed(gradmag2);
I2 = I;
I2(imdilate(L == 0, ones(3, 3)) | bgm | fgm) = 255;
% if showimages
%   figure; 
%   imshow(I2,'InitialMagnification','fit');
%   title('Markers and object boundaries superimposed on original image (I4)');
% end

%%
Lrgb = label2rgb(L, 'jet', 'w', 'shuffle');
if showimages
    figure; 
    imshow(Lrgb,'InitialMagnification','fit');
    title('Colored watershed label matrix (Lrgb)');
end

% finally plot it all together
if showimages
    figure; 
    imshow(I,'InitialMagnification','fit'); 
    hold on
    himage = imshow(Lrgb,'InitialMagnification','fit');
    set(himage, 'AlphaData', 0.3);
    himage = imshow(fgm,'InitialMagnification','fit');
    set(himage, 'AlphaData', 0.5);
    title('Boundaries and Regional Maxima Superimposed Transparently on Original Image');
end

%% From Mel's Cell Finder
[B,L2] = bwboundaries(L,'noholes'); %#ok<ASGLU>
if showimages
    figure; 
    imshow(label2rgb(L2, @jet, [.5 .5 .5]),'InitialMagnification','fit')
end

[B,L2] = bwboundaries(L,'noholes');
numBoundaries = length(B);  % Number of cells identified

if showimages
    figure; 
    imshow(label2rgb(L2, @jet, [.5 .5 .5]),'InitialMagnification','fit')
    
    hold on
    
    % Identify and Label Boundaries
    for k = 1:numBoundaries
        boundary = B{k};
        plot(boundary(:,2), boundary(:,1), 'w', 'LineWidth', 2);
        rndRow = ceil(length(boundary)/(mod(rand*k,7)+1));
        col = boundary(rndRow,2); 
        row = boundary(rndRow,1);
        g = text(col+1, row-1, num2str(L2(row,col)));
        set(g, 'Color','K', 'FontSize',15, 'FontWeight','bold');
    end
end

% Extract all corresponding spectra
cellSpectra = cell(numBoundaries,1);
cellMask = cell(numBoundaries,1);
meancellspectra = zeros(numBoundaries,this.numchannels);
numPixelsPerCell = zeros(numBoundaries,1);

for i = 1:numBoundaries
    cell_position = (L2 == i); 
    cellMask{i,1} = cell_position;
    cell_i = data(cell_position,:); % Could do this more transparently
    
    temp = ChiIRSpectralCollection(this);
    temp.data = cell_i;
    
    cellSpectra{i,1} = temp;
    numPixelsPerCell(i) = temp.numspectra;
    cell_i_mean = mean(cell_i,1);
    meancellspectra(i,1:length(cell_i_mean)) = cell_i_mean;    
end

cells.spectra = cellSpectra;
cells.spectraCount = numPixelsPerCell;
cells.masks = cellMask;

temp = ChiIRSpectralCollection(this);
temp.data = meancellspectra;
meancellspectra = temp;

info.lowerwavenumber = lowlimit;
info.upperwavenumber = highlimit;
info.threshold = threshold;
info.binarymask = binary;
info.auto = autothreshold;
info.chiimage = this;


end % function: cellfinder