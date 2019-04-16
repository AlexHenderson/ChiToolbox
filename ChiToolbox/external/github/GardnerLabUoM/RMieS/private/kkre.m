function [rindex]=kkre(wavenumber, absorbance)

% Calculates the real refractive index given k.
%
% usage: [rindex]=kkre(wavenumber, absorbance);
%
% Inputs:
%   - Wavenumber - COLUMN VECTOR
%   - k spectrum - ROW VECTOR
%
% by Paul Bassan


% check inputs are the same length


woriginal = wavenumber;
wavenumbersquared = wavenumber .* wavenumber;
wtimesa= wavenumber.*absorbance;

rindex = zeros(size(absorbance));

for h=1:length(wavenumber)

    currentwavenumber = wavenumber(h);
    
    fg=(wtimesa)./(wavenumbersquared-currentwavenumber^2);
    
    fg(isnan(fg)) =[];
    fg(fg==inf)   =[];
    fg(fg==-inf)  =[];
    wavenumber(wavenumber==currentwavenumber)=[];
        
    rindex(h)=(2/pi)*trapz(wavenumber,fg);
    
    wavenumber = woriginal;
end


end % end of kkre




