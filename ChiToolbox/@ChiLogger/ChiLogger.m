classdef ChiLogger < ChiBase

% ChiLogger  Records changes to objects
%     
% Syntax
%   logger = ChiLogger() records changes to the object in the form of a
%   cell array of strings.
% 
% Copyright (c) 2007-2019, Alex Henderson.
% Licenced under the GNU General Public License (GPL) version 3.
%
% See also 
%   cell char.

% Contact email: alex.henderson@manchester.ac.uk
% Licenced under the GNU General Public License (GPL) version 3
% http://www.gnu.org/copyleft/gpl.html
% Other licensing options are available, please contact Alex for details
% If you use this file in your work, please acknowledge the author(s) in
% your publications. 

% Version 2.0, 2019
% The latest version of this file is available on Bitbucket
% https://bitbucket.org/AlexHenderson/chitoolbox


    properties
        log     % Cell array of strings 
    end
    
    methods
        % ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
        function this = ChiLogger()
        % Creates a ChiLogger object
            this.log = cell(1);
            this.log{1} = ['Created: ', datestr(now)]; 
        end
        
        % ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
        function obj = clone(this)
        % Creates a deep copy of this object.
        
        % This override of ChiCopyable's clone function is left so that teh
        % object records the cloning event. 
            obj = feval(class(this));
            % Overwrite default log entry
            obj.log = this.log;
            % Append date stamp for cloning operation
            obj.log = vertcat(obj.log, ['Cloned: ', datestr(now)]);
        end
                
        % ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    end
    
end
