classdef ChiRamanSpectrum < ChiSpectrum & ChiRamanCharacter

% ChiRamanSpectrum  A Raman spectrum. 
%
% Syntax
%   RamanSpectrum = ChiRamanSpectrum(ramanshift,data);
%   RamanSpectrum = ChiRamanSpectrum(ramanshift,data,reversex);
%   RamanSpectrum = ChiRamanSpectrum(ramanshift,data,reversex,xlabel);
%   RamanSpectrum = ChiRamanSpectrum(ramanshift,data,reversex,xlabel,ylabel);
%   RamanSpectrum = ChiRamanSpectrum(ChiSpectrum);
%
% Description
%   RamanSpectrum = ChiRamanSpectrum(ramanshift,data) creates a Raman
%   spectrum object using default values for reversex, xlabel and ylabel.
%
%   RamanSpectrum = ChiRamanSpectrum(ChiSpectrum) creates a Raman spectrum
%   object from a ChiSpectrum object using default values for reversex,
%   xlabel and ylabel. No check is made to determine if the ChiSpectrum
%   object contains valid Raman data.
% 
%   Default values are reversex = true (ramanshift is plotted in ascending
%   order), xlabel = 'Raman shift (cm^{-1})' and ylabel = 'intensity'.
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
% The latest version of this file is available on Bitbucket
% https://bitbucket.org/AlexHenderson/chitoolbox


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
                        superClassArgs{4} = s.xlabel;
                        superClassArgs{5} = s.ylabel;
                    else
                        err = MException(['CHI:',mfilename,':InputError'], ...
                            'Input not understood.');
                        throw(err);
                    end
                case 2
                    superClassArgs{3} = false;   % reversex
                    superClassArgs{4} = 'Raman shift (cm^{-1})';   % xlabel
                    superClassArgs{5} = 'intensity';   % ylabel
                case 3
                    superClassArgs{4} = 'Raman shift (cm^{-1})';   % xlabel
                    superClassArgs{5} = 'intensity';   % ylabel
                case 4
                    superClassArgs{5} = 'intensity';   % ylabel
                case 5
                    superClassArgs = varargin;
                otherwise
                    utilities.warningnobacktrace('Not all parameters were interpreted. ')
            end
            
            this@ChiSpectrum(superClassArgs{:});
            this@ChiRamanCharacter();
            
            this.ontologyinfo = ChiOntologyInformation();
            this.ontologyinfo.term = 'Raman spectrum';
            this.ontologyinfo.description = ['A plot of intensity vs. ' ...
                'Raman shift (cm-1) obtained by measuring the Raman ' ...
                'scattering of monochromatic light from a sample. ' ...
                '[database_cross_reference: DOI:10.1021/jp001661l]'];
            this.ontologyinfo.uri = 'http://purl.obolibrary.org/obo/CHMO_0000823';
            this.ontologyinfo.isaccurate = true;
            
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
            
            obj = feval(class(this));
            
            obj.xvals = this.xvals;
            obj.data = this.data;
            obj.reversex = this.reversex;
            obj.xlabel = this.xlabel;
            obj.ylabel = this.ylabel;
            obj.filename = this.filename;
            
            obj.baseline = this.baseline.clone();

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
                    'Raman shift and the data are different lengths.');
                throw(err);
            end
            if (x(1) > x(end))
                x = flip(x);                
            end
            this.xvals = x;
        end
        
        %~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
%         function modelbaselinegui(this)
        function grrrrr = modelme(this)
            % Call the standalone function version of modelbaselinegui
%            results = modelbaselinegui(this.xvals,this.data,this.xlabel,this.ylabel);
           results = modelbaselinegui(this);
        end
        %~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
        function modelbaselinegui(varargin)
            % Call the standalone function version of modelbaselinegui
%            results = modelbaselinegui(this.xvals,this.data,this.xlabel,this.ylabel);
            a = 9;
           results = modelbaselinegui(varargin);
%            results = modelbaselinegui(this.xvals,this.data,this,this.xlabel,this.ylabel);
            a = 9;
        end
    end
    
end
