function obj = resample(varargin)

% resample  Reduces the spatial resolution of the image. 
%
% Syntax
%   resample(combine_y,combine_x);
%   resample(combine_y,combine_x,function);
%   obj = resample(____);
%
% Description
%   resample(combine_y,combine_x) combines the spectra in each of combine_y
%   rows and combine_x columns to produce a new pixel. combine_x and
%   combine_y this must divide into the number of rows exactly. Otherwise
%   we would have 'trailing' pixels. The default combination function is to
%   sum the spectra.
% 
%   resample(combine_y,combine_x,function) used the function name supplied.
%   The options are 'sum' (default), 'mean' and 'std'. 
% 
%   obj = resample(____) clones the image and resamples the clone. The
%   original image is untouched. 
%
% Example
%   new = orig.resample(2,4,'mean') clones the orig ChiImage to produce a
%   version (new) where each pixel in new contains the mean of 8 pixels in
%   orig; two rows of four pixels. If orig had 200 rows and 100 columns
%   then new will be an image with 100 rows and 25 columns.
% 
% Copyright (c) 2015-2018, Alex Henderson.
% Licenced under the GNU General Public License (GPL) version 3.
%
% See also 
%   ChiImage.

% Contact email: alex.henderson@manchester.ac.uk
% Licenced under the GNU General Public License (GPL) version 3
% http://www.gnu.org/copyleft/gpl.html
% Other licensing options are available, please contact Alex for details
% If you use this file in your work, please acknowledge the author(s) in
% your publications. 

% The latest version of this file is available on Bitbucket
% https://bitbucket.org/AlexHenderson/chitoolbox

%   Copyright (c) 2015-2018, Alex Henderson 
%   Contact email: alex.henderson@manchester.ac.uk
%   Licenced under the GNU General Public License (GPL) version 3
%   http://www.gnu.org/copyleft/gpl.html
%   Other licensing options are available, please contact Alex for details
%   If you use this file in your work, please acknowledge the author(s) in
%   your publications. 
%
%       version 4.0 April 2018

%       version 4.0 April 2018, Alex Henderson
%           Converted for ChiToolbox
%       version 3.0 August 2015, Alex Henderson
%           Added function handle to provide for more flexibility
%       version 2.0 August 2015, Alex Henderson
%           Added ability to specify different scaling factors for x and y
%       version 1.0 April 2015, Alex Henderson
%           Initial release


this = varargin{1};

if nargout
    obj = this.clone();
    % Not a great approach, but quite generic. 
    % Prevents errors if the function name changes. 
    command = [mfilename, '(obj,varargin{2:end});'];
    eval(command);  
else
    % We are expecting to modify this object in situ
    
    pixelstosum_y = varargin{2};
    pixelstosum_x = varargin{3};
    if (length(varargin) == 4) 
        functiontoapply = lower(varargin{4});
        if ~(strcmpi(functiontoapply,'sum') || ...
             strcmpi(functiontoapply,'mean') || ...
             strcmpi(functiontoapply,'std'))
             err = MException(['CHI:',mfilename,':IOError'], ...
            'Applied function can only be ''sum'', ''mean'' or ''std''.');
            throw(err);
        end
    end
    
    outputrows = this.ypixels/pixelstosum_y;
    outputcols = this.xpixels/pixelstosum_x;

    % Error checking
    if rem(this.ypixels,pixelstosum_y)
        error('Number of rows of input data must be an integer multiple of the number of summation pixels');
    end

    if rem(this.xpixels,pixelstosum_x)
        error('Number of columns of input data must be an integer multiple of the number of summation pixels');
    end

    if ~exist('functiontoapply','var')
        functiontoapply = 'sum';
    end

    % Cannot use this.numchannels throughout since it is recalculated on
    % each reshape. 
    numchannels = this.numchannels;
    
    this.data = reshape(this.data,pixelstosum_y,[],numchannels);
    this.data = feval(functiontoapply,this.data);
    this.data = reshape(this.data,outputrows,[],numchannels);

    this.data = permute(this.data,[2,1,3]);

    this.data = reshape(this.data,pixelstosum_x,[],numchannels);
    this.data = feval(functiontoapply,this.data);
    this.data = reshape(this.data,outputcols,[],numchannels);

    this.data = permute(this.data,[2,1,3]);

    this.xpixels = outputcols;
    this.ypixels = outputrows;
    
    this.data = reshape(this.data,outputcols*outputrows,[]);
    
    message = ['Resampled: ', num2str(pixelstosum_y), ' rows, ', num2str(pixelstosum_x), ' cols'];
    this.history.add(message);
end

%% Test data
% data = randperm(64);
% data = reshape(data,8,8);
% data = cat(3,data,data,data);
% 
% data4 = reshape(data,2,[],3);   % 2 = required summation
% data4s = sum(data4,1);
% data4sr = reshape(data4s,4,[],3);   % 4 = number of resamples in height
% 
% data4srp = permute(data4sr,[2,1,3]);
% 
% data4srpr = reshape(data4srp,2,[],3);
% data4srprs = sum(data4srpr,1);
% data4srprsr = reshape(data4srprs,4,[],3);
% 
% data4srprsrp = permute(data4srprsr,[2,1,3]);
% 
% data_a_1 = sum(sum(sum(data(1:2,1:2,1))));
% data_a_2 = sum(sum(sum(data(1:2,3:4,1))));
% data_a_3 = sum(sum(sum(data(1:2,5:6,1))));
% data_a_4 = sum(sum(sum(data(1:2,7:8,1))));
% 
% data_b_1 = sum(sum(sum(data(3:4,1:2,1))));
% data_b_2 = sum(sum(sum(data(3:4,3:4,1))));
% data_b_3 = sum(sum(sum(data(3:4,5:6,1))));
% data_b_4 = sum(sum(sum(data(3:4,7:8,1))));
% 
% data_c_1 = sum(sum(sum(data(5:6,1:2,1))));
% data_c_2 = sum(sum(sum(data(5:6,3:4,1))));
% data_c_3 = sum(sum(sum(data(5:6,5:6,1))));
% data_c_4 = sum(sum(sum(data(5:6,7:8,1))));
% 
% data_d_1 = sum(sum(sum(data(7:8,1:2,1))));
% data_d_2 = sum(sum(sum(data(7:8,3:4,1))));
% data_d_3 = sum(sum(sum(data(7:8,5:6,1))));
% data_d_4 = sum(sum(sum(data(7:8,7:8,1))));
