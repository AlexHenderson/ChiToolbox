function out =  make_column( input )


[N K] = size( input );

if N == 1;
    out = input';
    
else
    out = input;
    
end

