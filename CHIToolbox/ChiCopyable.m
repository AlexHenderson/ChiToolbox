classdef ChiCopyable < handle
    
% ChiCopyable  Class to manage both deep and shallow copies of classes
%
% Description
%   We need to be able to copy objects inherited from this class.
%   Properties fall into different types. Most can be copied simply since
%   they are values. Any handle class requires a deep copy, otherwise they
%   will both (source and target) point to the same instance of that class.
%   In order to get round this, we first work out whether the property
%   needs to be copied at all (some are dependent properties and so are
%   calculated on demand). Next we determine whether they are objects of a
%   class inherited from a handle; in this case ChiHandle. Non-dependent
%   (ordinary value) properties are simply copied. Object handles are
%   copied by calling their clone method. 
% 
%   An alternative to this approach is to use the matlab.mixin.Copyable
%   class. The initial intention here is to allow for the copying/cloning
%   of classes using MATLAB versions before R2011a when the mixin class
%   became available. However, here we still use metadata information and
%   that may have been introduced around the same time, therefore
%   invalidating the argument.
%
% Copyright (c) 2019, Alex Henderson.
% Licenced under the GNU General Public License (GPL) version 3.
%
% See also 
%   ChiHandle handle matlab.mixin.Copyable

% Contact email: alex.henderson@manchester.ac.uk
% Licenced under the GNU General Public License (GPL) version 3
% http://www.gnu.org/copyleft/gpl.html
% Other licensing options are available, please contact Alex for details
% If you use this file in your work, please acknowledge the author(s) in
% your publications. 

% Version 1.0, February 2019
% The latest version of this file is available on Bitbucket
% https://bitbucket.org/AlexHenderson/chitoolbox

% For discussion on this topic see:
% http://undocumentedmatlab.com/blog/general-use-object-copy
% https://uk.mathworks.com/help/matlab/ref/matlab.mixin.copyable-class.html
% https://uk.mathworks.com/matlabcentral/answers/41674-deep-copy-of-handle-object


    methods
        
        function obj = clone(this)
            obj = feval(class(this));
            thismeta = metaclass(this);
            for i = 1:length(thismeta.PropertyList)
                % Can we set this property? Some properties are dependent
                % and so wil be built on demand.
                if  ~any([ ...
                        thismeta.PropertyList(i, 1).Dependent, ...
                        thismeta.PropertyList(i, 1).Constant, ...
                        thismeta.PropertyList(i, 1).Abstract, ...
                        thismeta.PropertyList(i, 1).Transient, ...
                        thismeta.PropertyList(i, 1).Hidden, ...
                        thismeta.PropertyList(i, 1).GetObservable, ...
                        thismeta.PropertyList(i, 1).SetObservable, ...
                        thismeta.PropertyList(i, 1).AbortSet, ...
                        thismeta.PropertyList(i, 1).NonCopyable])
                    
                    % This is a property we can set
                    
                    % Get the name of the property
                    name = thismeta.PropertyList(i, 1).Name;
                    
                    % Is this property an object? If so we may need to
                    % clone (deep copy) it. 
                    isanobject = eval(['isobject(this.', name, ');']);
                    if isanobject
                        % Does the object inherit frmo ChiHandle, a handle
                        % class? If so it will have a clone function we can
                        % call. 
                        commandline = ['isa(this.', name, ', ''ChiHandle'');'];
                        isahandle = eval(commandline);
                        if isahandle
                            % Clone the property
                            commandline = ['obj.', name, ' = this.', name, '.clone();'];
                            eval(commandline);
                        end
                    else
                        % If the property is not an object that inherits
                        % from ChiHandle (and therefore handle) we can
                        % simply copy it. 
                        commandline = ['obj.', name, ' = this.', name, ';'];
                        eval(commandline);
                    end
                end
            end
            
        end

    end
end
