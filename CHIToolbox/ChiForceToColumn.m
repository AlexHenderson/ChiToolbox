function output = ChiForceToColumn(output)
%CHIFORCETOCOLUMN Ensures a vector is a column
%   Copyright (c) 2014 Alex Henderson (alex.henderson@manchester.ac.uk)

if ~isvector(output)
    % input is not a vector
    err = MException('CHI:ChiForceToColumn:WrongDataType', ...
        'Input is not a vector');
    throw(err);
end

[rows,cols] = size(output);

if (cols > rows)
    output = output';
end

end

