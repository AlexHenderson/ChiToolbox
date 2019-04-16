%%

function [ZDis] = Mie_Smooth_Model(ZRef , rmin , rmax , nmin , nmax)



WN = str2num(ZRef.v)';

if nargin == 1;
    rmin = 2e-6;
    rmax = 10e-6;
    nmin = 1.1;
    nmax = 1.5;
end

amin = 400*pi*rmin*(nmin-1);
amax = 400*pi*rmax*(nmax-1);

if nargin == 1;
    num = 200;
end



alpha = linspace( amin , amax , num );

ZDis.d = zeros( length(alpha) , length(WN) );

for i = 1 : length(alpha);
    
    ZDis.d(i,:) = Mie_alpha( WN , alpha(i));
end


ZDis.v = ZRef.v;
ZDis.i = num2str ( [1:num]' );

end % end of Mie_Smooth_Model






