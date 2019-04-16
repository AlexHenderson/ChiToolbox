function [fit para] = build_spectrum( WN , S , smoothing_points, threshold);
%tic

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

[WN S2] = select_two_ranges(WN , S2 , min(WN) , 1950 , 2700 , 3700);





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
[fit para] = fit_spec_2nd( WN0 , S' , good_v);
%toc;

% plotp(WN0,[S;fit]), legend('Matrigel','Fit')
% %scatter(good_v, good_Abs)
% 
% a=2;






























































