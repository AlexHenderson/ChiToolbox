classdef ChiPLSModel < ChiModel

    
% ChiPLSModel  Class to handle results from a partial least squares (PLS) regression.
%
% Syntax
% 
%   plsmodel = ChiPLSModel(xscores,xloadings,...
%             yscores,yloadings,...
%             xexplained,yexplained,...
%             regressioncoeffs,weights,...
%             ncomp,residuals,...
%             xvals,...
%             xlabelname,xlabelunit,...
%             reversex,...
%             depvar,...
%             algorithm);
%   plsmodel = ChiPLSModel(____, history);
%
% Description
%   plsmodel = ChiPLSModel(xscores, xloadings, yscores,
%   yloadings,xexplained, yexplained, regressioncoeffs, weights, ncomp,
%   residuals, xvals, xlabelname, xlabelunit, reversex, depvar, algorithm)
%   creates a ChiPLSModel object.
%
%   plsmodel = ChiPLSModel(____,history) includes a history, a
%   ChiLogger object.
% 
% Copyright (c) 2020-2021, Alex Henderson.
% Licenced under the GNU General Public License (GPL) version 3.
%
% See also 
%   ChiPCAModel.

% Contact email: alex.henderson@manchester.ac.uk
% Licenced under the GNU General Public License (GPL) version 3
% http://www.gnu.org/copyleft/gpl.html
% Other licensing options are available, please contact Alex for details
% If you use this file in your work, please acknowledge the author(s) in
% your publications. 

% Version 2.0, August 2021
%  Inherit from ChiModel rather than ChiBase
% Version 1.0, May 2020
% The latest version of this file is available at:
% https://github.com/AlexHenderson/ChiToolbox


    properties
        xscores;    % PLS scores on the independent (X) block
        xloadings;  % PLS loadings on the independent (X) block
        yscores;    % PLS scores on the dependent (Y) block
        yloadings;  % PLS loadings on the dependent (Y) block
        xexplained; % Percentage explained variable in independent (X) block
        yexplained; % Percentage explained variable in dependent (Y) block
        regressioncoeffs;   % Coefficients of regression
        weights;    % PLS weightings
        ncomp;      % Number of PLS components used to construct the model
        residuals   % Difference between dependent data and predicted dependent data
        xvals;      % X-axis values
        xlabelname; % text for abscissa label on x-block plots
        xlabelunit; % text for abscissa unit label on x-block plots
        reversex;   % Flag to indicate the x-axis sholuld be reversed on loadings and weights plots
        depvar;     % Dependent variable (Y block) as an instance of ChiClassMembership
        algorithm;  % Char array indicating the algorithm used to perform the PLS calculation
        history = ChiLogger();    % Log of data processing steps
    end
    
    properties (Dependent = true)
        %% Calculated properties
        xlabel      % Label for the x-axis on loadings and weights plots
        classmembership      % Dependent variable (Y block) as an instance of ChiClassMembership
    end
    
    methods
        %% Constructor
        function this = ChiPLSModel(xscores,xloadings,...
                yscores,yloadings,...
                xexplained,yexplained,...
                regressioncoeffs,weights,...
                ncomp,residuals,...
                xvals,...
                xlabelname,xlabelunit,...
                reversex,...
                depvar,...
                algorithm,...
                varargin)
            % Create an instance of ChiPLSModel with given parameters
            
            argposition = find(cellfun(@(x) isa(x,'ChiLogger') , varargin));
            if argposition
                this.history = varargin{argposition}.clone;
                varargin(argposition) = []; %#ok<NASGU>
            else
                this.history = ChiLogger();
            end
            
            if (nargin > 0) % Support calling with 0 arguments
                
                this.xscores = xscores;
                this.xloadings = xloadings;
                this.yscores = yscores;
                this.yloadings = yloadings;
                this.xexplained = xexplained;
                this.yexplained = yexplained;
                this.regressioncoeffs = regressioncoeffs;
                this.weights = weights;
                this.ncomp = ncomp;
                this.residuals = residuals;
                this.xvals = xvals;
                this.xlabelname = xlabelname;
                this.xlabelunit = xlabelunit;
                this.reversex = reversex;
                this.depvar = depvar.clone();
                this.algorithm = algorithm;
                
                this.xvals = utilities.force2row(this.xvals);
            end 
        end
        
        % ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
        function xlabel = get.xlabel(this)
            if isempty(this.xlabelunit)
                xlabel = this.xlabelname;
            else
                xlabel = [this.xlabelname, ' / ', this.xlabelunit, ''];
            end                
        end
        
        % ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
        function classmembership = get.classmembership(this)
            classmembership = this.depvar.clone();                
        end
        
        % ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
        
    end
    
end
