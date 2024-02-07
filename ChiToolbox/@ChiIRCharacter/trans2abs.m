function obj = trans2abs(this)

% trans2abs  Converts data from transmittance units to absobance units
%
% Syntax
%   trans2abs();
%   obj = trans2abs();
%
% Description
%   trans2abs() changes the data from transmittance units to absorbance
%   units.
% 
%   obj = trans2abs() clones the object before changing the unit. 
%
% Copyright (c) 2018, Alex Henderson.
% Licenced under the GNU General Public License (GPL) version 3.
%
% See also 
%   abs2trans ChiIRCharacter.

% Contact email: alex.henderson@manchester.ac.uk
% Licenced under the GNU General Public License (GPL) version 3
% http://www.gnu.org/copyleft/gpl.html
% Other licensing options are available, please contact Alex for details
% If you use this file in your work, please acknowledge the author(s) in
% your publications. 

% The latest version of this file is available at:
% https://github.com/AlexHenderson/ChiToolbox


    if nargout
        % Want to send output to a new object so clone and re-enter
        % the function from the clone
        obj = this.clone(); 
        obj.trans2abs();
    else
        % Absorbance = 2 - log10(%T)
        % http://www.sensafe.com/conversion-formulas/
        utilities.warningnobacktrace('Assuming data is in percentage transmittance units.');
        this.data = 2 - log10(this.data); 
        this.ylabel = 'absorbance'; 
        this.history.add('Converted to absorbance'); 
    end
end
