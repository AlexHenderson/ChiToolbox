
function [fit para x] = fit_gauss_whole_spec( WN , S)
% S - must be column
%tt = toc;
[peak_pos]=IR_Absorption_Peaks();




[a b] = find_value_min_max(WN , 1800 , 2500 );

shift = [-2 0 2];
%shift = 0;

S(a:b) = 0;

%sigma = linspace( 10 , 100 , 10);
sigma = linspace( 5 , 100 , 10);

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
            
            %para(k,:) = [x0 shi s];
        end
    end
end
%disp(['Making Gauss curves took ',num2str(toc-tt),' seconds'])        

%V = spline( WN_V , V' , WN )';
%tt = toc;
x = lsqnonneg(G,S);
%disp(['lsqnonneg took ',num2str(toc-tt),' seconds'])

fit = G*x;


end % end of fit_gauss_whole_spec











