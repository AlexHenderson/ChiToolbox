function obj = abs2trans(this)
    
% trans2abs  Convert data from absorbance units to transmittance units
%
% Syntax
%   abs2trans();
%   obj = abs2trans();
%
% Description
%   abs2trans() changes the data from absorbance units to transmittance
%   units.
% 
%   obj = abs2trans() clones the object before changing the unit. 
%
% Copyright (c) 2018, Alex Henderson.
% Licenced under the GNU General Public License (GPL) version 3.
%
% See also 
%   trans2abs ChiIRCharacter.

% Contact email: alex.henderson@manchester.ac.uk
% Licenced under the GNU General Public License (GPL) version 3
% http://www.gnu.org/copyleft/gpl.html
% Other licensing options are available, please contact Alex for details
% If you use this file in your work, please acknowledge the author(s) in
% your publications. 

% The latest version of this file is available on Bitbucket
% https://bitbucket.org/AlexHenderson/chitoolbox


    if nargout
        % Want to send output to a new object so clone and re-enter
        % the function from the clone
        obj = this.clone(); 
        obj.abs2trans();
    else
        % %T = (10^-Abs)*100
        % http://www.sensafe.com/conversion-formulas/
        utilities.warningnobacktrace('Assuming data is in absorbance units.');
        this.data = (10.^(-this.data)) * 100; 
        this.ylabel = 'transmittance (%)'; 
        this.history.add('Converted to percentage transmittance');
    end
    
end % function abs2trans
