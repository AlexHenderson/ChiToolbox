function resetbutton_Callback(this,source,eventdata)  %#ok<INUSD>
    
% resetbutton_Callback  Restores default parameters
%
% Syntax
%   resetbutton_Callback(source,eventdata);
%
% Description
%   resetbutton_Callback(source,eventdata) is used internally to restore
%   the default parameters
% 
% Copyright (c) 2018, Alex Henderson.
% Licenced under the GNU General Public License (GPL) version 3.

% Contact email: alex.henderson@manchester.ac.uk
% Licenced under the GNU General Public License (GPL) version 3
% http://www.gnu.org/copyleft/gpl.html
% Other licensing options are available, please contact Alex for details
% If you use this file in your work, please acknowledge the author(s) in
% your publications. 

% Version 1.0, August 2018
% The latest version of this file is available at:
% https://github.com/AlexHenderson/ChiToolbox


    this.reset();
    
    set(this.lambdahandle,  'String', num2str(log10(this.lambda)));
    set(this.asymmhandle,   'String', num2str(this.asymm));
    set(this.penaltyhandle, 'String', num2str(this.penalty));
    
    this.updatebutton_Callback([],[]);
    
end
