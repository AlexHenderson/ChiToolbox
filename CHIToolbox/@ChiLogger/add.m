function add(this,content)
% add Adds an entry to the log
% Copyright (c) 2014 Alex Henderson (alex.henderson@manchester.ac.uk)

    this.log = vertcat(this.log,content);

end
