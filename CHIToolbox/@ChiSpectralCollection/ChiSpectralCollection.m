classdef ChiSpectralCollection < ChiAbstractSpectralCollection
    
% ChiSpectralCollection  Storage class for a collection of spectra
%
% Syntax
%   collection = ChiSpectralCollection();
%   collection = ChiSpectralCollection(xvals,data);
%   collection = ChiSpectralCollection(xvals,data,reversex);
%   collection = ChiSpectralCollection(xvals,data,reversex,xlabel,ylabel);
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
%   collection = ChiSpectralCollection(xvals,data,reversex,vlabel,ylabel)
%   uses the provided values for xlabel and ylabel.
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
% The latest version of this file is available on Bitbucket
% https://bitbucket.org/AlexHenderson/chitoolbox


    % ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    properties  
        xvals  % abscissa as a row vector
        data  % ordinate as a 2D array (unfolded matrix)
        reversex = false % should abscissa be plotted increasing (false = default) or decreasing (true)
        xlabel = '' % text for abscissa label on plots (default = empty)
        ylabel = '' % text for ordinate label on plots (default = empty)
        classmembership % an instance of ChiClassMembership
        history
    end

    % ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    properties (SetAccess = protected)
    end          

    % ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    properties (Dependent = true)
    % Calculated properties
    end

    methods
        % ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
        % Constructor
        
        function this = ChiSpectralCollection(varargin)
            
            switch nargin
                case 0
                    this.history = ChiLogger();
                case 1
                    if isa(varargin{1},'ChiSpectrum')
                        s = varargin{1};
                        this.xvals = s.xvals;
                        this.data = s.data;
                        this.reversex = s.reversex;
                        this.xlabel = s.xlabel;
                        this.ylabel = s.ylabel;
                        if ~isempty(s.history)
                            this.history = s.history.clone();
                            this.history.add(['Generated from a ', class(s), '. Filename: ', s.filename]);                        
                        else
                            this.history = ChiLogger();                
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
                case 5
                    this.xvals = varargin{1};
                    this.data = varargin{2};
                    this.reversex = varargin{3};
                    this.xlabel = varargin{4};
                    this.ylabel = varargin{5};
                    this.history = ChiLogger();                
                case 6
                    this.xvals = varargin{1};
                    this.data = varargin{2};
                    this.reversex = varargin{3};
                    this.xlabel = varargin{4};
                    this.ylabel = varargin{5};
                    this.history = varargin{6}.clone();                    
                case 7
                    this.xvals = varargin{1};
                    this.data = varargin{2};
                    this.reversex = varargin{3};
                    this.xlabel = varargin{4};
                    this.ylabel = varargin{5};
                    this.classmembership = varargin{6}.clone();
                    this.history = varargin{7}.clone();
                otherwise
                    disp(nargin)
                    err = MException('CHI:ChiSpectralCollection:InputError', ...
                        'Input not understood. Try creating a ChiSpectrum, or ChiSpectralCollection, and using that as input.');
                    throw(err);
            end
                        
        end
        
        
%         function this = ChiSpectralCollection(xvals,data,reversex,xlabel,ylabel,varargin)
%             % Create an instance of ChiSpectralCollection with given parameters
% 
%             this.history = ChiLogger();
% 
%             if (nargin > 0) % Support calling with 0 arguments
%                 this.xvals = xvals;
%                 this.data = data;
% 
%                 % Force x-values to row vector
%                 this.xvals = ChiForceToRow(this.xvals);
% 
%                 % Force y-values to row vectors
%                 [rows,cols] = size(this.data);
%                 if (rows == cols)
%                     utilities.warningnobacktrace('Data matrix is square. Assuming spectra are in rows.');
%                 else
%                     if (rows == length(this.xvals))
%                         this.data = this.data';
%                     end
%                 end                      
% 
%                 % Set other parameters if available
%                 if (nargin > 2)
%                     this.reversex = reversex;
%                     if (nargin > 3)
%                         this.xlabel = xlabel;
%                         this.ylabel = ylabel;
%                     end
%                 end
%             end 
%         end

        % ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
        % Make a copy of this image
%         function output = clone(this)
%             % Make a copy of this image
%             output = ChiSpectralCollection(this.xvals,this.data,this.reversex,this.xlabel,this.ylabel);
%             output.classmembership = this.classmembership;
%             output.history = this.history.clone();
%         end

        function obj = clone(this)
            
            % ToDo: There's got to be a better way!!
            % http://undocumentedmatlab.com/blog/general-use-object-copy
            
            obj = feval(class(this));
            
            obj.xvals = this.xvals;
            obj.data = this.data;
            obj.reversex = this.xvals;
            obj.xlabel = this.xlabel;
            obj.ylabel = this.ylabel;
            if ~isempty(this.classmembership)
                obj.classmembership = this.classmembership.clone();
            end
            if ~isempty(this.history)
                obj.history = this.history.clone();
            else
                obj.history = ChiLogger();                
            end
            obj.history.add('Cloned');
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

