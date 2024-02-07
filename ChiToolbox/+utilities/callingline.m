function lastline = callingline()

% callingline  Retrieves the most recent line entered in the Command Window
%
% Syntax
%   lastline = callingline();
%
% Description
%   lastline = callingline() retrieves the most recent line entered in the
%   Command Window
%
% Copyright (c) 2018, Alex Henderson.
% Licenced under the GNU General Public License (GPL) version 3.
%
% See also 
%   Command History

% Contact email: alex.henderson@manchester.ac.uk
% Licenced under the GNU General Public License (GPL) version 3
% http://www.gnu.org/copyleft/gpl.html
% Other licensing options are available, please contact Alex for details
% If you use this file in your work, please acknowledge the author(s) in
% your publications. 

% Version 1.0, August 2018
% The latest version of this file is available at:
% https://github.com/AlexHenderson/ChiToolbox

% Taken from 
% https://uk.mathworks.com/matlabcentral/answers/16693-within-a-function-get-complete-command-line-calling-text-a-la-dbstack
    
history = com.mathworks.mlservices.MLCommandHistoryServices.getSessionHistory;
historyText = char(history);
cvHistory = cellstr(historyText);
lastline = cvHistory{end};

end
