function [ reImg ] = reconstructImg( coeff, columns )
%reconstructImg Durch DFT-Koeffizienten wird das Ausgangsbild wieder berechnet.  
%
%   reconstructImg(coeff,columns)
%                       Es wird das Urpsungsbild der DFT-Koeffizienten
%                       rekonstruiert. Dafuer ist es notwendig, die Groesse
%                       des Ursprungsbildes zu wissen.
%
%
% I/O Spec
%   coeff       Die berechneten Koeffizienten, die das Ursprungsbild
%               beschreiben.
%
%
%   columns     Die Groesse des Ursprungbildes.
%               
%
%   reImg       Das aus den DFT-Koeffizienten rekonstruierte Ursprungsbild.


index=linspace(1,size(coeff,2),size(coeff,2));
index=bsxfun(@minus,index,1);

reImg=[];
for row=1:size(coeff,1)
    reImgRow=[];
    for j=0:(columns-1)
        e=exp(2j*pi/columns*index*j);
        yj=coeff(row,:)*e';
        reImgRow=[reImgRow, yj];
    end
    reImg=[reImg; reImgRow];
end

reImg=abs(reImg);
end

