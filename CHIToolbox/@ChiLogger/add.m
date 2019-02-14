function add(this,content)

% add  Adds an entry to the log
% Copyright (c) 2014 Alex Henderson (alex.henderson@manchester.ac.uk)


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
                err = MException(['CHI:',mfilename,':TypeError'], ...
                    'Unable to append this history log.');
                throw(err);
            end
        end
    end
end

end % function: add
