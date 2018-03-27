function Q = Mie_alpha(WN,alpha)


p = alpha * WN;

%p =  ( (n-1)* (400*pi*Rsize) ).* WN;

Q = 2 - (4./p).*sin(p)+(4./(p.^2)).*(1-cos(p));

end % end of Mie_alpha