function [Minima]=SelectMinima(ZSaisir,window);
%SelectMinima             - find all minima in a saisir structure
%                           using a window
%
% [Minima]=SelectMinima(ZSaisir,window);
%
% uses the function:   FindMinima
%
%


[N M]=size(ZSaisir.d);

MinWaveNum=[];
for i=1:N
    New=[];
    [New]=FindMinima(ZSaisir.d(i,:),window);
    MinWaveNum=[MinWaveNum,New];
end

[N M]=size(MinWaveNum);
MinWaveNum=sort(MinWaveNum);




b=-1;
k=0;
MinWaveNumRed=[];
for i=1:M
    a=MinWaveNum(i);
    if (a~=b)
        k=k+1;
        MinWaveNumRed(k)=MinWaveNum(i);
        b=MinWaveNumRed(k);
    end
end

Minima=MinWaveNumRed;
