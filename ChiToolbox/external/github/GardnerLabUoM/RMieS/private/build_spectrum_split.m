function [fit para] = build_spectrum_split( WN , S , smoothing_points, threshold);

%% Checking
% WN - COLUMN
% Spectrum - row


WN0 = WN;
%% Second derivative etc etc
if nargin == 3 
    threshold = -0.01;
end


WN = (min(WN) : 0.5 : max(WN))';
S1 = spline( WN0 , S , WN)';

S2 = secondderiv( WN , S1', smoothing_points)';
S2 = norm_min(S2);

WN = WN + abs(WN(1)-WN(2));

%% Select ranges

[WN S2] = select_two_ranges(WN , S2 , min(WN) , 1850 , 2550 , 3800);


nwidths = 15;


Y2.d = S2;
Y2.v = WN; Y2.i = 'Spec';

[Minima]=SelectMinima(Y2,7);

peaks = WN(Minima);
pA = S2(Minima);

%plotp(WN0 , S2); hold on
%scatter(good_v, good_Abs)

%% Threshold here

good_A = find(pA < threshold); 


good_Abs = pA(good_A);

good_v = peaks(good_A);

ppeak = IR_Absorption_Peaks();

%toc
%[fit para] = fit_spec_2nd( WN0 , S' , good_v);
%toc;

% plotp(WN0,[S;fit]), legend('Matrigel','Fit')
% %scatter(good_v, good_Abs)
% 
% a=2;
temp_peaks = IR_Absorption_Peaks;
good_v = [good_v ; temp_peaks ; 900];
good_v = sort(good_v);



%% Create 1

[a b] = find_value_min_max( good_v , min(WN) , 1801 );
good_v1 = good_v(a:b);

%disp(['Low end has ',num2str(length(good_v1)),' peaks'])

[a b] = find_value_min_max( WN0 , min(WN) , 1860 );
S1 = S(a:b);
WN1 = WN0(a:b);

[fit1 para1] = fit_spec_2nd( WN1 , S1' , good_v1, nwidths);

fit = zeros(size(S));

fit(a:b) = fit1;


%% Create 2

if max(WN0) > 2500
    

    [a b] = find_value_min_max( good_v , 2500 , 3900 );
    good_v2 = good_v(a:b);

    [a b] = find_value_min_max( WN0 , 2550 , 3900 );
    S2 = S(a:b);
    WN2 = WN0(a:b);

    [fit2 para2] = fit_spec_2nd( WN2 , S2' , good_v2, nwidths);
    
    fit(a:b) = fit2;
    
    %disp('Doing full range')
    
    %disp(['High end has ',num2str(length(good_v2)),' peaks'])


end



%%
% w1 = para1.weights;
% w2 = para2.weights;
% 
% [a] = find(w1 > (max(w1)/100) );
% [b] = find(w2 > (max(w2)/100) );
% 
% w = [ w1(a) ; w2(b) ];
% ind = [para1.ind(a,:) ; para2.ind(b,:) ];
% 
% 
% y = zeros( size(fit) );
% 
% WNtt = WN0';
% 
% for i = 1 : length(w);
%     
%     y = y + gauss( WNtt , ind(i,1) , w(i,:) , ind(i,3) );
%     
% end
% 
% 
% %fit = y;




%disp('Split finished')






























































