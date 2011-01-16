function [ coeff ] = calcCoeff(img,coeffCount)
%calcCoeff Eine bestimmte Anzahl an DFT-Koeffizienten eines Bildes werden berechnet.  
%
%   calcCoeff(img,coeffCount)
%                       Fuer ein Bild (Polar-Koordinaten) werden eine
%                       bestimmte Anzahl an DFT-Koeffizienten berechnet.
%                       Die Koeffizienten werden immer pro Bildzeile
%                       berechnet.
%                       Mit diesen Koeffizienten ist es moeglich das
%                       Ursprungsbild wiederherzustellen.
%
%
% I/O Spec
%   img         Bild von dem die DFT-Koeffizienten gesucht sind.
%               
%
%   coeffCount  Bestimmt die Anzahl der gewuenschten DFT-Koeffizienten.
%
%
%   coeff       Die berechneten Koeffizienten, die das Ausgangsbild
%               beschreiben.


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

