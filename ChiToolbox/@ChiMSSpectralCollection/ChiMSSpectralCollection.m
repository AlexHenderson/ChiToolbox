classdef ChiMSSpectralCollection < ChiSpectralCollection & ChiMSCharacter
    
% ChiMSSpectralCollection  A collection of mass spectra.
%
% Syntax
%   massspecdata = ChiMSSpectralCollection(mass,data);
%   massspecdata = ChiMSSpectralCollection(mass,data,reversex);
%   massspecdata = ChiMSSpectralCollection(mass,data,reversex,xlabel,xunit,ylabel,yunit);
%   massspecdata = ChiMSSpectralCollection(ChiSpectralCollection);
%
% Description
%   massspecdata = ChiMSSpectralCollection(mass,data) creates a mass
%   spectral collection using default values.
%
%   massspecdata = ChiMSSpectralCollection(ChiSpectralCollection) creates a
%   mass spectral collection from a ChiSpectralCollection using default
%   values. No check is made to determine if the ChiSpectralCollection
%   contains valid mass spectral data.
% 
%   Default values are: 
%       reversex = false (mass is plotted in ascending order)
%       xlabel   = 'm/z'
%       xunit    = 'amu'
%       ylabel   = 'intensity'
%       yunit    = 'counts'
%
% Copyright (c) 2017-2018, Alex Henderson.
% Licenced under the GNU General Public License (GPL) version 3.
%
% See also 
%   ChiMSSpectrum ChiSpectralCollection.

% Contact email: alex.henderson@manchester.ac.uk
% Licenced under the GNU General Public License (GPL) version 3
% http://www.gnu.org/copyleft/gpl.html
% Other licensing options are available, please contact Alex for details
% If you use this file in your work, please acknowledge the author(s) in
% your publications. 

% Version 1.0, August 2018
% The latest version of this file is available on Bitbucket
% https://bitbucket.org/AlexHenderson/chitoolbox


    properties (Dependent)
        mass
    end
    
    % =====================================================================
    methods
    % =====================================================================
        function this = ChiMSSpectralCollection(varargin)
          
            superClassArgs = varargin;
            
            % Define defaults if not provided in varargin
            switch nargin
                case 0
                    % Do nothing, this is an empty class
                case 1
                    if isa(varargin{1},'ChiSpectralCollection')
                        input = varargin{1};
                        superClassArgs{1} = input.xvals;
                        superClassArgs{2} = input.data;
                        superClassArgs{3} = input.reversex;
                        superClassArgs{4} = input.xlabelname;
                        superClassArgs{5} = input.xlabelunit;
                        superClassArgs{6} = input.ylabelname;
                        superClassArgs{7} = input.ylabelunit;
                        superClassArgs{8} = input.classmembership;
                        superClassArgs{9} = input.filenames;
%                         superClassArgs{9} = input.filenames;
%                         superClassArgs{10} = input.history.clone();
                    else
                        err = MException(['CHI:',mfilename,':InputError'], ...
                            'Input not understood.');
                        throw(err);
                    end
                case 2
                    superClassArgs{3} = false;          % reversex = ascending
                    superClassArgs{4} = 'm/z';          % xlabelname
                    superClassArgs{5} = 'amu';          % xlabelunit
                    superClassArgs{6} = 'intensity';    % ylabelname
                    superClassArgs{7} = 'counts';       % ylabelunit
                case 3
                    superClassArgs{4} = 'm/z';          % xlabelname
                    superClassArgs{5} = 'amu';          % xlabelunit
                    superClassArgs{6} = 'intensity';    % ylabelname
                    superClassArgs{7} = 'counts';       % ylabelunit
                case 7
                    superClassArgs = varargin;
                case 9
                    superClassArgs = varargin;
                otherwise
                    utilities.warningnobacktrace('Not all parameters were interpreted. ')
            end
            
            % ToDo: Need to manage the additional fields in the base class
            
            this@ChiSpectralCollection(superClassArgs{:});
            this@ChiMSCharacter();
            
            % As close as we can get  
            this.ontologyinfo = ChiOntologyInformation();
            this.ontologyinfo.term = 'mass spectrum';
            this.ontologyinfo.description = ['A plot of the relative ' ...
                'abundance of a beam or other collection of ions as a ' ...
                'function of the mass-to-charge ratio (m/z).']; 
            this.ontologyinfo.uri = 'http://purl.obolibrary.org/obo/MS_1000294';            
            this.ontologyinfo.isaccurate = false;

            if (~isempty(varargin) && isa(varargin{1},'ChiSpectralCollection'))
                this.history = varargin{1}.history.clone();
                this.history.add(['Generated from a ', class(varargin{1}), '.']);
            end
        end
       
        %~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
        function mass = get.mass(this)
            mass = this.xvals;
        end
        
        %~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
        function set.mass(this,m)
            if (length(m) ~= size(this.data,2))
                err = MException(['CHI:',mfilename,':OutOfRange'], ...
                    'Mass and data are different lengths.');
                throw(err);
            end
            if (m(1) > m(end))
                m = flip(m);                
            end
            this.xvals = m;
        end
        
        %~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    end
    
end