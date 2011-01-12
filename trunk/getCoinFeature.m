function [feature] = getCoinFeature(img)
% Diese Methode berechnet einen Feature-Vector eines uebergebenen Grauwert-Bildes

if size(img,3)~=1
    error('Es darf nur ein Grauwertbild uebergeben werden!');
end

if size(img,1)~=size(img,2)
    error('Das Bild muss quadratisch sein!');
end

% Bildgroesse fuer die Rotation auf ungerade skalieren
[x y]=size(img);
if mod(x,2)==0
    img = imresize(img,size(img)+1,'bilinear');
end
% logarithmische Polar Transformation
polar=imgCartToLogpolar(img);

% Zuschnitt des Polar-Bildes. Abstand auf der y Achse (unten und oben)// +40%
d=round((size(polar,1)-(size(polar,1)/sqrt(2)))/4  *1.4);
polar=polar(d:end-d,:);

% neue Skallierung auf 50x50
polar=imresize(polar,[60,60],'bilinear')
imgPolarS=imresize(polar,[50,50],'bilinear');
%imshow(imgPolarS,[])
f=abs(log(fft(imgPolarS(:,:))));
s=sum(f,2);
% ab 27 wiederholen sich die Informationen, deshalb hier abgeschnitten
feature=s(2:26);

end

