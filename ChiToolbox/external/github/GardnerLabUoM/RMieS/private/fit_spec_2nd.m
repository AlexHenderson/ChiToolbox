
function [fit para] = fit_spec_2nd( WN , S , peak_pos, nwidths)
% S - must be column
%tt = toc;
%[peak_pos]=IR_Absorption_Peaks();



[a b] = find_value_min_max(WN , 1800 , 2500 );

%shift = [-2 0 2];
shift = 0;

S(a:b) = 0;

%nwidths = 10;

%sigma = linspace( 1 , 30 , nwidths);
sigma = linspace( 5 , 100 , nwidths);

G = zeros( length(WN) , length(peak_pos)*length(sigma)*length(shift) );


k = 0;
for i = 1 : length(peak_pos);
    for j = 1 : length(sigma);
        
        s = sigma(j);
        for h = 1 : length(shift);
            k = k + 1;
            shi = shift(h);
            
            x0 = peak_pos(i) + shi;
            G(:,k) = gauss(WN , x0 , 1 , s);
            
            ind(k,:) = [x0 shi s];
        end
    end
end

%G(:,end+1) = 1;
%G(:,end+1) = WN;

%disp(['Making Gauss curves took ',num2str(toc-tt),' seconds'])

%V = spline( WN_V , V' , WN )';
%tt = toc;
x = lsqnonneg(G,S);
%disp(['lsqnonneg took ',num2str(toc-tt),' seconds'])

fit = (G*x)';

para.weights = x;
para.gauss = G;
para.ind = ind;
para.numpeaks = length(peak_pos);
para.nwidths = nwidths;

end % end of fit_gauss_whole_spec











