classdef ChiToFMSSpectralCollection < ChiMSSpectralCollection & ChiToFMSCharacter
    
% ChiToFMSSpectralCollection  Storage class for time-of-flight mass spectra
% Copyright (c) 2017 Alex Henderson (alex.henderson@manchester.ac.uk)
    
    % =====================================================================
    properties (Dependent)
    end
    
    % =====================================================================
    methods
    % =====================================================================

        function this = ChiToFMSSpectralCollection(varargin)
          
            superClassArgs = varargin;
            
            % Define defaults if not provided in varargin
            switch nargin
                case 0
                    % Do nothing, this is an empty class
                case 1
                    if isa(varargin{1},'ChiSpectrum')
                        this.copypropertiesfrom(varargin{1});
                        
%                         s = varargin{1};
%                         superClassArgs{1} = s.xvals;
%                         superClassArgs{2} = s.data;
%                         superClassArgs{3} = s.reversex;
%                         superClassArgs{4} = s.xlabelname;
%                         superClassArgs{5} = s.xlabelunit;
%                         superClassArgs{6} = s.ylabelname;
%                         superClassArgs{7} = s.ylabelunit;
%                         if ~isempty(s.history)
%                             superClassArgs{8} = s.history.clone();
%                             superClassArgs{8}.add('Created from a ChiSpectrum');
%                         else
%                             superClassArgs{8} = ChiLogger();                
%                         end
                        
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
                case 2
                    superClassArgs = varargin;
                otherwise
                    utilities.warningnobacktrace('Not all parameters were interpreted. ')
            end
            
            this@ChiMSSpectralCollection(superClassArgs{:});
            this@ChiToFMSCharacter();
            
            this.ontologyinfo = ChiOntologyInformation();
            this.ontologyinfo.term = 'time-of-flight mass spectrum';
            this.ontologyinfo.description = 'A plot of relative abundance (%) vs. mass-to-charge ratio obtained from a mass spectrometry experiment where the mass-to-charge ratio is determined from the time they take to reach a detector.';
            this.ontologyinfo.uri = 'http://purl.obolibrary.org/obo/CHMO_0000828';
            this.ontologyinfo.isaccurate = false;

            if isempty(this.xlabel)
                this.xlabelname = 'm/z';
                this.xlabelunit = 'amu';
            end
            if isempty(this.ylabel)
                this.ylabelname = 'intensity';
                this.ylabelunit = 'counts';
            end
                
        end

        % ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
        
    end % methods

end % class ChiToFMSSpectralCollection 
