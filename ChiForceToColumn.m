function [vec] = ChiForceToColumn(vec)
%CHIFORCETOCOLUMN Ensures a vector is a column
%   Detailed explanation goes here

if(~isvector(vec))
    % input is not a vector
    err = MException('CHI:ChiForceToColumn:WrongDataType', ...
        'Input is not a vector');
    throw(err);
end

[rows,cols]=size(vec);

if(cols > rows)
    vec=vec';
end

end

