function [Tprinc Pprinc] = NIPALS_easy(Y , NPC)
%
% Usage [Scores Loadings Var] = NIPALS_Paul_Bassan(Data , NoPCs);
% Data is your data matrix
% Center = 1, if you want matrix to be centered;
% NoPCs = Number of Principal Components required
% Variance is explained variance, not ready just yet...
%
%
% Written by Paul Bassan, University of Manchester
%
% Last revised 27th April, 2009.


[N K] = size(Y);

Tprinc = ones(N , NPC);
Pprinc = ones(K , NPC);

for j = 1 : NPC;
    
    T = Tprinc(:,j);
    d = 1;
    
    while d > 1e-5 %10e-12;
        %d
    
        P = (Y'*T); %/(T'*T);
        P = P / norm(P);
        Told = T;
        T = (Y*P)/(P'*P);
        d = norm(Told - T);
            
    end
    
    %temp1(j,:) = norm((Y'*T));
    
    Tprinc(:,j) = T;
    Pprinc(:,j) = P;
    Y = Y - T*P';
    
end



end % end of Nipals_easy


%Variance_0 = norm(Y);
%Variance_1 = Variance_0;
% Variance = norm(T*P');
% diff = Variance_1 - Variance;
% ExVar(j,:) = diff; %100 * (Variance_1 - Variance) / Variance_0;
% Variance_1 = Variance;

