classdef ChiRmiesIterations < ChiBase

% ChiRmiesIterations  Iteration history from a RMieS scattering correction
%
% Syntax
%   iterations = ChiRmiesIterations();
%   iterations = ChiRmiesIterations(numberofiterations);
%   iterations = ChiRmiesIterations(iteration);
% 
% Description
%   iterations = ChiRmiesIterations() creates an empty iterations object.
%
%   iterations = ChiRmiesIterations(numberofiterations) creates an
%   iterations object of the correct size. This is more efficient. 
% 
%   iterations = ChiRmiesIterations(iteration) create an iterations object
%   and initialises it to the first iteration. 
% 
% Copyright (c) 2019, Alex Henderson.
% Licenced under the GNU General Public License (GPL) version 3.
%
% See also 
%   ChiIRCharacter.rmies

% Contact email: alex.henderson@manchester.ac.uk
% Licenced under the GNU General Public License (GPL) version 3
% http://www.gnu.org/copyleft/gpl.html
% Other licensing options are available, please contact Alex for details
% If you use this file in your work, please acknowledge the author(s) in
% your publications. 

% Version 1.0, 2019
% The latest version of this file is available on Bitbucket
% https://bitbucket.org/AlexHenderson/chitoolbox


    % ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    properties
        % Cell array of iterations, where each iteration is a ChiIRSpectrum, ChiIRSpectralCollection, or ChiIRImage as appropriate, depending on the data being corrected.
        iteration = {};
        % The data that the RMieS correction operated upon. 
        original;
        % ChiLogger object recording the RMieS parameters used in the correction. 
        history;
    end

    properties (Dependent)
        % The number of correction steps performed.
        numiterations;
    end
    
    % ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    methods
        function this = ChiRmiesIterations(varargin)
        % Generates a ChiRmiesIterations object
            
            if (nargin == 0)
                utilities.warningnobacktrace('It is more efficient to initialise the ChiRmiesIterations variable with the number of iterations expected.');
            else
                if isnumeric(varargin{1})
                    % Creating space for many iterations
                    this.initialise(varargin{1});
                else
                    % Just putting an iteration in the list. 
                    if (isa(varargin{1}, 'ChiSpectrum') ...
                        || isa(varargin{1}, 'ChiSpectralCollection') ...
                        || isa(varargin{1}, 'ChiImage'))
                        this.append(varargin{1});
                    else
                        err = MException(['CHI:',mfilename,':TypeError'], ...
                            'The variable is not a ChiSpectrum, ChiSpectralCollection, or ChiImage object.');
                        throw(err);
                    end
                end
            end
            
            this.history = ChiLogger();
            
        end                    
          
        
        function initialise(this,numberofiterationsexpected)
        % Used to initialise the number of iterations expected.         
        this.iteration = cell(numberofiterationsexpected,1);
        end
        
        function append(this,varargin)
        % Appends this corrected version to the iteration property. 
            
            % Accommodate the possibility that the user initialised the
            % iteration property with insufficient slots. Otherwise, place
            % the data into the first available position.
            position = this.numiterations + 1;
            for i = 1:this.numiterations
                if isempty(this.iteration{i})
                    position = i;
                    break;
                end
            end
            this.iteration(position) = varargin(1);
        end
        
        function numiterations = get.numiterations(this)
        % The number of correction steps performed.
            numiterations = length(this.iteration);
        end
        
        %~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
        
    end % methods

end % class ChiRmiesHistory 
