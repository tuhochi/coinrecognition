function [ newimage ] = whitePatch(image,gaussSize)
%whitePatch TrainingSet wird eingelesen und Klassifikatoren trainiert.  
%
%   whitePatch(image)
%                       Dieser whitePatch Algoritmus ist so impementiert,
%                       dass zuerst auf das Eingangsbild (image) ein
%                       Gaussfilter angewendet wird (blur), um eine
%                       gleichmaessigere Lichtintensitaet im Bild zu
%                       erhalten. Danach wird eine Kopie des Eingangsbildes
%                       erstellt und mittels den min und max Werten des
%                       blur Images passend skaliert.
%                      
% I/O Spec
%   image   Eingangsbild auf dem der WhitePatch angewendet wird
%
%   gaussSize   Mittlerer Radius der zu erkennenden Muenzen.
%% Eingangsparameter ueberpruefen
if nargin<2
    gaussSize=30;
end

if ischar(image)
    image = imread(image);
end

%% geblurtes Image ertellen
h = fspecial('gaussian',gaussSize,gaussSize);
blur=imfilter(image,h);

mi(1:3)=min(min(blur(:,:,:)));
ma(1:3)=max(max(blur(:,:,:)));
%% Bild skallieren
newimage=image;
newimage(:,:,1) = newimage(:,:,1)-mi(1);
newimage(:,:,2) = newimage(:,:,2)-mi(2);
newimage(:,:,3) = newimage(:,:,3)-mi(3);

newimage(:,:,1) = newimage(:,:,1).*(255/double(ma(1)));
newimage(:,:,2) = newimage(:,:,2).*(255/double(ma(2)));
newimage(:,:,3) = newimage(:,:,3).*(255/double(ma(3)));

end

