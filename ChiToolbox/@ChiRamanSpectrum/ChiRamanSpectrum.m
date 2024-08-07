classdef ChiRamanSpectrum < ChiSpectrum & ChiRamanCharacter

% ChiRamanSpectrum  A Raman spectrum. 
%
% Syntax
%   RamanSpectrum = ChiRamanSpectrum(ramanshift,data);
%   RamanSpectrum = ChiRamanSpectrum(ramanshift,data,reversex);
%   RamanSpectrum = ChiRamanSpectrum(ramanshift,data,reversex,xlabel,xunit,ylabel,yunit);
%   RamanSpectrum = ChiRamanSpectrum(ChiSpectrum);
%
% Description
%   RamanSpectrum = ChiRamanSpectrum(ramanshift,data) creates a Raman
%   spectrum object using default values.
%
%   RamanSpectrum = ChiRamanSpectrum(ChiSpectrum) creates a Raman spectrum
%   object from a ChiSpectrum object using default values. No check is made
%   to determine if the ChiSpectrum object contains valid Raman data.
% 
%   Default values are: 
%       reversex = false (Raman shift is plotted in ascending order)
%       xlabel   = 'Raman shift'
%       xunit    = 'cm^{-1}'
%       ylabel   = 'intensity'
%       yunit    = 'counts'
%
% Copyright (c) 2018, Alex Henderson.
% Licenced under the GNU General Public License (GPL) version 3.
%
% See also 
%   ChiSpectrum ChiRamanSpectralCollection ChiSpectralCollection.

% Contact email: alex.henderson@manchester.ac.uk
% Licenced under the GNU General Public License (GPL) version 3
% http://www.gnu.org/copyleft/gpl.html
% Other licensing options are available, please contact Alex for details
% If you use this file in your work, please acknowledge the author(s) in
% your publications. 

% Version 1.0, February 2018
% The latest version of this file is available at:
% https://github.com/AlexHenderson/ChiToolbox


    properties (Dependent)
        ramanshift
    end
    
    methods
        function this = ChiRamanSpectrum(varargin)
          
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
                    superClassArgs{3} = false;          % reversex = ascending
                    superClassArgs{4} = 'Raman shift';  % xlabelname
                    superClassArgs{5} = 'cm^{-1}';      % xlabelunits
                    superClassArgs{6} = 'intensity';    % ylabelname
                    superClassArgs{7} = 'counts';       % ylabelunits
                case 3
                    superClassArgs{4} = 'Raman shift';  % xlabelname
                    superClassArgs{5} = 'cm^{-1}';      % xlabelunits
                    superClassArgs{6} = 'intensity';    % ylabelname
                    superClassArgs{7} = 'counts';       % ylabelunits
                case 5
                    superClassArgs = varargin;
                otherwise
                    utilities.warningnobacktrace('Not all parameters were interpreted. ')
            end
            
            this@ChiSpectrum(superClassArgs{:});
            this@ChiRamanCharacter();
            
            this.spectralcollectionclassname = 'ChiRamanSpectralCollection';

            this.ontologyinfo = ChiOntologyInformation();
            this.ontologyinfo.term = 'Raman spectrum';
            this.ontologyinfo.description = ['A plot of intensity vs. ' ...
                'Raman shift (cm-1) obtained by measuring the Raman ' ...
                'scattering of monochromatic light from a sample. ' ...
                '[database_cross_reference: DOI:10.1021/jp001661l]'];
            this.ontologyinfo.uri = 'http://purl.obolibrary.org/obo/CHMO_0000823';
            this.ontologyinfo.isaccurate = true;
            
            if (~isempty(varargin) && isa(varargin{1},'ChiSpectrum'))
                this.filenames = varargin{1}.filenames;
                this.history = varargin{1}.history.clone();
                this.history.add(['Generated from a ', class(varargin{1}), '.']);
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
                    'Raman shift and the data are different lengths.');
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
