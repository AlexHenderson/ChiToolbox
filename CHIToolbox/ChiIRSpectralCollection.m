classdef ChiIRSpectralCollection < ChiSpectralCollection & ChiIRCharacter
    
% ChiIRSpectralCollection Storage class for IR spectra
% Copyright (c) 2017 Alex Henderson (alex.henderson@manchester.ac.uk)
    
% ToDo: We need a mechanism of adding collections of spectra together. A
% collection could simply be a single spectrum or ChiSpectrum. We could
% interpolate these in the same manner as BiotofSpectrum. 


    % matlab.mixin.Copyable only for >R2011a
    % Want compatibility with R2009a
    
    % ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    properties (Dependent)
        wavenumbers
    end
    
    % ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    methods
        % ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
        function this = ChiIRSpectralCollection(varargin)

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
                        err = MException('CHI:ChiIRSpectralCollection:InputError', ...
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
                    superClassArgs = varargin{:};
                otherwise
                    utilities.warningnobacktrace('Not all parameters were interpreted. ')
            end
            
            
            this@ChiSpectralCollection(superClassArgs{:});
            this@ChiIRCharacter();
            
            if (~isempty(varargin) && isa(varargin{1},'ChiSpectrum'))
                this.history = varargin{1}.history.clone();
                this.history.add(['Generated from a ', class(varargin{1}), '.']);
            else
                this.history = ChiLogger();
                this.history.add('Generated from MATLAB variables');
            end
            
        end

        % ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
        function obj = clone(this)
            obj = ChiIRSpectralCollection();
            
            obj.xvals = this.xvals;
            obj.data = this.data;
            obj.reversex = this.xvals;
            obj.xlabel = this.xlabel;
            obj.ylabel = this.ylabel;
            
            if ~isempty(this.classmembership)
                obj.classmembership = this.classmembership.clone();
            end
            obj.history = this.history.clone();
            obj.history.add('Cloned');
        end

        %~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
        function wavenumbers = get.wavenumbers(this)
            wavenumbers = this.xvals;
        end
        
        %~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
        function set.wavenumbers(this,wn)
            if (length(wn) ~= length(this.data))
                err = MException('CHI:ChiIRSpectralCollection:OutOfRange', ...
                    'Wavenumbers and data are different lengths.');
                throw(err);
            end
            if (wn(1) > wn(end))
                wn = flip(wn);                
            end
            this.xvals = wn;
        end
        
        %~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
        
        
    end % methods

end % class ChiImage 

