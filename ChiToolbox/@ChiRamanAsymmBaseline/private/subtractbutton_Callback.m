function subtractbutton_Callback(this,source,eventdata)  %#ok<INUSD>
    
% subtractbutton_Callback  Subtracts the baseline from the data
%
% Syntax
%   subtractbutton_Callback(source,eventdata);
%
% Description
%   subtractbutton_Callback(source,eventdata) is used internally to
%   initiate the baseline removal
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


    this.acceptbaseline = true;
    close(this.window);
    
end
