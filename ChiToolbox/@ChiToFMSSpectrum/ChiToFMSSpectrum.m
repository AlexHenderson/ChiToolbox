classdef ChiToFMSSpectrum < ChiMSSpectrum & ChiToFMSCharacter

% ChiToFMSSpectrum  A time-of-flight mass spectrum. 
%
% Syntax
%   tofmassspectrum = ChiToFMSSpectrum(mass,data);
%   tofmassspectrum = ChiToFMSSpectrum(mass,data,reversex);
%   tofmassspectrum = ChiToFMSSpectrum(mass,data,reversex,xlabel,xunit,ylabel,yunit);
%   tofmassspectrum = ChiToFMSSpectrum(ChiSpectrum);
%
% Description
%   tofmassspectrum = ChiToFMSSpectrum(mass,data) creates a time-of-flight
%   mass spectrum object using default values for reversex, xlabel/unit and
%   ylabel/unit.
%
%   tofmassspectrum = ChiToFMSSpectrum(ChiSpectrum) creates a tof-ms
%   spectrum object from a ChiSpectrum object using default values for
%   reversex, xlabel/unit and ylabel/unit. No check is made to determine if
%   the ChiSpectrum object contains valid tof-ms data.
% 
%   Default values are: 
%       reversex = false (mass is plotted in ascending order)
%       xlabel   = 'm/z'
%       xunit    = 'amu'
%       ylabel   = 'intensity'
%       yunit    = 'counts'
%
% Copyright (c) 2017, Alex Henderson.
% Licenced under the GNU General Public License (GPL) version 3.
%
% See also 
%   ChiSpectrum ChiSIMSSpectralCollection ChiSpectralCollection.

% Contact email: alex.henderson@manchester.ac.uk
% Licenced under the GNU General Public License (GPL) version 3
% http://www.gnu.org/copyleft/gpl.html
% Other licensing options are available, please contact Alex for details
% If you use this file in your work, please acknowledge the author(s) in
% your publications. 

% Version 1.0, August 2017
% The latest version of this file is available at:
% https://github.com/AlexHenderson/ChiToolbox


    properties (Dependent)
    end
    
    % =====================================================================
    methods
    % =====================================================================
        function this = ChiToFMSSpectrum(varargin)
          
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
                        superClassArgs{8} = s.classmembership;
                        superClassArgs{9} = s.filenames;
                        superClassArgs{10} = s.history;
                    else
                        err = MException(['CHI:',mfilename,':InputError'], ...
                            'Input not understood.');
                        throw(err);
                    end
                case 2
                    superClassArgs{3} = false;
                    superClassArgs{4} = 'm/z';
                    superClassArgs{5} = 'amu';
                    superClassArgs{6} = 'intensity';
                    superClassArgs{7} = 'counts';
                case 3
                    superClassArgs{4} = 'm/z';
                    superClassArgs{5} = 'amu';
                    superClassArgs{6} = 'intensity';
                    superClassArgs{7} = 'counts';
                case 7
                    superClassArgs = varargin;
                otherwise
                    utilities.warningnobacktrace('Not all parameters were interpreted. ')
            end
            
            this@ChiMSSpectrum(superClassArgs{:});
            this@ChiToFMSCharacter();
            
            this.spectralcollectionclassname = 'ChiToFMSSpectralCollection';
            
            this.ontologyinfo = ChiOntologyInformation();
            this.ontologyinfo.term = 'time-of-flight mass spectrum';
            this.ontologyinfo.description = 'A plot of relative abundance (%) vs. mass-to-charge ratio obtained from a mass spectrometry experiment where the mass-to-charge ratio is determined from the time they take to reach a detector.';
            this.ontologyinfo.uri = 'http://purl.obolibrary.org/obo/CHMO_0000828';
            this.ontologyinfo.isaccurate = true;
            
            if (~isempty(varargin) && isa(varargin{1},'ChiSpectrum'))
                this.filenames = varargin{1}.filenames;
                this.history = varargin{1}.history.clone();
                this.history.add(['Generated from a ', class(varargin{1}), '.']);
            end
        end
       
        %~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
        
    end
    
end
