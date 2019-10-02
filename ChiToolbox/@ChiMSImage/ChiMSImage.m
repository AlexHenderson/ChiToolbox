classdef ChiMSImage < ChiImage & ChiMSCharacter
    
% ChiMSImage  A mass spectral image.
%
% Syntax
%   massspecimage = ChiMSImage(mass,data,xpixels,ypixels);
%   massspecimage = ChiMSImage(mass,data,xpixels,ypixels,reversex);
%   massspecimage = ChiMSImage(mass,data,xpixels,ypixels,reversex,xlabel,xunit,ylabel,yunit);
%   massspecimage = ChiMSImage(ChiImage);
%
% Description
%   massspecimage = ChiMSImage(mass,data,xpixels,ypixels) creates a
%   mass spectral image object using default values for reversex, xlabel
%   and ylabel.
%
%   massspecimage = ChiMSImage(ChiImage) creates a mass spectral image
%   object from a ChiImage object using default values for reversex, xlabel
%   and ylabel. No check is made to determine if the ChiImage object
%   contains valid ms data.
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
%   ChiImage ChiMSSpectralCollection ChiSpectralCollection.

% Contact email: alex.henderson@manchester.ac.uk
% Licenced under the GNU General Public License (GPL) version 3
% http://www.gnu.org/copyleft/gpl.html
% Other licensing options are available, please contact Alex for details
% If you use this file in your work, please acknowledge the author(s) in
% your publications. 

% Version 1.1, January 2018
% The latest version of this file is available on Bitbucket
% https://bitbucket.org/AlexHenderson/chitoolbox


    properties
        imzmlproperties
    end
    
    properties (Dependent)
        mass
    end
    
    % =====================================================================
    methods
    % =====================================================================
        function this = ChiMSImage(varargin)
          
            superClassArgs = varargin;
            
            % Define defaults if not provided in varargin
            switch nargin
                case 0
                    % Do nothing, this is an empty class
                case 1
                    if isa(varargin{1},'ChiImage')
                        input = varargin{1};
                        superClassArgs{1} = input.xvals;
                        superClassArgs{2} = input.data;
                        superClassArgs{3} = input.xpixels;
                        superClassArgs{4} = input.ypixels;
                        superClassArgs{5} = input.reversex;
                        superClassArgs{6} = input.xlabelname;
                        superClassArgs{7} = input.xlabelunit;
                        superClassArgs{8} = input.ylabelname;
                        superClassArgs{9} = input.ylabelunit;
                        superClassArgs{10} = input.mask;
                        superClassArgs{11} = input.masked;
                        superClassArgs{12} = input.filenames;
                        superClassArgs{13} = input.history.clone();
                    else
                        err = MException(['CHI:',mfilename,':InputError'], ...
                            'Input not understood.');
                        throw(err);
                    end
                case 4
                    superClassArgs{5} = false;          % reversex = ascending
                    superClassArgs{6} = 'm/z';          % xlabelname
                    superClassArgs{7} = 'amu';          % xlabelunit
                    superClassArgs{8} = 'intensity';    % ylabelname
                    superClassArgs{9} = 'counts';       % ylabelunit
                case 5
                    superClassArgs{6} = 'm/z';          % xlabelname
                    superClassArgs{7} = 'amu';          % xlabelunit
                    superClassArgs{8} = 'intensity';    % ylabelname
                    superClassArgs{9} = 'counts';       % ylabelunit
                case 9
                    superClassArgs = varargin;
                case 12
                    superClassArgs = varargin;
                case 13
                    superClassArgs = varargin;
                otherwise
                    utilities.warningnobacktrace('Not all parameters were interpreted. ')
            end
            
            % ToDo: Need to manage the additional fields in the base class
            
            this@ChiImage(superClassArgs{:});
            
            this.spectrumclassname = 'ChiMSSpectrum';
            this.spectralcollectionclassname = 'ChiMSSpectralCollection';

            % As close as we can get  
            this.ontologyinfo = ChiOntologyInformation();
            this.ontologyinfo.term = 'mass spectrum';
            this.ontologyinfo.description = ['A plot of the relative ' ...
                'abundance of a beam or other collection of ions as a ' ...
                'function of the mass-to-charge ratio (m/z).']; 
            this.ontologyinfo.uri = 'http://purl.obolibrary.org/obo/MS_1000294';            
            this.ontologyinfo.isaccurate = false;
            
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
