classdef ChiIRImage < ChiImage & ChiIRCharacter
    
% ChiIRImage  An infrared image.
%
% Syntax
%   irimage = ChiIRImage(wavenumbers,data,xpixels,ypixels);
%   irimage = ChiIRImage(wavenumbers,data,xpixels,ypixels,reversex);
%   irimage = ChiIRImage(wavenumbers,data,xpixels,ypixels,reversex,xlabel,xunit,ylabel,yunit);
%   irimage = ChiIRImage(ChiImage);
%
% Description
%   irimage = ChiIRImage(wavenumbers,data,xpixels,ypixels) creates an
%   infrared image object using default values for reversex, xlabel and
%   ylabel.
%
%   irimage = ChiIRImage(ChiImage) creates an infrared image object from a
%   ChiImage object using default values for reversex, xlabel and ylabel.
%   No check is made to determine if the ChiImage object contains valid
%   infrared data.
% 
%   Default values are: 
%       reversex = true (wavenumbers are plotted in descending order);
%       xlabel   = 'wavenumber'
%       xunit    = 'cm^{-1}'
%       ylabel   = 'absorbance'
%       yunit    = ''
%
% Copyright (c) 2018, Alex Henderson.
% Licenced under the GNU General Public License (GPL) version 3.
%
% See also 
%   ChiImage ChiSpectralCollection.

% Contact email: alex.henderson@manchester.ac.uk
% Licenced under the GNU General Public License (GPL) version 3
% http://www.gnu.org/copyleft/gpl.html
% Other licensing options are available, please contact Alex for details
% If you use this file in your work, please acknowledge the author(s) in
% your publications. 

% Version 1.0, January 2018
% The latest version of this file is available on Bitbucket
% https://bitbucket.org/AlexHenderson/chitoolbox


    properties (Dependent)
        wavenumbers     % A vector of wavenumber values in ascending order
    end
    
    methods
        function this = ChiIRImage(varargin)
          
            superClassArgs = varargin;
            
            % Define defaults if not provided in varargin
            switch nargin
                case 0
                    % Do nothing, this is an empty class
                case 1
                    if isa(varargin{1},'ChiImage')
                        s = varargin{1};
                        superClassArgs{1} = s.xvals;
                        superClassArgs{2} = s.data;
                        superClassArgs{3} = s.xpixels;
                        superClassArgs{4} = s.ypixels;
                        superClassArgs{5} = s.reversex;
                        superClassArgs{6} = s.xlabelname;
                        superClassArgs{7} = s.xlabelunit;
                        superClassArgs{8} = s.ylabelname;
                        superClassArgs{9} = s.ylabelunit;
                        superClassArgs{10} = s.mask;
                        superClassArgs{11} = s.masked;
                        superClassArgs{12} = s.filenames;
                        superClassArgs{13} = s.history.clone();
                    else
                        err = MException(['CHI:',mfilename,':InputError'], ...
                            'Input not understood.');
                        throw(err);
                    end
                case 4
                    superClassArgs{5} = true;         % reversex = ascending
                    superClassArgs{6} = 'wavenumber';   % xlabelname
                    superClassArgs{7} = 'cm^{-1}';      % xlabelunit
                    superClassArgs{8} = 'absorbance';   % ylabelname
                    superClassArgs{9} = '';             % ylabelunit (unitless)
                case 5
                    superClassArgs{6} = 'wavenumber';   % xlabelname
                    superClassArgs{7} = 'cm^{-1}';      % xlabelunit
                    superClassArgs{8} = 'absorbance';   % ylabelname
                    superClassArgs{9} = '';             % ylabelunit (unitless)
                case 9
                    superClassArgs = varargin;
                case 12
                    superClassArgs = varargin;
                case 13
                    superClassArgs = varargin;
                otherwise
                    utilities.warningnobacktrace('Not all parameters were interpreted. ')
            end
            
            % ToDo: Need to manage the additional fields in the base class
            
            this@ChiImage(superClassArgs{:});
            this@ChiIRCharacter();
            
            this.spectrumclassname = 'ChiIRSpectrum';
            this.spectralcollectionclassname = 'ChiIRSpectralCollection';
            
            this.ontologyinfo = ChiOntologyInformation();
            this.ontologyinfo.term = 'infrared map';
            this.ontologyinfo.description = ['A data set derived from ' ...
                'infrared microscopy consisting of a ' ...
                'three-dimensional image where two axes describe the ' ...
                'x and y spatial dimensions and the third dimension ' ...
                'represents the infrared wavelength. The image is ' ...
                'obtained by stacking one image per infrared ' ...
                'wavelength sequentially.'];
            this.ontologyinfo.uri = 'http://purl.obolibrary.org/obo/CHMO_0001893';
            this.ontologyinfo.isaccurate = true;
            
        end
       
        %~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
        function obj = clone(this)
            
            % ToDo: There's got to be a better way!!
            % http://undocumentedmatlab.com/blog/general-use-object-copy
            % see the todo.m list
            
            obj = feval(class(this));
            
            obj.xvals = this.xvals;
            obj.data = this.data;
            obj.xpixels = this.xpixels;
            obj.ypixels = this.ypixels;
            obj.reversex = this.reversex;
            obj.xlabelname = this.xlabelname;
            obj.xlabelunit = this.xlabelunit;
            obj.ylabelname = this.ylabelname;
            obj.ylabelunit = this.ylabelunit;
            obj.mask = this.mask;
            obj.masked = this.masked;
            obj.filenames = this.filenames;
            
            obj.history = this.history.clone();
            obj.history.add('Cloned');
            
        end
        
        %~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
        function wavenumbers = get.wavenumbers(this)
            wavenumbers = this.xvals;
        end
        
        %~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
        function set.wavenumbers(this,w)
            if (length(w) ~= size(this.data,2))
                err = MException(['CHI:',mfilename,':OutOfRange'], ...
                    'Wavenumbers and data are different lengths.');
                throw(err);
            end
            if (w(1) > w(end))
                w = flip(w);                
            end
            this.xvals = w;
        end
        
        %~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    end
    
end
