function [WN_out ZCorr history] = RMieS_EMSC_v5(WN, ZRaw, correction_options , WN_Ref_in , Ref_in)
    


%% Designate correction options

desired_res = correction_options(1);
lower_WN = correction_options(2);
upper_WN = correction_options(3);
iterations = correction_options(4);
mie_theory = correction_options(5);
NCOMP = correction_options(6);
r_min = correction_options(7);
r_max = correction_options(8);
n_min = correction_options(9);
n_max = correction_options(10);
spacings = correction_options(11);
GSP_flag = correction_options(12);
ref_option = correction_options(13);

%% Sort out resolution

WN = make_column(WN);

if desired_res > 0
    [WN ZRaw] = new_res(WN , ZRaw , desired_res);
end


[a b] = find_value_min_max( WN , lower_WN , upper_WN);

WN = WN(a:b);
ZRaw = ZRaw(:,a:b);

[N K] = size(ZRaw);
spectra_names = num2str( [1:N]' );

%% Reference spectrum

if nargin == 3;
    if ref_option == 1;
        load Matrigel_Reference_Raw
        ZRef = spline( ZRef_Raw(:,1) , ZRef_Raw(:,2) , WN )'; clear ZRef_Raw
    elseif ref_option == 2;
        load Simulated_ZRef_Raw; 
        ZRef = spline( ZRef_Raw(:,1) , ZRef_Raw(:,2) , WN )'; clear ZRef_Raw
    else
        error('No reference spectrum option selected')
    end
end



if nargin == 5;
    
    if length(WN) == length(WN_Ref_in)
        ref_length_check = 1;
    else
        ref_length_check = 0;
    end
    
    if ref_length_check == 0;        
        ZRef = spline( WN_Ref_in , Ref_in , WN )';
    end
end


ZRef = ZRef/max(ZRef);

%% Make Saisir Structures & Weights

temp = ZRaw; clear ZRaw;

ZRaw.d = temp; clear temp;
ZRaw.v = num2str(WN);
ZRaw.i = spectra_names;

temp = ZRef; clear ZRef
ZRef.d = temp;
ZRef.v = ZRaw.v;
ZRef.i = 'Ref';

initial_ref = ZRef;

ZWeightsSpec = Spectrum_Weights(ZRaw);

ZWeightsSpec = Down_weight_spectrum(ZWeightsSpec , 2300 , 2400 , 0.01);

if mie_theory == 1;
    ZWeightsSpec = Down_weight_spectrum(ZWeightsSpec , 1500 , 2000 , 0.01);
end

if iterations > 1;
    history = zeros(N , K , iterations);
    
end

%% Correction

if mie_theory == 1
    [ZCorr] = Mie_maths( ZRef , ZRaw , ZWeightsSpec , ...
        NCOMP, mie_theory, GSP_flag , r_min , r_max , n_min , n_max , spacings);
    history = ZCorr.d;
elseif mie_theory == 2
    [ZCorr mod_para] = Mie_maths( ZRef , ZRaw , ZWeightsSpec , ...
        NCOMP, mie_theory, GSP_flag , r_min , r_max , n_min , n_max , spacings);
    history(:,:,1) = ZCorr.d;
    res_hist(:,:,1) = mod_para.residual;
    
    if iterations > 1
        
            

        
        for j = 1 : N

            ZRaw2.d = ZRaw.d(j,:);

            for i = 2 : iterations
                try

                    ZRef.d = history(j,:,i-1);

                    %ZRef.d = fit_gauss_whole_spec( WN , ZRef.d')';
                    ZRef.d = fit_gauss_whole_spec_split( WN , ZRef.d')';


                    %ZRef.d = rb_v5( WN , ZRef.d );


                    %ZRef.d = build_spectrum_split(WN , ZRef.d , 15 , -0.005);
                    %ZRef.d = abs(ZRef.d);


                    [ZCorr mod_para] = Mie_maths( ZRef , ZRaw2 , ZWeightsSpec , ...
                        NCOMP, mie_theory, GSP_flag , r_min , r_max , n_min , n_max , spacings);
                    history(j,:,i) = ZCorr.d;


                    disp(['Spectrum ',num2str(j),' Iteration ',num2str(i),'  ', datestr(now)])
                end
            end

            ZCorr.d = history(:,:,end);
            disp(' ')
        end
    
    end
    
end


ZCorr.d = history(:,:,end);

WN_out = WN;
ZCorr = ZCorr.d;





end % end of function











