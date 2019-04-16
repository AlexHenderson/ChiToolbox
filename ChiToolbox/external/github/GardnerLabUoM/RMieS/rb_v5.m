function y1 = rb_v5( WN , y )


[a b] = find_value_min_max( WN , min(WN) , 1800 );
[c d] = find_value_min_max( WN , 2550 , 3700 );

[WN_ind] = [WN(a) WN(b) WN(c) WN(d)];
[Abs] = [0 y(b) y(c) y(d)];


Abs_int = zeros(size(y));
Abs_int(a:b) = linspace( Abs(1) , Abs(2) , length(a:b) );
Abs_int(b:c) = linspace( Abs(2) , Abs(3) , length(b:c) );
Abs_int(c:d) = linspace( Abs(3) , Abs(4) , length(c:d) );

%%

y1 = y - Abs_int;
y1(b:c) = 0;
y1(d:end) = 0;


end
