
function [fit para x] = fit_gauss_whole_spec_split( WN , S)
% S - must be column
%tt = toc;

%[peak_pos]=IR_Absorption_Peaks();
%load more_peaks_v5
%peak_pos = [peak_pos ; more_good_v]; clear more_good_v;
%peak_pos = [peak_pos ; 1662];

%peak_pos = sort(peak_pos);

%%
temp1 = [800; 833; 866; 900];

temp2 = [959;970;1030;1061;1081;1156;1171;1202;1230;1280;1312;1334;1368;1377;1388;1402;1438;1453;1463;1472;1516;1547;1631;1640;1653;1662;1694;2849;2873;2917;2956;3067;3271;3285;3296;3307;3317;3328;];

peak_pos = sort([ temp1 ; temp2]);


%%



[a b] = find_value_min_max(WN , 1800 , 2500 );

%shift = [-4 -2 0 2 4];
shift = [-2 0 2];
%shift = 0;

S(a:b) = 0;

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


%% Fit section 1 800 to 1820

[a1] = find_value(peak_pos,2000);
num_G = a1*length(sigma)*length(shift);




[a b] = find_value_min_max(WN, min(WN) , 1840);
S1 = S(a:b);
WN1 = WN(a:b);
G1 = G(a:b,1:num_G);

x1 = lsqnonneg(G1,S1);
fit1 = G1*x1;

fit = zeros(size(S));
fit(1:b) = fit1;

%% Fit section 2: 2500 to 3700

if max(WN) >= 2500
    [a2] = find_value(peak_pos,2500);
    num_G = length(peak_pos(a2:end))*length(sigma)*length(shift);
    [a b] = find_value_min_max(WN, 2500 , 3900);
    S2 = S(a:b);
    
       
    WN2 = WN(a:b);
    G2 = G(a:b,num_G+1:end);

    x2 = lsqnonneg(G2,S2);
    fit2 = G2*x2;
    
    %lin_off = linspace( fit2(1) , fit2(end) , length(WN2) )';
    %fit2 = fit2 - lin_off;


    fit(a:b) = fit2;
end



end % end of fit_gauss_whole_spec











