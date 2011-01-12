function [ coeff ] = calcCoeff( img,coeffCount )
%CALCCOEFF Summary of this function goes here
%   Detailed explanation goes here

%figure
%title('Originalbild')
%imshow(img./255);

%Index der Spalten pro Zeile
index=linspace(1,size(img,2),size(img,2));
index=bsxfun(@minus,index,1);

coeff=[]; %Koeffizienten
for row=1:size(img,1)
    coeffRow=[]; %Koeffizienten einer Zeile
    for k=0:(coeffCount-1)
        %Einheitswurzel
        e=exp(-2j*pi/size(img,2)*k*index); 
        %Koeffizient ck
        coeffK=1/size(img,2)*(img(row,:)*e'); 
        coeffRow=[coeffRow, coeffK];
    end
    coeff=[coeff; coeffRow];
end


end

