classdef ChiImageFile < ChiBase

% ChiImageFile  File format handler for image files (eg JPEG, TIFF,PNG)
%
% Syntax
%   myfile = ChiImageFile();
%   myfile = ChiImageFile(filename);
%
% Description
%   myfile = ChiImageFile() opens a dialog box to request a filename from
%   the user. The selected file is opened.
% 
%   myfile = ChiImageFile(filename) opens the filename provided.
%
%   This class can read a number of image file formats, for example; JPEG,
%   TIFF, PNG. For a list of available formats, use the MATLAB imformats
%   function. Note that this class cannot read hyperspectral images. Use
%   ChiFile for that purpose.

% Copyright (c) 2019, Alex Henderson.
% Licenced under the GNU General Public License (GPL) version 3.
%
% See also 
%   ChiImage imformats

% Contact email: alex.henderson@manchester.ac.uk
% Licenced under the GNU General Public License (GPL) version 3
% http://www.gnu.org/copyleft/gpl.html
% Other licensing options are available, please contact Alex for details
% If you use this file in your work, please acknowledge the author(s) in
% your publications. 

% The latest version of this file is available on Bitbucket
% https://bitbucket.org/AlexHenderson/chitoolbox

    
    properties
        data;           % Contents of object as a 3D matrix (RGB)
        filenames = {}; % Name of the file, if appropriate
        history;        % Log of data processing steps
    end

    properties (Dependent = true)
        xpixels;        % Number of pixels in the x-direction (width)
        ypixels;        % Number of pixels in the y-direction (height)
        numchannels;    % Number of colour depths
        numcolours;     % Number of colour depths
        numcolors;      % Number of colour depths (for our American friends)
        numpixels;      % Number of pixels in the image
        width;          % Number of pixels in the x-direction
        height;         % Number of pixels in the y-direction
    end


    % =====================================================================
    methods
    % =====================================================================
        function this = ChiImageFile(varargin) % data,filenames,history
        % ChiImageFile constructor
        
            if (nargin == 0)
                this = ChiImageFile.open();
            else
                if (nargin == 1)
                    if ischar(varargin{1})
                        this = ChiImageFile.open(varargin(1));
                    else
                        err = MException(['CHI:',mfilename,':IOError'], ...
                            'A single input must be a filename');
                        throw(err);
                    end
                else

                    argposition = find(cellfun(@(x) isnumeric(x) , varargin));
                    if argposition
                        this.data = varargin{argposition};
                        varargin(argposition) = [];
                    end
                    argposition = find(cellfun(@(x) iscellstr(x) , varargin)); %#ok<ISCLSTR>
                    if argposition
                        this.filenames = varargin{argposition};
                        varargin(argposition) = [];
                    end
                    argposition = find(cellfun(@(x) ischar(x) , varargin));
                    if argposition
                        % Convert to a cell array of char
                        this.filenames = varargin(argposition);
                        varargin(argposition) = [];
                    end
                    argposition = find(cellfun(@(x) isa(x,'ChiLogger') , varargin));
                    if argposition
                        this.history = varargin{argposition}.clone;
                        varargin(argposition) = []; %#ok<NASGU>
                    else
                        this.history = ChiLogger();
                    end

                end
            end
        end

        % ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
        function xpixels = get.xpixels(this)
            xpixels = size(this.data,2);
        end
        
        % ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
        function ypixels = get.ypixels(this)
            % Calculate number of pixels down the image (y-direction)
            ypixels = size(this.data,1);
        end
        
        % ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
        function width = get.width(this)
            width = this.xpixels;
        end
        
        % ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
        function height = get.height(this)
            % Calculate number of pixels down the image (y-direction)
            height = this.ypixels;
        end
        
        % ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
        function numchannels = get.numchannels(this)
            numchannels = size(this.data,3);
        end
        
        % ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
        function numcolours = get.numcolours(this)
            numcolours = this.numchannels;
        end
        
        % ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
        function numcolors = get.numcolors(this)
            numcolors = this.numchannels;
        end
        
        % ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
        function numpixels = get.numpixels(this)
            numpixels = this.ypixels * this.xpixels;
        end
        
        % ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

    end

    % =====================================================================
    methods (Static)
    % =====================================================================
        function truefalse = isreadable(filename)
        % Determines whether ChiImageFile can read the given filename
            if iscell(filename)
                filename = filename{1};
            end
            truefalse = false;

            try 
                imread(filename);
            catch
                return
            end
            truefalse = true;
        end
        
        % ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
        function filter = getFilter()
        % Generates a list of the readable file types
            formats = imformats;
            filter = {length(formats),2};
            for i = 1:length(formats)
                if iscell(formats(i).ext)
                    extn = '*.';
                    extn = horzcat(extn,formats(i).ext{1}); %#ok<AGROW>
                    for j = 2:length(formats(i).ext)
                        extn = horzcat(extn,[';*.', formats(i).ext{j}]); %#ok<AGROW>
                    end
                    filter{i,1} = extn;
                else
                    filter{i,1} = formats(i).ext;
                end
                filter{i,2} = horzcat(formats(i).description, [' (', filter{i,1}, ')']);
            end

            readablefilter = filter{1,1};
            for i = 2:size(filter,1)
                readablefilter = horzcat(readablefilter, [';',filter{i,1}]); %#ok<AGROW>
            end
            filter = vertcat({readablefilter, 'Readable Files'},filter);
        end
        
        % ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
        function obj = open(filenames)
            % Opens the file provided
            
            % Do we have somewhere to put the data?
            if ~nargout
                stacktrace = dbstack;
                functionname = stacktrace.name;
                err = MException(['CHI:',mfilename,':IOError'], ...
                    'Nowhere to put the output. Try something like: myfile = %s(filename);',functionname);
                throw(err);
            end
            
            % If filename(s) are not provided, ask the user
            if ~exist('filenames', 'var')
                filenames = utilities.getfilenames(ChiImageFile.getFilter());
            end
            
            % Make sure we have a cell array of filenames
            if ~iscell(filenames)
                filenames = cellstr(filenames);
            end
            
            % Check whether the files are OK for a ChiImageFile reader
            for i = 1:length(filenames) 
                if ~ChiImageFile.isreadable(filenames{i})
                    message = sprintf('Filename %s is not an image file.', utilities.pathescape(filenames{i}));
                    err = MException(['CHI:',mfilename,':InputError'], message);
                    throw(err);
                end
            end
            
            % Open the file(s)
            if (length(filenames) == 1)
                im = imread(filenames{1});
                obj = ChiImageFile(im,filenames);
            else
                message = 'Can only handle a single file at a time.';
                err = MException(['CHI:',mfilename,':InputError'], message);
                throw(err);
            end
            
        end        
        
        % ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
        function obj = read(varargin)
            % Reads the file provided
            if ~nargout
                stacktrace = dbstack;
                functionname = stacktrace.name;
                err = MException(['CHI:',mfilename,':IOError'], ...
                    'Nowhere to put the output. Try something like: myfile = %s(filename);',functionname);
                throw(err);
            end
            obj = ChiImageFile.open(varargin{:});
        end
            
        % ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
        function name = className()
            % Determines the name of this class
            name = mfilename('class');
        end
    
        % ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    end
    
end
