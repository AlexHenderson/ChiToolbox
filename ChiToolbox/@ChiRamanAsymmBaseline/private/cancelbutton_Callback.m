function cancelbutton_Callback(this,source,eventdata)  %#ok<INUSD>
    
% cancelbutton_Callback  Closes the window
%
% Syntax
%   cancelbutton_Callback(source,eventdata);
%
% Description
%   cancelbutton_Callback(source,eventdata) is used internally to close the
%   window
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
% The latest version of this file is available on Bitbucket
% https://bitbucket.org/AlexHenderson/chitoolbox


    this.acceptbaseline = false;
    close(this.window);
    
end
