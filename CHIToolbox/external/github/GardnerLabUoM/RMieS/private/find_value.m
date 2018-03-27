% This function finds the indices for a value in vector
%
% Normal vector, not saisir structure
%
% Usage [vec_index]=find_value(vector,value)


function [vec_index]=find_value(vector,value)

[output_value,vec_index]=min(abs(vector-value));

end



