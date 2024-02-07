classdef ChiIRSpectralCollection < ChiSpectralCollection & ChiIRCharacter
    
% ChiIRSpectralCollection  Storage class for a collection of infrared spectra
%
% Syntax
%   collection = ChiIRSpectralCollection();
%   collection = ChiIRSpectralCollection(wavenumbers,data);
%   collection = ChiIRSpectralCollection(wavenumbers,data,reversex);
%   collection = ChiIRSpectralCollection(wavenumbers,data,reversex,xlabel,xunit,ylabel,yunit);
%   collection = ChiIRSpectralCollection(ChiSpectrum);
%   collection = ChiIRSpectralCollection(ChiSpectralCollection);
% 
% Description
%   collection = ChiIRSpectralCollection() creates an empty infrared
%   spectral collection.
%
%   collection = ChiIRSpectralCollection(wavenumbers,data) creates an
%   infrared spectral collection using default values.
% 
%   collection = ChiIRSpectralCollection(wavenumbers,data,reversex) uses
%   the provided value for reversex.
% 
%   collection =
%   ChiIRSpectralCollection(wavenumbers,data,reversex,xlabel,xunit,ylabel,yunit)
%   uses the provided values for xlabel/unit and ylabel/unit.
% 
%   collection = ChiIRSpectralCollection(ChiSpectrum) uses the contents of
%   the ChiSpectrum to populate the collection.
% 
%   collection = ChiIRSpectralCollection(ChiSpectralCollection) uses the
%   contents of the ChiSpectralCollection to populate the collection.
%
%   Default values are: 
%       reversex = true (wavenumbers are plotted in descending order);
%       xlabel   = 'wavenumber'
%       xunit    = 'cm^{-1}'
%       ylabel   = 'absorbance'
%       yunit    = ''
% 
% Copyright (c) 2017-2019, Alex Henderson.
% Licenced under the GNU General Public License (GPL) version 3.
%
% See also 
%   ChiSpectrum ChiSpectralCollection ChiIRSpectrum ChiIRImage.

% Contact email: alex.henderson@manchester.ac.uk
% Licenced under the GNU General Public License (GPL) version 3
% http://www.gnu.org/copyleft/gpl.html
% Other licensing options are available, please contact Alex for details
% If you use this file in your work, please acknowledge the author(s) in
% your publications. 

% The latest version of this file is available at:
% https://github.com/AlexHenderson/ChiToolbox


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
                        superClassArgs{4} = s.xlabelname;
                        superClassArgs{5} = s.xlabelunit;
                        superClassArgs{6} = s.ylabelname;
                        superClassArgs{7} = s.ylabelunit;
                        if ~isempty(s.history)
                            superClassArgs{8} = s.history.clone();
                            superClassArgs{8}.add('Created from a ChiSpectrum');
                        else
                            superClassArgs{8} = ChiLogger();                
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
                                type = class(varargin{1});
                                superClassArgs{9}.add(['Created from a ', type]);
                            else
                                superClassArgs{9} = ChiLogger();                
                            end
                        else
                            if isa(varargin{1},'ChiImage')
                                s = varargin{1};
                                superClassArgs{1} = s.xvals;
                                superClassArgs{2} = s.data;
                                superClassArgs{3} = s.reversex;
                                superClassArgs{4} = s.xlabelname;
                                superClassArgs{5} = s.xlabelunit;
                                superClassArgs{6} = s.ylabelname;
                                superClassArgs{7} = s.ylabelunit;
%                                 if ~isempty(s.classmembership)
%                                     superClassArgs{8} = s.classmembership.clone();
%                                 end

                                if ~isempty(s.history)
                                    superClassArgs{9} = s.history.clone();
                                    type = class(varargin{1});
                                    superClassArgs{9}.add(['Created from a ', type]);
                                else
                                    superClassArgs{9} = ChiLogger();                
                                end
                            else
                                err = MException(['CHI:',mfilename,':InputError'], ...
                                    'Input not understood.');
                                throw(err);
                            end
                        end
                    end
                case 2
                    superClassArgs{1} = varargin{1};
                    superClassArgs{2} = varargin{2};
                    superClassArgs{3} = 'true';
                    superClassArgs{4} = 'wavenumber';
                    superClassArgs{5} = 'cm^{-1}';
                    superClassArgs{6} = 'absorbance';
                    superClassArgs{7} = '';
                otherwise
%                     utilities.warningnobacktrace('Not all parameters were interpreted. ')
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
            
            if isempty(this.xlabelname)
                this.xlabelname = 'wavenumber';
                this.xlabelunit = 'cm^{-1}';
            end
            if isempty(this.ylabelname)
                this.ylabelname = 'absorbance';
                this.ylabelunit = '';
            end
                
        end

        % ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
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

end % class ChiIRSpectralCollection 
