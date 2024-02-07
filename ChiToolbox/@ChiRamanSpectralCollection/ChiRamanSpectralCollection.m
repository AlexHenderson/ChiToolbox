classdef ChiRamanSpectralCollection < ChiSpectralCollection & ChiRamanCharacter
    
% ChiRamanSpectralCollection  Storage class for a collection of Raman spectra
%
% Syntax
%   collection = ChiRamanSpectralCollection();
%   collection = ChiRamanSpectralCollection(Raman_shift,data);
%   collection = ChiRamanSpectralCollection(Raman_shift,data,reversex);
%   collection = ChiRamanSpectralCollection(Raman_shift,data,reversex,xlabel,xunit,ylabel,yunit);
%   collection = ChiRamanSpectralCollection(ChiSpectrum);
%   collection = ChiRamanSpectralCollection(ChiSpectralCollection);
% 
% Description
%   collection = ChiRamanSpectralCollection() creates an empty Raman
%   spectral collection.
%
%   collection = ChiRamanSpectralCollection(Raman_shift,data) creates an
%   Raman spectral collection using default values.
% 
%   collection = ChiRamanSpectralCollection(Raman_shift,data,reversex) uses
%   the provided value for reversex.
% 
%   collection =
%   ChiRamanSpectralCollection(Raman_shift,data,reversex,xlabel,xunit,ylabel,yunit)
%   uses the provided values for xlabel/unit and ylabel/unit.
% 
%   collection = ChiRamanSpectralCollection(ChiSpectrum) uses the contents
%   of the ChiSpectrum to populate the collection.
% 
%   collection = ChiRamanSpectralCollection(ChiSpectralCollection) uses the
%   contents of the ChiSpectralCollection to populate the collection.
%
%   Default values are: 
%       reversex = false (Raman shift values are plotted in ascending order);
%       xlabel   = 'Raman shift'
%       xunit    = 'cm^{-1}'
%       ylabel   = 'intensity'
%       yunit    = 'counts'
% 
% Copyright (c) 2018-2019, Alex Henderson.
% Licenced under the GNU General Public License (GPL) version 3.
%
% See also 
%   ChiSpectrum ChiSpectralCollection ChiRamanSpectrum ChiRamanImage.

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
                                superClassArgs{9}.add('Created from a ChiSpectralCollection');
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

end % class ChiRamanSpectralCollection 
