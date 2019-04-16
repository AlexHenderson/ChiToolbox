classdef ChiHandle < handle

% ChiHandle  Wrapper for built-in handle class.
%
% Description
%   The built-in, abstract, handle class is used to denote that a subclass
%   should be passed by reference. Unfortunately this populates the help
%   information, presented by the doc function, with a collection of
%   internal parameters. These should be transparent to the end-user.
% 
%   Following a recommendation from Sam Roberts on StackOverflow [1], here
%   we create a wrapper for the built-in handle class and inherit from that
%   instead. The wrapper redefines all methods as hidden, while also
%   passing the calls through to the handle superclass.
%     [1] https://stackoverflow.com/questions/16423515/how-do-i-inherit-documentation-from-super-classes-in-matlab
% 
%   The result of inheriting from this wrapper is cleaner documentation. 
%
% Copyright (c) 2019, Alex Henderson.
% Licenced under the GNU General Public License (GPL) version 3.
%
% See also 
%   handle ChiCopyable ChiBase

% Contact email: alex.henderson@manchester.ac.uk
% Licenced under the GNU General Public License (GPL) version 3
% http://www.gnu.org/copyleft/gpl.html
% Other licensing options are available, please contact Alex for details
% If you use this file in your work, please acknowledge the author(s) in
% your publications. 

% Version 1.0, January 2019
% The latest version of this file is available on Bitbucket
% https://bitbucket.org/AlexHenderson/chitoolbox
    
    
    methods (Hidden=true)
        
        % Create event listener bound to event source
        function el = addlistener(varargin)
            el = addlistener@handle(varargin{:});
        end
        
        % Delete handle object
        function delete(varargin)
            delete@handle(varargin{:});
        end
        
        % Find handle objects
        function Hmatch = findobj(varargin)
            Hmatch = findobj@handle(varargin{:});
        end
        
        % Find meta.property object
        function mp = findprop(varargin)
            mp = findprop@handle(varargin{:});
        end
        
%         % Determine valid handles
%         isvalid is Sealed and so cannot be overridden
        
        % Create event listener without binding to event source
        function eL = listener(varargin)
            eL = listener@handle(varargin{:});
        end
        
        % Notify listeners that event is occurring
        function notify(varargin)
            notify@handle(varargin{:});
        end
        
        % Equal to
        function tf = eq(varargin)
            tf = eq@handle(varargin{:});
        end
        
        % Not Equal to
        function tf = ne(varargin)
            tf = ne@handle(varargin{:});
        end
        
        % Less than
        function tf = lt(varargin)
            tf = lt@handle(varargin{:});
        end
        
        % Less than or equal to
        function tf = le(varargin)
            tf = le@handle(varargin{:});
        end
        
        % Greater than
        function tf = gt(varargin)
            tf = gt@handle(varargin{:});
        end
        
        % Greater than or equal to
        function tf = ge(varargin)
            tf = ge@handle(varargin{:});
        end
        
    end % methods (Hidden=true)
    
end % classdef
