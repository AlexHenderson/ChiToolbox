function add(this,content)
% add Adds an entry to the log
% Copyright (c) 2014 Alex Henderson (alex.henderson@manchester.ac.uk)

    if isempty(this.log{1})
        this.log{1} = content;
    else
        this.log = vertcat(this.log,content);
    end

end
