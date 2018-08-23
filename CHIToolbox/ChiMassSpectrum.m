classdef ChiMassSpectrum < ChiSpectrum & ChiMassSpecCharacter
    
% ChiMassSpectrum  A mass spectrum.
%
% Syntax
%   massspectrum = ChiMassSpectrum(mass,data);
%   massspectrum = ChiMassSpectrum(mass,data,reversex);
%   massspectrum = ChiMassSpectrum(mass,data,reversex,xlabel);
%   massspectrum = ChiMassSpectrum(mass,data,reversex,xlabel,ylabel);
%   massspectrum = ChiMassSpectrum(ChiSpectrum);
%
% Description
%   massspectrum = ChiMassSpectrum(mass,data) creates a mass spectrum using
%   default values for reversex, xlabel and ylabel.
%
%   massspectrum = ChiMassSpectrum(ChiSpectrum) creates a mass spectrum
%   from a ChiSpectrum using default values for reversex, xlabel and
%   ylabel. No check is made to determine if the ChiSpectrum contains valid
%   mass spectral data.
% 
%   Default values are reversex = false (mass is plotted in ascending
%   order), xlabel = 'm/z (amu)' and ylabel = 'intensity'.
%
% Copyright (c) 2017-2018, Alex Henderson.
% Licenced under the GNU General Public License (GPL) version 3.
%
% See also 
%   ChiMassImage ChiMassSpectralCollection ChiSpectrum.

% Contact email: alex.henderson@manchester.ac.uk
% Licenced under the GNU General Public License (GPL) version 3
% http://www.gnu.org/copyleft/gpl.html
% Other licensing options are available, please contact Alex for details
% If you use this file in your work, please acknowledge the author(s) in
% your publications. 

% Version 1.0, August 2018
% The latest version of this file is available on Bitbucket
% https://bitbucket.org/AlexHenderson/chitoolbox


    properties (Constant)
%       ontology_term mass spectrum
       ontology_term = 'mass spectrum';
%         type A plot of the relative abundance of a beam or other collection of ions as a function of the mass-to-charge ratio (m/z). 
        type = 'A plot of the relative abundance of a beam or other collection of ions as a function of the mass-to-charge ratio (m/z).'; 
%         uri http://purl.obolibrary.org/obo/MS_1000294
        uri = 'http://purl.obolibrary.org/obo/MS_1000294'
    end    
    
   
    properties (Dependent)
        mass
    end
    
    methods
        function this = ChiMassSpectrum(varargin)
          
            superClassArgs = varargin;
            
            % Define defaults if not provided in varargin
            switch nargin
                case 0
                    % Do nothing, this is an empty class
                case 1
                    if isa(varargin{1},'ChiSpectrum')
                        % ChiSpectrum(xvals,data,reversex,xlabel,ylabel)
                        input = varargin{1};
                        superClassArgs{1} = input.xvals;
                        superClassArgs{2} = input.data;
                        superClassArgs{3} = input.reversex;
                        superClassArgs{4} = input.xlabel;
                        superClassArgs{5} = input.ylabel;
%                         superClassArgs{9} = input.history.clone();
                    else
                        err = MException(['CHI:',mfilename,':InputError'], ...
                            'Input not understood.');
                        throw(err);
                    end
                case 2
                    superClassArgs{3} = false;         % reversex = ascending
                    superClassArgs{4} = 'm/z (amu)';   % xlabel
                    superClassArgs{5} = 'intensity';   % ylabel
                case 3
                    superClassArgs{4} = 'm/z (amu)';   % xlabel
                    superClassArgs{5} = 'intensity';   % ylabel
                case 4
                    superClassArgs{5} = 'intensity';   % ylabel
                case 5
                    superClassArgs = varargin;
                case 7
                    superClassArgs = varargin;
                otherwise
                    utilities.warningnobacktrace('Not all parameters were interpreted. ')
            end
            
            % ToDo: Need to manage the additional fields in the base class
            
            this@ChiSpectrum(superClassArgs{:});
            this@ChiMassSpecCharacter();
            
            if (~isempty(varargin) && isa(varargin{1},'ChiSpectrum'))
                this.filename = varargin{1}.filename;
                this.history = varargin{1}.history.clone();
                this.history.add(['Generated from a ', class(varargin{1}), '.']);
            end
        end
       
        %~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
        function obj = clone(this)
            
            % ToDo: There's got to be a better way!!
            % http://undocumentedmatlab.com/blog/general-use-object-copy
            % see the todo.m list
            
            obj = feval(class(this));
            
            obj.xvals = this.xvals;
            obj.data = this.data;
            obj.reversex = this.reversex;
            obj.xlabel = this.xlabel;
            obj.ylabel = this.ylabel;
            obj.filename = this.filename;

            obj.history = this.history.clone();
            obj.history.add('Cloned');
            
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
