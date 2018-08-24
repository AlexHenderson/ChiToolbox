classdef ChiToFMassSpectralCollection < ChiSpectralCollection & ChiToFMSCharacter
    
% ChiToFMassSpectralCollection  Storage class for time-of-flight mass spectra
% Copyright (c) 2017 Alex Henderson (alex.henderson@manchester.ac.uk)
    
    % =====================================================================
    properties (Dependent)
        mass
    end
    
    % =====================================================================
    methods
    % =====================================================================

        function this = ChiToFMassSpectralCollection(varargin)
          
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
                            superClassArgs{6} = s.history.clone();
                            superClassArgs{6}.add('Created from a ChiSpectrum');
                        else
                            superClassArgs{6} = ChiLogger();                
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
                otherwise
                    utilities.warningnobacktrace('Not all parameters were interpreted. ')
            end
            
            this@ChiSpectralCollection(superClassArgs{:});
            this@ChiToFMSCharacter();
            
            this.spectrumclassname = 'ChiToFMassSpectrum';
            
            this.ontologyinfo = ChiOntologyInformation();
            this.ontologyinfo.term = 'time-of-flight mass spectrum';
            this.ontologyinfo.description = 'A plot of relative abundance (%) vs. mass-to-charge ratio obtained from a mass spectrometry experiment where the mass-to-charge ratio is determined from the time they take to reach a detector.';
            this.ontologyinfo.uri = 'http://purl.obolibrary.org/obo/CHMO_0000828';
            this.ontologyinfo.isaccurate = false;

            if isempty(this.xlabel)
                this.xlabel = 'm/z (amu)';   % xlabel
            end
            if isempty(this.ylabel)
                this.ylabel = 'intensity';   % ylabel
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
        function mass = get.mass(this)
            mass = this.xvals;
        end
        
        %~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
        function set.mass(this,x)
            if (length(x) ~= length(this.data))
                err = MException(['CHI:',mfilename,':OutOfRange'], ...
                    'mass and data are different lengths.');
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

