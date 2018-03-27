%%

function [q mod_par] = Mie_maths( R , S , W , NCOMP, Mie_Theory, GSP_flag , r_min , r_max , n_min , n_max , spacings)

q = S;

[N K] = size(S);

%%
%tt = toc;
if Mie_Theory == 1;
    [ZDis] = Mie_Smooth_Model(R);
elseif Mie_Theory == 2;
    [ZDis] = Mie_Hulst_Par(R, r_min , r_max , n_min , n_max , spacings);
    %[ZDis] = Mie_Hulst_Vectorised(R, r_min , r_max , n_min , n_max , spacings);
elseif Mie_Theory == 3;
    %[ZDis] = Make_Full_Mie_Model_Full_Vec(R);
    [Qext Qsca Qabs] = Full_Mie_Feb(R , 2 , 5 , 1.1 , 1.4 , 7, 1);
    ZDis = Qsca;
    
else
    error('Choose a method')
end
%disp(['Mie Matrix took ',num2str(toc-tt),' seconds'])

%% Decomposition and model building
%tt = toc;
[T P] = NIPALS_easy(ZDis.d , NCOMP);
%disp(['NIPALS took ',num2str(toc-tt),' seconds'])

model(:,1) = R.d';
model(:,2) = ones( length(R.d) , 1 );
model(:,3) = linspace( 0 , 1 , length(R.d) );
model(:,4:3+NCOMP) = P(:,1:NCOMP);


%% Gram-Schimd Process
%tt = toc;
if GSP_flag == 1;
    %model = Gram_Schmidt_Process(model);
    model = GSP(model,101);
end
%disp(['GSP ',num2str(toc-tt),' seconds'])
%% Least Squares Part

%tt = toc;
cons = lscov ( model , S.d' , W.d');
%cons = (S.d*model)';
%disp(['lscov ',num2str(toc-tt),' seconds'])

a = cons(2:end,:);
b = model( : , 2:end)';


scatter = a' * b;

mod_par.cons = cons;
mod_par.model = model;
mod_par.estimated = cons'*model';
mod_par.residual = S.d - mod_par.estimated;
mod_par.scatter = scatter;

q.d = S.d - scatter;

%q.d = ls_norm( R.d , q.d);


end % end of Mie_maths



























