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
                        if ~isempty(s.history)
                            superClassArgs{6}.history = s.history.clone();
                            superClassArgs{6}.history.add('Created from a ChiSpectrum');
                        else
                            superClassArgs{6}.history = ChiLogger();                
                        end
                        
                    else
                        if isa(varargin{1},'ChiSpectralCollection')
                            s = varargin{1};
                            superClassArgs{1} = s.xvals;
                            superClassArgs{2} = s.data;
                            superClassArgs{3} = s.reversex;
                            superClassArgs{4} = s.xlabel;
                            superClassArgs{5} = s.ylabel;
                            if ~isempty(s.classmembership)
                                superClassArgs{6} = s.classmembership.clone();
                            end

                            if ~isempty(s.history)
                                superClassArgs{7} = s.history.clone();
                                superClassArgs{7}.add('Created from a ChiSpectralCollection');
                            else
                                superClassArgs{7} = ChiLogger();                
                            end
                        else
                            err = MException(['CHI:',mfilename,':InputError'], ...
                                'Input not understood.');
                            throw(err);
                        end
                    end
                case 2
                    superClassArgs{1} = varargin{1};
                    superClassArgs{2} = varargin{2};
                    superClassArgs{3} = 'true';
                    superClassArgs{4} = 'wavenumber (cm^{-1})';
                    superClassArgs{5} = 'absorbance';
                otherwise
                    utilities.warningnobacktrace('Not all parameters were interpreted. ')
            end
            
            this@ChiSpectralCollection(superClassArgs{:});
            this@ChiIRCharacter();

            % We have no way of knowing whether the value for reversex is
            % correct or not, so assume the user knows what they're doing.
            
            if isempty(this.xlabel)
                this.xlabel = 'wavenumber (cm^{-1})';   % xlabel
            end
            if isempty(this.ylabel)
                this.ylabel = 'absorbance';   % ylabel
            end
                
        end

        % ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
        function obj = clone(this)
            obj = feval(class(this));
            
            obj.xvals = this.xvals;
            obj.data = this.data;
            obj.reversex = this.reversex;
            obj.xlabel = this.xlabel;
            obj.ylabel = this.ylabel;
            
            if ~isempty(this.classmembership)
                obj.classmembership = this.classmembership.clone();
            end
            
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
        
        
    end % methods

end % class ChiImage 

