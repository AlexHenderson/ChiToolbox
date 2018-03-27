function [MinWaveNum]=FindMinima(Spectrum,Window);
%FindMinima 		- finds the minima of a Spectrum
% usage: [MinWaveNum]=FindMinima(Spectrum,Window) 
% Spectrum is one row of a saisir dataset structure.d 
% str2num
% Window is an odd number window
% MinWaveNum array of indices



Step=int32(Window/2)-1;

if ((Step*2+1)~=Window)
    error('window has to be an odd number')
end

[N M]=size(Spectrum);
Spectrum=1000.0*Spectrum;
j=1;
jk=0;
for i=(Step+1):(M-Step)
     ArrayWindow=Spectrum((i-Step):(i+Step));
    if (min(ArrayWindow)==Spectrum(i))  % this shows that the minimum 
                                        % is in the middel
       %check if there is only one minimum, or if there are several identical
       % values!
       for k=(i-Step):(i+Step)
          if (Spectrum(k)== Spectrum(i))
             jk=jk+1;
          end
       end
       if (jk==1)
           MinWaveNum(j)= i;
           j=j+1;
       end
       jk=0;
    end
    ArrayWindow=[];
end
    
    
