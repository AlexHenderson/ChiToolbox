function [Data] = ls_norm( Ref ,  Data)

% Data & Ref have to be in rows spectra
% Not saisir format
% Usage: [Out] = ls_norm( Ref ,  Data)

[N K] = size(Data);
%out = zeros(K,N);


X = lscov(Ref',Data');


for i = 1 : N;
    Data(i,:) = Data(i,:) / X(i);
end

%out = Data;

end % end of ls_norm