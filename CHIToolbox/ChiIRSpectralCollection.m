classdef ChiIRSpectralCollection < ChiSpectralCollection & ChiIRCharacter
    
% ChiIRSpectralCollection  Storage class for a collection of infrared spectra
%
% Syntax
%   collection = ChiIRSpectralCollection();
%   collection = ChiIRSpectralCollection(wavenumbers,data);
%   collection = ChiIRSpectralCollection(wavenumbers,data,reversex);
%   collection = ChiIRSpectralCollection(wavenumbers,data,reversex,xlabel,ylabel);
%   collection = ChiIRSpectralCollection(ChiSpectrum);
%   collection = ChiIRSpectralCollection(ChiSpectralCollection);
% 
% Description
%   collection = ChiIRSpectralCollection() creates an empty infrared
%   spectral collection.
%
%   collection = ChiIRSpectralCollection(wavenumbers,data) creates an
%   infrared spectral collection using default values for reversex (true),
%   xlabel ('wavenumber (cm^{-1})') and ylabel ('absorbance').
% 
%   collection = ChiIRSpectralCollection(wavenumbers,data,reversex) uses the
%   provided value for reversex. 
% 
%   collection = ChiIRSpectralCollection(wavenumbers,data,reversex,xlabel,ylabel)
%   uses the provided values for xlabel and ylabel.
% 
%   collection = ChiIRSpectralCollection(ChiSpectrum) uses the contents of
%   the ChiSpectrum to populate the collection.
% 
%   collection = ChiIRSpectralCollection(ChiSpectralCollection) uses the
%   contents of the ChiSpectralCollection to populate the collection.
%
% Copyright (c) 2017, Alex Henderson.
% Licenced under the GNU General Public License (GPL) version 3.
%
% See also 
%   ChiSpectrum ChiSpectralCollection ChiToFMassSpectralCollection.

% Contact email: alex.henderson@manchester.ac.uk
% Licenced under the GNU General Public License (GPL) version 3
% http://www.gnu.org/copyleft/gpl.html
% Other licensing options are available, please contact Alex for details
% If you use this file in your work, please acknowledge the author(s) in
% your publications. 

% Version 1.0, 2017
% The latest version of this file is available on Bitbucket
% https://bitbucket.org/AlexHenderson/chitoolbox

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
            
            this.spectrumclassname = 'ChiIRSpectrum';

            this.ontologyinfo = ChiOntologyInformation();
            this.ontologyinfo.term = 'infrared spectrum';
            this.ontologyinfo.description = ['A plot of absorbance or ' ...
                'emission vs. wavelength/wavenumber/frequency ' ...
                'obtained by measuring the absorption or emission of ' ...
                'infrared radiation by a sample'];
            this.ontologyinfo.uri = 'http://purl.obolibrary.org/obo/CHMO_0000818';
            this.ontologyinfo.isaccurate = false;
            
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

