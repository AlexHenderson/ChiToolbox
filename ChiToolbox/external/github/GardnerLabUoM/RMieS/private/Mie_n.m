function Q = Mie_n(WN,Rsize,n,u)


p =  ( (n-1)* (400*pi*Rsize) ).* WN;
%p =  ( (n-1)* (200*pi*Rsize) ).* WN;

Q = 2 - (4./p).*sin(p)+(4./(p.^2)).*(1-cos(p));


if nargin == 4;
    plot (WN,Q)
    set(gca,'XDir','reverse')
    xlabel('Wavenumber/cm^{-1}')
    ylabel('Q (Scatter Efficiency)')
    title('Graph Showing Mie Scattering Efficiency, Q')
end
