classdef ChiSpectralCollection < ChiAbstractSpectralCollection

    
% ChiSpectralCollection  Storage class for spectra
%
% Syntax
%   collection = ChiSpectralCollection();
%   collection = ChiSpectralCollection(wavenumbers,data);
%   collection = ChiSpectralCollection(wavenumbers,data,reversex);
%   collection = ChiSpectralCollection(wavenumbers,data,reversex,xlabel,ylabel);
%   collection = ChiSpectralCollection(ChiSpectrum);
% 
% Description
%   collection = ChiSpectralCollection() creates an empty spectral
%   collection.
%
%   collection = ChiSpectralCollection(wavenumbers,data) creates a spectral
%   collection with a spectrum 





%   object using default values for reversex, xlabel and ylabel.
%
%   IRSpectrum = ChiIRSpectrum(ChiSpectrum) creates an IR spectrum object
%   from a ChiSpectrum object using default values for reversex, xlabel and
%   ylabel. No check is made to determine if the ChiSpectrum object
%   contains valid IR data.
% 
%   Default values are reversex = true (wavenumbers are plotted in
%   descending order), xlabel = 'wavenumber (cm^{-1})' and ylabel =
%   'absorbance'.
%
% Copyright (c) 2017, Alex Henderson.
% Licenced under the GNU General Public License (GPL) version 3.
%
% See also 
%   ChiSpectrum ChiIRSpectralCollection ChiSpectralCollection.

% Contact email: alex.henderson@manchester.ac.uk
% Licenced under the GNU General Public License (GPL) version 3
% http://www.gnu.org/copyleft/gpl.html
% Other licensing options are available, please contact Alex for details
% If you use this file in your work, please acknowledge the author(s) in
% your publications. 

% Version 1.0, August 2017
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
                        this.classmembership = ChiClassMembership();
                        this.history = ChiLogger();
                        this.history.add(['Generated from a ', class(s), '. Filename: ', s.filename]);                        
                    else
                        err = MException('CHI:ChiSpectralCollection:InputError', ...
                            'Input not understood. Try creating a ChiSpectrum and using that as input.');
                        throw(err);
                    end
                otherwise
                    err = MException('CHI:ChiSpectralCollection:InputError', ...
                        'Input not understood. Try creating a ChiSpectrum and using that as input.');
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
            
            obj = ChiSpectralCollection();
            
            obj.xvals = this.xvals;
            obj.data = this.data;
            obj.reversex = this.xvals;
            obj.xlabel = this.xlabel;
            obj.ylabel = this.ylabel;
            if ~isempty(this.classmembership)
                obj.classmembership = this.classmembership.clone();
            end
            obj.history = this.history.clone();
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

