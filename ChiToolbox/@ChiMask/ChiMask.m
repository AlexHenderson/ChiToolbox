classdef ChiMask < ChiBase

% ChiMask  Storage class for logical vectors and images
%
% Syntax
%   mask = ChiMask(data);
%   mask = ChiMask(data,xpixels,ypixels);
%   mask = ChiMask(data,xpixels,ypixels,layers);
%   mask = ChiMask(____,test,value);
%   mask = ChiMask(____,test,value1,value2);
%
% Description
%   mask = ChiMask(data) creates a ChiMask object using data. data can be a
%   vector, 2D image or 3D hypercube of logical values, or data that can be
%   converted to logicals. data can also be a Chi object.
%
%   mask = ChiMask(data,xpixels,ypixels) uses xpixels and ypixels to
%   reshape a data vector into a 2D array. 
% 
%   mask = ChiMask(data,xpixels,ypixels,layers) uses xpixels and ypixels to
%   reshape a data vector into a 3D array. 
% 
%   mask = ChiMask(____,test,value) performs the function test on data.
%   value is a parameter relating to the test.
%   Available values for test are:
%       '==' data is equal to value;
%       '~=' data is not equal to value;
%       '<'  data is less than value;
%       '>'  data is greater than value;
%       '<=' data is less than, or equal to, value;
%       '>=' data is greater than, or equal to, value;
%       'between' data is >= value1 AND data <= value2. Note that value1
%                 and value2 are sorted into ascending order;
%       'insiderange' same as between;
%       'inrange' same as between;
%       'outsiderange' data is < value1 OR data > value2. Note that value1
%                 and value2 are sorted into ascending order;
% 
%   mask = ChiMask(____,test,value1,value2) is used when there are two
%   values required for the test. value1 and value2 are sorted into
%   ascending order.
% 
% Copyright (c) 2019, Alex Henderson.
% Licenced under the GNU General Public License (GPL) version 3.
%
% See also 
%   ChiMask.test ChiImage ChiSpectralCollection.

% Contact email: alex.henderson@manchester.ac.uk
% Licenced under the GNU General Public License (GPL) version 3
% http://www.gnu.org/copyleft/gpl.html
% Other licensing options are available, please contact Alex for details
% If you use this file in your work, please acknowledge the author(s) in
% your publications. 

% The latest version of this file is available on Bitbucket
% https://bitbucket.org/AlexHenderson/chitoolbox


    properties
        mask = [];  % Logical mask values
        rows = 1;   % Length of a vector mask, or the number of pixels in the y-direction (height) for a 2D/3D image
        cols = 1;   % Number of pixels in the x-direction (width) for a 2D or 3D image, or 1 for a vector
        layers = 1; % Number of depths/layers for a 3D mask, or 1 for a vector or 2D image
        history = ChiLogger();    % Log of data processing steps
    end
    
    properties (Dependent = true)
        dims        % Dimensionality of mask: 1, 2 or 3
        xpixels     % Number of pixels in the x-direction (width) for a 2D or 3D image, or 1 for a vector
        ypixels     % Length of a vector mask, or the number of pixels in the y-direction (height) for a 2D/3D image
        data        % Alias of mask
        numtrue     % Number of true values in the mask
        numfalse    % Number of false values in the mask
    end
    
    methods (Static = true)
        [mask,logmessage] = test(data,test,varargin);   % Perform a logical test on some data
    end
    
    methods
        mask = and(this,that);
        mask = or(this,that);
        mask = not(this,that);
    end    
    
    % =====================================================================
    methods     % Constructor
    % =====================================================================
        function this = ChiMask(varargin)
            % ChiMask Construct an instance of this class

            argposition = find(cellfun(@(x) isa(x,'ChiLogger') , varargin));
            if argposition
                this.history = varargin{argposition}.clone;
                varargin(argposition) = []; 
            else
                this.history = ChiLogger();
            end

            if ~nargin
                % Do nothing
            else
                if isa(varargin{1},'ChiBase')
                    % We have an appropriate Chi object
                    if ~((nargin == 3) || (nargin == 4))
                        err = MException(['CHI:',mfilename,':IOError'], ...
                            'Incorrect number of input parameters.');
                        throw(err);
                    end
                    data = varargin{1}.data;
                    [this,logmessage] = ChiMask.test(data,varargin{2:end});
                    this.history = varargin{1}.history.clone();
                    this.history.add(logmessage);
                else

                    % If we have a string in the argument list then we have a test
                    argposition = find(cellfun(@(x) ischar(x) , varargin));
                    if argposition
                        if ~ischar(varargin{2})
                            err = MException(['CHI:',mfilename,':IOError'], ...
                                'Second parameter should be a char array describing the test.');
                            throw(err);
                        end
                        [this,logmessage] = ChiMask.test(varargin{:});
                        this.history = ChiLogger();
                        this.history.add(logmessage);
                    else
                        % We have a mask and need to import it
                        switch nargin
                            case 1
                                % We have a mask, what what shape is it?
                                this.mask = varargin{1};
                                if isvector(this.mask)
                                    this.rows = length(this.mask);
                                else
                                    [dims] = size(this.mask);
                                    switch length(dims)
                                        case 2
                                            this.rows = dims(1);
                                            this.cols = dims(2);
                                            this.mask = reshape(this.mask,[],1);
                                        case 3
                                            this.rows = dims(1);
                                            this.cols = dims(2);
                                            this.layers = dims(3);
                                            this.mask = reshape(this.mask,[],1);
                                        otherwise
                                            err = MException(['CHI:',mfilename,':DimensionalityError'], ...
                                                'Can only handle 1D,2D or 3D masks');
                                            throw(err);
                                    end
                                end
                            case 2
                                err = MException(['CHI:',mfilename,':IOError'], ...
                                    'Not enough dimensions provided');
                                throw(err);
                            case 3
                                this.mask = varargin{1};
                                this.rows = varargin{2};
                                this.cols = varargin{3};
                                this.mask = reshape(this.mask,[],1);
                            case 4
                                this.mask = varargin{1};
                                this.rows = varargin{2};
                                this.cols = varargin{3};
                                this.layers = varargin{4};
                                this.mask = reshape(this.mask,[],1);
                            otherwise
                                % Not sure yet, we might need other things
                                err = MException(['CHI:',mfilename,':IOError'], ...
                                    'Too many arguments provided');
                                throw(err);
                        end
                        this.history = ChiLogger();
                    end           
                    % Ensure mask is logical
                    this.mask = logical(this.mask);
                    this.mask = utilities.force2col(this.mask);

                end
            end
        end

    % =====================================================================
    end         % Constructor method
    % =====================================================================
    
    % =====================================================================
    methods     % Get and set properties
    % =====================================================================
        function dims = get.dims(this)
            dims = 1;
            if this.cols ~= 1
                dims = 2;
            end
            if this.layers ~= 1
                dims = 3;
            end           
        end
    
    % =====================================================================
        function xpixels = get.xpixels(this)
            xpixels = this.cols;
        end
    
    % =====================================================================
        function ypixels = get.ypixels(this)
            ypixels = this.rows;
        end
    
    % =====================================================================
        function data = get.data(this)
            data = this.mask;
        end
    
    % =====================================================================
        function numtrue = get.numtrue(this)
            numtrue = sum(this.mask);
        end
    
    % =====================================================================
        function numfalse = get.numfalse(this)
            numfalse = sum(~this.mask);
        end
    
    % =====================================================================
    end     % Property methods
    % =====================================================================
    
end % class ChiMask
