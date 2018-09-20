classdef ChiRamanSpectralCollection < ChiSpectralCollection & ChiRamanCharacter
    
% ChiRamanSpectralCollection Storage class for Raman spectra
% Copyright (c) 2018 Alex Henderson (alex.henderson@manchester.ac.uk)
    
% ToDo: We need a mechanism of adding collections of spectra together. A
% collection could simply be a single spectrum or ChiSpectrum. We could
% interpolate these in the same manner as BiotofSpectrum. 


    % matlab.mixin.Copyable only for >R2011a
    % Want compatibility with R2009a
    
    % ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    properties (Dependent)
        ramanshift
    end
    
    % ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    methods
        % ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
        function this = ChiRamanSpectralCollection(varargin)
          
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
                        if ~isempty(s.history)
                            superClassArgs{8}.history = s.history.clone();
                            superClassArgs{8}.history.add('Created from a ChiSpectrum');
                        else
                            superClassArgs{8}.history = ChiLogger();                
                        end
                        
                    else
                        if isa(varargin{1},'ChiSpectralCollection')
                            s = varargin{1};
                            superClassArgs{1} = s.xvals;
                            superClassArgs{2} = s.data;
                            superClassArgs{3} = s.reversex;
                            superClassArgs{4} = s.xlabelname;
                            superClassArgs{5} = s.xlabelunit;
                            superClassArgs{6} = s.ylabelname;
                            superClassArgs{7} = s.ylabelunit;
                            if ~isempty(s.classmembership)
                                superClassArgs{8} = s.classmembership.clone();
                            end

                            if ~isempty(s.history)
                                superClassArgs{9} = s.history.clone();
                                superClassArgs{9}.add('Created from a ChiSpectralCollection');
                            else
                                superClassArgs{9} = ChiLogger();                
                            end
                        else
                            err = MException(['CHI:',mfilename,':InputError'], ...
                                'Input not understood.');
                            throw(err);
                        end
                    end
                otherwise
%                     utilities.warningnobacktrace('Not all parameters were interpreted. ')
            end
            
            this@ChiSpectralCollection(superClassArgs{:});
            this@ChiRamanCharacter();
            
            this.spectrumclassname = 'ChiRamanSpectrum';
            
            this.ontologyinfo = ChiOntologyInformation();
            this.ontologyinfo.term = 'Raman spectrum';
            this.ontologyinfo.description = ['A plot of intensity vs. ' ...
                'Raman shift (cm-1) obtained by measuring the Raman ' ...
                'scattering of monochromatic light from a sample. ' ...
                '[database_cross_reference: DOI:10.1021/jp001661l]'];
            this.ontologyinfo.uri = 'http://purl.obolibrary.org/obo/CHMO_0000823';
            this.ontologyinfo.isaccurate = false;

            % We have no way of knowing whether the value for reversex is
            % correct or not, so assume the user knows what they're doing.
            
            if isempty(this.xlabel)
                this.xlabelname = 'Raman shift';
                this.xlabelunit = 'cm^{-1}';
            end
            if isempty(this.ylabel)
                this.ylabelname = 'intensity';
                this.ylabelunit = 'counts';
            end
                
        end

        % ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
        function obj = clone(this)
            obj = feval(class(this));
            
            obj.xvals = this.xvals;
            obj.data = this.data;
            obj.reversex = this.reversex;
            obj.xlabelname = this.xlabelname;
            obj.xlabelunit = this.xlabelunit;
            obj.ylabelname = this.ylabelname;
            obj.ylabelunit = this.ylabelunit;
            
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
        function ramanshift = get.ramanshift(this)
            ramanshift = this.xvals;
        end
        
        %~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
        function set.ramanshift(this,x)
            if (length(x) ~= length(this.data))
                err = MException(['CHI:',mfilename,':OutOfRange'], ...
                    'Raman shift and data are different lengths.');
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

