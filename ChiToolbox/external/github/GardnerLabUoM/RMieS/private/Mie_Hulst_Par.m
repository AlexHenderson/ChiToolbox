%%

function [ZDis] = Mie_Hulst_Par(ZRef , r_min , r_max , n_min , n_max , spacings)

WN = str2num(ZRef.v)';

ref_n = kkre( WN , ZRef.d );
ref_n = ref_n / abs(min(ref_n));



if nargin == 1
    rr = linspace( 2e-6, 8e-6, 10 );
    aa = linspace( 1.1, 1.5, 10 );
    bs = 10; 
elseif nargin == 6
    rr = 1e-6*linspace( r_min, r_max, spacings );
    aa = linspace( n_min, n_max, spacings );
    bs = spacings;
end

number_rows = length(rr)*length(aa)*bs;

z = zeros( number_rows , 3 );

j = 0;
for k = 1 : length(rr);
    r = rr(k);
    
    for n = 1 : length(aa); 
        
        a = aa(n);
        
        bb = linspace( 0.0 , a-1.01 , bs );
        
        for i = 1 : length(bb);
            j = j + 1;
            
            b = bb(i);
            
            z(j,1:3) = [r a b];
        end
    end
end



out = zeros(number_rows , length( ref_n ));


for i = 1 : number_rows
    
    ri = z(i,2) + z(i,3)*ref_n;
    
    out(i,:) = Mie_n( WN , z(i,1) , ri );
    
end


ZDis.d = out;
ZDis.v = ZRef.v;
ZDis.i = num2str ( [1:number_rows]' );

end % end of Mie_Hulst_Par







