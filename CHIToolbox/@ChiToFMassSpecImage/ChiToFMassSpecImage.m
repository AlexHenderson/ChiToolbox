classdef ChiToFMassSpecImage < ChiMassSpecImage & ChiToFMSCharacter

% ChiToFMassSpecImage  A mass spectral image.
%
% Syntax
%   tofmassspecimage = ChiToFMassSpecImage(mass,data,xpixels,ypixels);
%   tofmassspecimage = ChiToFMassSpecImage(mass,data,xpixels,ypixels,reversex);
%   tofmassspecimage = ChiToFMassSpecImage(mass,data,xpixels,ypixels,reversex,xlabel,xunit,ylabel,yunit);
%   tofmassspecimage = ChiToFMassSpecImage(ChiImage);
%
% Description
%   tofmassspecimage = ChiToFMassSpecImage(mass,data,xpixels,ypixels)
%   creates a mass spectral image object using default values for reversex,
%   xlabel/unit and ylabel/unit.
%
%   tofmassspecimage = ChiToFMassSpecImage(ChiImage) creates a mass
%   spectral image object from a ChiImage object using default values for
%   reversex, xlabel/unit and ylabel/unit. No check is made to determine if
%   the ChiImage object contains valid ms data.
% 
%   Default values are: 
%       reversex = false (mass is plotted in ascending order)
%       xlabel   = 'm/z'
%       xunit    = 'amu'
%       ylabel   = 'intensity'
%       yunit    = 'counts'
%
% Copyright (c) 2018, Alex Henderson.
% Licenced under the GNU General Public License (GPL) version 3.
%
% See also 
%   ChiImage ChiToFMassSpectralCollection ChiToFSpectrum.

% Contact email: alex.henderson@manchester.ac.uk
% Licenced under the GNU General Public License (GPL) version 3
% http://www.gnu.org/copyleft/gpl.html
% Other licensing options are available, please contact Alex for details
% If you use this file in your work, please acknowledge the author(s) in
% your publications. 

% Version 1.0, August 2018
% The latest version of this file is available on Bitbucket
% https://bitbucket.org/AlexHenderson/chitoolbox


    % =====================================================================
    methods
    % =====================================================================
        
        function this = ChiToFMassSpecImage(varargin)
            % Pass everything through to the superclasses
            this@ChiMassSpecImage(varargin{:});
            this@ChiToFMSCharacter();

            this.spectrumclassname = 'ChiToFMassSpectrum';
            this.spectralcollectionclassname = 'ChiToFMassSpectralCollection';
            
            % As close as we can get
            this.ontologyinfo = ChiOntologyInformation();
            this.ontologyinfo.term = 'time-of-flight mass spectrum';
            this.ontologyinfo.description = 'A plot of relative abundance (%) vs. mass-to-charge ratio obtained from a mass spectrometry experiment where the mass-to-charge ratio is determined from the time they take to reach a detector.';
            this.ontologyinfo.uri = 'http://purl.obolibrary.org/obo/CHMO_0000828';
            this.ontologyinfo.isaccurate = false;
            
        end            
    
        % ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
        function obj = clone(this)
            
            % ToDo: There's got to be a better way!!
            % http://undocumentedmatlab.com/blog/general-use-object-copy
            % see the todo.m list
            
            obj = feval(class(this));
            
            obj.xvals = this.xvals;
            obj.data = this.data;
            obj.xpixels = this.xpixels;
            obj.ypixels = this.ypixels;
            obj.reversex = this.reversex;
            obj.xlabelname = this.xlabelname;
            obj.xlabelunit = this.xlabelunit;
            obj.ylabelname = this.ylabelname;
            obj.ylabelunit = this.ylabelunit;
            obj.mask = this.mask;
            obj.masked = this.masked;
            obj.filename = this.filename;
            
            obj.history = this.history.clone();
            obj.history.add('Cloned');

            obj.imzmlproperties = this.imzmlproperties;
            
        end
        
        % ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
        
    end
    
end
