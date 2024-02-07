classdef ChiSpectralCollection < ChiAbstractSpectralCollection
    
% ChiSpectralCollection  Storage class for a collection of spectra
%
% Syntax
%   collection = ChiSpectralCollection();
%   collection = ChiSpectralCollection(xvals,data);
%   collection = ChiSpectralCollection(xvals,data,reversex);
%   collection = ChiSpectralCollection(xvals,data,reversex,xlabel,xunit,ylabel,yunit);
%   collection = ChiSpectralCollection(ChiSpectrum);
%   collection = ChiSpectralCollection(ChiSpectralCollection);
% 
% Description
%   collection = ChiSpectralCollection() creates an empty spectral
%   collection.
%
%   collection = ChiSpectralCollection(xvals,data) creates a spectral
%   collection with a spectrum object using default values for reversex
%   (false), xlabel ('') and ylabel ('').
% 
%   collection = ChiSpectralCollection(xvals,data,reversex) uses the
%   provided value for reversex. 
% 
%   collection = ChiSpectralCollection(xvals,data,reversex,xlabel,xunit,ylabel,yunit)
%   uses the provided values for xlabel/unit and ylabel/unit.
% 
%   collection = ChiSpectralCollection(ChiSpectrum) uses the contents of
%   the ChiSpectrum to populate the collection.
% 
%   collection = ChiSpectralCollection(ChiSpectralCollection) uses the
%   contents of the ChiSpectralCollection to populate the collection.
%
% Copyright (c) 2017, Alex Henderson.
% Licenced under the GNU General Public License (GPL) version 3.
%
% See also 
%   ChiSpectrum ChiIRSpectralCollection ChiToFMassSpectralCollection.

% Contact email: alex.henderson@manchester.ac.uk
% Licenced under the GNU General Public License (GPL) version 3
% http://www.gnu.org/copyleft/gpl.html
% Other licensing options are available, please contact Alex for details
% If you use this file in your work, please acknowledge the author(s) in
% your publications. 

% Version 2.0, August 2017
% The latest version of this file is available at:
% https://github.com/AlexHenderson/ChiToolbox


    % ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    properties  
        xvals;      % Abscissa as a row vector
        data;       % Contents of object as a 2D matrix, spectra in rows
        reversex = false;   % Should abscissa be plotted in decreasing order
        xlabelname = ''; % Text for abscissa label on plots
        xlabelunit = ''; % Text for the abscissa label unit on plots
        ylabelname = ''; % Text for ordinate label on plots
        ylabelunit = ''; % Text for the ordinate label unit on plots
        classmembership; % An instance of ChiClassMembership
        filenames = {};   % Cell array of filenames if opened from a list of files
        history = ChiLogger();     % Log of data processing steps
        dynamicproperties; % Storage space for instance specific properties
        linearity = ChiXAxisLinearity.linear; % Shape of x-axis (discrete, linear, quadratic)
    end

    % ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    properties (Dependent = true)
    % Calculated properties
    end

    methods
        % ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
        % Constructor
        
        function this = ChiSpectralCollection(varargin)

            argposition = find(cellfun(@(x) isa(x,'ChiLogger') , varargin));
            if argposition
                this.history = varargin{argposition}.clone;
                varargin(argposition) = []; 
            else
                this.history = ChiLogger();
            end
            
            switch nargin
                case 0
                case 1
                    if isa(varargin{1},'ChiSpectrum')
                        s = varargin{1};
                        this.xvals = s.xvals;
                        this.data = s.data;
                        this.reversex = s.reversex;
                        this.xlabelname = s.xlabelname;
                        this.xlabelunit = s.xlabelunit;
                        this.ylabelname = s.ylabelname;
                        this.ylabelunit = s.ylabelunit;
                        this.filenames = cellstr(s.filenames);
                        if ~isempty(s.history)
                            this.history = s.history.clone();
                            this.history.add(['Generated from a ', class(s), '. Filename: ', s.filenames]);                        
                        end
                    else
                        if isa(varargin{1},'ChiSpectralCollection')
                            this = varargin{1}.clone();
                        else
                            err = MException('CHI:ChiSpectralCollection:InputError', ...
                                'Input not understood. Try creating a ChiSpectrum, or ChiSpectralCollection, and using that as input.');
                            throw(err);
                        end
                    end
                case 2
                    this.xvals = varargin{1};
                    this.data = varargin{2};
                case 7
                    this.xvals = varargin{1};
                    this.data = varargin{2};
                    this.reversex = varargin{3};
                    this.xlabelname = varargin{4};
                    this.xlabelunit = varargin{5};
                    this.ylabelname = varargin{6};
                    this.ylabelunit = varargin{7};
                case 8
                    this.xvals = varargin{1};
                    this.data = varargin{2};
                    this.reversex = varargin{3};
                    this.xlabelname = varargin{4};
                    this.xlabelunit = varargin{5};
                    this.ylabelname = varargin{6};
                    this.ylabelunit = varargin{7};
                case 9
                    this.xvals = varargin{1};
                    this.data = varargin{2};
                    this.reversex = varargin{3};
                    this.xlabelname = varargin{4};
                    this.xlabelunit = varargin{5};
                    this.ylabelname = varargin{6};
                    this.ylabelunit = varargin{7};
                    if ~isempty(varargin{8})
                        this.classmembership = varargin{8}.clone();
                    end
                case 10
                    this.xvals = varargin{1};
                    this.data = varargin{2};
                    this.reversex = varargin{3};
                    this.xlabelname = varargin{4};
                    this.xlabelunit = varargin{5};
                    this.ylabelname = varargin{6};
                    this.ylabelunit = varargin{7};
                    if ~isempty(varargin{8})
                        this.classmembership = varargin{8}.clone();
                    end
                otherwise
                    disp(nargin)
                    err = MException('CHI:ChiSpectralCollection:InputError', ...
                        'Input not understood. Try creating a ChiSpectrum, or ChiSpectralCollection, and using that as input.');
                    throw(err);
            end
        
            if ~isempty(this.xvals)
                this.xvals = utilities.force2row(this.xvals);
            end
            
            dims = size(this.data);
            if (length(dims) == 3)
                % 3d data so need to reshape
                this.data = reshape(this.data,dims(1)*dims(2),dims(3));
            end            
            
            this.spectrumclassname = 'ChiSpectrum';
            
            this.ontologyinfo = ChiOntologyInformation();
            this.ontologyinfo.term = 'spectrum';
            this.ontologyinfo.description = ['A plot of a measured ' ...
                'quantity against some experimental parameter. ' ...
                '[database_cross_reference: rsc:cb]'];
            this.ontologyinfo.uri = 'http://purl.obolibrary.org/obo/CHMO_0000800';
            this.ontologyinfo.isaccurate = false;            
            
        end

        % ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
        % Get/Set class membership
        function mem = membership(this,newmembership)
            if ~exist('newmembership', 'var')
                mem = this.classmembership;
            else
                this.classmembership = newmembership;
            end
        end          

    end % methods

end % class ChiImage 

