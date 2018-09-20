classdef ChiIRSpectrum < ChiSpectrum & ChiIRCharacter

% ChiIRSpectrum  An infrared spectrum. 
%
% Syntax
%   IRSpectrum = ChiIRSpectrum(wavenumbers,data);
%   IRSpectrum = ChiIRSpectrum(wavenumbers,data,reversex);
%   IRSpectrum = ChiIRSpectrum(wavenumbers,data,reversex,xlabel,xunit,ylabel,yunit);
%   IRSpectrum = ChiIRSpectrum(ChiSpectrum);
%
% Description
%   IRSpectrum = ChiIRSpectrum(wavenumbers,data) creates an IR spectrum
%   object using default values.
%
%   IRSpectrum = ChiIRSpectrum(ChiSpectrum) creates an IR spectrum object
%   from a ChiSpectrum object using default values. No check is made to
%   determine if the ChiSpectrum object contains valid IR data.
% 
%   Default values are: 
%       reversex = true (wavenumbers are plotted in descending order);
%       xlabel   = 'wavenumber'
%       xunit    = 'cm^{-1}'
%       ylabel   = 'absorbance'
%       yunit    = ''
%
% Copyright (c) 2017-2018, Alex Henderson.
% Licenced under the GNU General Public License (GPL) version 3.
%
% See also 
%   ChiSpectrum ChiIRSpectralCollection ChiSpectralCollection.

% Contact email: alex.henderson@manchester.ac.uk
% Licenced under the GNU General Public License (GPL) version 3
% http://www.gnu.org/copyleft/gpl.html
% Other licensing options are available, please contact Alex for details
% If you use this file in your work, please acknowledge the author(s) in
% your publications. 

% Version 1.0, August 2017
% The latest version of this file is available on Bitbucket
% https://bitbucket.org/AlexHenderson/chitoolbox


    properties (Dependent)
        wavenumbers
    end
    
    methods
        function this = ChiIRSpectrum(varargin)
          
            superClassArgs = varargin;
            
            % Define defaults if not provided in varargin
            switch nargin
                case 0
                    % Do nothing, this is an empty class
                case 1
                    if isa(varargin{1},'ChiSpectrum')
                        s = varargin{1};
                        superClassArgs{1} = s.xvals;
                        superClassArgs{2} = s.data;
                        superClassArgs{3} = s.reversex;
                        superClassArgs{4} = s.xlabelname;
                        superClassArgs{5} = s.xlabelunit;
                        superClassArgs{6} = s.ylabelname;
                        superClassArgs{7} = s.ylabelunit;
                    else
                        err = MException(['CHI:',mfilename,':InputError'], ...
                            'Input not understood.');
                        throw(err);
                    end
                case 2
                    superClassArgs{3} = true;   % reversex
                    superClassArgs{4} = 'wavenumber';
                    superClassArgs{5} = 'cm^{-1}';
                    superClassArgs{6} = 'absorbance';
                    superClassArgs{7} = '';
                case 3
                    superClassArgs{4} = 'wavenumber';
                    superClassArgs{5} = 'cm^{-1}';
                    superClassArgs{6} = 'absorbance';
                    superClassArgs{7} = '';
                case 7
                    superClassArgs = varargin;
                otherwise
                    utilities.warningnobacktrace('Not all parameters were interpreted. ')
            end
            
            this@ChiSpectrum(superClassArgs{:});
            this@ChiIRCharacter();
            
            this.ontologyinfo = ChiOntologyInformation();
            this.ontologyinfo.term = 'infrared spectrum';
            this.ontologyinfo.description = ['A plot of absorbance or ' ...
                'emission vs. wavelength/wavenumber/frequency ' ...
                'obtained by measuring the absorption or emission of ' ...
                'infrared radiation by a sample'];
            this.ontologyinfo.uri = 'http://purl.obolibrary.org/obo/CHMO_0000818';
            this.ontologyinfo.isaccurate = true;
            
            if (~isempty(varargin) && isa(varargin{1},'ChiSpectrum'))
                this.filename = varargin{1}.filename;
                this.history = varargin{1}.history.clone();
                this.history.add(['Generated from a ', class(varargin{1}), '.']);
            end
        end
       
        %~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
        function obj = clone(this)
            
            % ToDo: There's got to be a better way!!
            % http://undocumentedmatlab.com/blog/general-use-object-copy
            
            obj = feval(class(this));
            
            obj.xvals = this.xvals;
            obj.data = this.data;
            obj.reversex = this.reversex;
            obj.xlabelname = this.xlabelname;
            obj.xlabelunit = this.xlabelunit;
            obj.ylabelname = this.ylabelname;
            obj.ylabelunit = this.ylabelunit;
            obj.filename = this.filename;
            
            if ~isempty(this.history)
                obj.history = this.history.clone();
                obj.history.add('Cloned');
            else
                obj.history = ChiLogger();                
            end
            
        end
        
        %~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
        function wavenumbers = get.wavenumbers(this)
            wavenumbers = this.xvals;
        end
        
        %~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
        function set.wavenumbers(this,x)
            if (length(x) ~= length(this.data))
                err = MException(['CHI:',mfilename,':OutOfRange'], ...
                    'Wavenumbers and data are different lengths.');
                throw(err);
            end
            if (x(1) > x(end))
                x = flip(x);                
            end
            this.xvals = x;
        end
        
        %~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    end
    
end
