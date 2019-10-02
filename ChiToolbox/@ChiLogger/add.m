function add(this,content)

% add  Adds an entry to the log
%     
% Syntax
%   add(text) appends text to the log. text can be a single string of
%   characters, or a cell array of strings. 
% 
% Copyright (c) 2014-2019, Alex Henderson.
% Licenced under the GNU General Public License (GPL) version 3.
%
% See also 
%   ChiLogger cell char.

% Contact email: alex.henderson@manchester.ac.uk
% Licenced under the GNU General Public License (GPL) version 3
% http://www.gnu.org/copyleft/gpl.html
% Other licensing options are available, please contact Alex for details
% If you use this file in your work, please acknowledge the author(s) in
% your publications. 

% Version 2.0, 2019
% The latest version of this file is available on Bitbucket
% https://bitbucket.org/AlexHenderson/chitoolbox


if exist('content','var')
    
    if isa(content,'ChiLogger')
        this.log = vertcat(this.log,content.log);
    else
        if iscellstr(content) %#ok<ISCLSTR>
            this.log = vertcat(this.log,content);
        else
            if ischar(content)
                this.log = vertcat(this.log,{content});
            else
                if isvector(content)
                    this.log = vertcat(this.log, num2str(content));
                else
                    err = MException(['CHI:',mfilename,':TypeError'], ...
                        'Unable to append this history log item.');
                    throw(err);
                end
            end
        end
    end
end

end % function: add
