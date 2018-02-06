classdef ChiIRSpectrum < ChiSpectrum & ChiIRCharacter

% ChiIRSpectrum  An infrared spectrum. 
%
% Syntax
%   IRSpectrum = ChiIRSpectrum(wavenumbers,data);
%   IRSpectrum = ChiIRSpectrum(wavenumbers,data,reversex);
%   IRSpectrum = ChiIRSpectrum(wavenumbers,data,reversex,xlabel);
%   IRSpectrum = ChiIRSpectrum(wavenumbers,data,reversex,xlabel,ylabel);
%   IRSpectrum = ChiIRSpectrum(ChiSpectrum);
%
% Description
%   IRSpectrum = ChiIRSpectrum(wavenumbers,data) creates an IR spectrum
%   object using default values for reversex, xlabel and ylabel.
%
%   IRSpectrum = ChiIRSpectrum(ChiSpectrum) creates an IR spectrum object
%   from a ChiSpectrum object using default values for reversex, xlabel and
%   ylabel. No check is made to determine if the ChiSpectrum object
%   contains valid IR data.
% 
%   Default values are reversex = true (wavenumbers are plotted in
%   descending order), xlabel = 'wavenumber (cm^{-1})' and ylabel =
%   'absorbance'.
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


    properties (Constant)
%       ontology_term infrared spectrum
        ontology_term = 'infrared spectrum';
%       type A plot of absorbance or emission vs. wavelength/wavenumber/frequency obtained by measuring the absorption or emission of infrared radiation by a sample.
        type = 'A plot of absorbance or emission vs. wavelength/wavenumber/frequency obtained by measuring the absorption or emission of infrared radiation by a sample'; 
%       uri http://purl.obolibrary.org/obo/CHMO_0000818
        uri = 'http://purl.obolibrary.org/obo/CHMO_0000818'
    end
   
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
                        superClassArgs{4} = s.xlabel;
                        superClassArgs{5} = s.ylabel;
                    else
                        err = MException(['CHI:',mfilename,':InputError'], ...
                            'Input not understood.');
                        throw(err);
                    end
                case 2
                    superClassArgs{3} = true;   % reversex
                    superClassArgs{4} = 'wavenumber (cm^{-1})';   % xlabel
                    superClassArgs{5} = 'absorbance';   % ylabel
                case 3
                    superClassArgs{4} = 'wavenumber (cm^{-1})';   % xlabel
                    superClassArgs{5} = 'absorbance';   % ylabel
                case 4
                    superClassArgs{5} = 'absorbance';   % ylabel
                case 5
                    superClassArgs = varargin;
                otherwise
                    utilities.warningnobacktrace('Not all parameters were interpreted. ')
            end
            
            this@ChiSpectrum(superClassArgs{:});
            this@ChiIRCharacter();
            
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
            obj.reversex = this.xvals;
            obj.xlabel = this.xlabel;
            obj.ylabel = this.ylabel;
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
