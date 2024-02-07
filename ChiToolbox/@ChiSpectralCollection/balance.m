function [obj] = balance(varargin)

% balance  Equalise class membership. 
%
% Syntax
%   balance();
%   balance(method);
%   balance(____,minimum);
%   balanced = balance(____);
%
% Description
%   balance() considers the number of members of each class in the
%   collection and changes it to make these numbers equal. The default
%   method is 'undersample'. This version modifies the original object.
%
%   balance(method) uses the approach specified by method to balance the
%   classes. This version modifies the original object.
%
%   balance(____,minimum) uses minimum to define the number of members of
%   each class. If minimum is greater than the membership of the minority
%   class, it is ignored. This version modifies the original object.
%
%   balanced = balance(____) first creates a clone of the object, then
%   performs one of the balance functions on the clone. The original object
%   is not modified.
% 
%   Only one balancing method is currently provided: undersample. See the
%   documentation on undersample for that approach. 
%
% Copyright (c) 2018, Alex Henderson.
% Licenced under the GNU General Public License (GPL) version 3.
%
% See also 
%   utilities.undersample ChiSpectralCollection.

% Contact email: alex.henderson@manchester.ac.uk
% Licenced under the GNU General Public License (GPL) version 3
% http://www.gnu.org/copyleft/gpl.html
% Other licensing options are available, please contact Alex for details
% If you use this file in your work, please acknowledge the author(s) in
% your publications. 

% Version 2.0, June 2018
% The latest version of this file is available at:
% https://github.com/AlexHenderson/ChiToolbox


this = varargin{1};

if isempty(this.classmembership)
    err = MException(['CHI:',mfilename,':IOError'], ...
        'No class membership avilable');
    throw(err);
end

if nargout
    obj = this.clone();
    % Not a great approach, but quite generic. 
    % Prevents errors if the function name changes. 
    command = [mfilename, '(obj,varargin{2:end});'];
    eval(command);  
else
    % We are expecting to modify this object in situ
    
    % Balance this object
    
    % Look for a valid method. A bit of overkill at the moment, but this
    % will probably expand to other methods
    
    balancingMethod = 'undersample';
    
    if (nargin > 1)
        argposition = find(cellfun(@(x) strcmpi(x, 'undersample') , varargin));
        if argposition
            balancingMethod = 'undersample';
            varargin(argposition) = [];
        end
    end

    switch balancingMethod
        case 'undersample'
            if (length(varargin) > 1)
                requestedMinimum = varargin{2};
                chosen = utilities.undersample(this.classmembership.labels,requestedMinimum);
            else
                chosen = utilities.undersample(this.classmembership.labels);
            end
            this.classmembership.labels = this.classmembership.labels(chosen,:);
            this.data = this.data(chosen,:);
            this.classmembership.history.add('undersampled')
            this.classmembership.history.add('chosen spectra are:')
            this.classmembership.history.add(num2str(chosen));
            this.history.add('undersampled')
        otherwise
            err = MException(['CHI:',mfilename,':IOError'], ...
                ['Balancing method ''',varargin{argposition},''' not understood.']);
            throw(err);
    end            
    
end
