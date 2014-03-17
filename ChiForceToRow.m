function [vec] = ChiForceToRow(vec)
%CHIFORCETOROW Ensures a vector is a row
%   Detailed explanation goes here

if(~isvector(vec))
    % input is not a vector
    err = MException('CHI:ChiForceToRow:WrongDataType', ...
        'Input is not a vector');
    throw(err);
end

[rows,cols]=size(vec);

if(rows > cols)
    vec=vec';
end

end

