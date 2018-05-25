function [obj] = balance(this,varargin)

% balance  Equalise class membership. 
%
% Syntax
%   balance();
%   balance(method);
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

% Version 1.0, May 2018
% The latest version of this file is available on Bitbucket
% https://bitbucket.org/AlexHenderson/chitoolbox


if isempty(this.classmembership)
    err = MException(['CHI:',mfilename,':IOError'], ...
        'No class membership avilable');
    throw(err);
end

% Check whether we're creating a new balanced object, or balancing in situ
if nargout
    obj = this.clone();
    obj.history.add('Created from a clone')
    eval(['obj.',mfilename]);
else
    % Balance this object
    
    % Look for a valid method. A bit of overkill at the moment, but this
    % will probably expand to other methods
    
    balancingMethod = 'undersample';
    
    if nargin
        argposition = find(cellfun(@(x) strcmpi(x, 'undersample') , varargin));
        if argposition
            balancingMethod = 'undersample';
        end
    end

    switch balancingMethod
        case 'undersample'
            chosen = utilities.undersample(this.classmembership.labels);
            this.classmembership.labels = this.classmembership.labels(chosen,:);
            this.data = this.data(chosen,:);
            this.classmembership.history.add('undersampled')
            this.history.add('undersampled')
        otherwise
            err = MException(['CHI:',mfilename,':IOError'], ...
                ['Balancing method ''',varargin{argposition},''' not understood.']);
            throw(err);
    end            
    
end
