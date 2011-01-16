function [Ipol] = imgCartToLogpolar(img,polarType,fill,scalefactor,interpMethod)
%imgCartToLogpolar Wandelt ein Bild von der kartesischen in die Log-Polar Darstellung um 
%
%   imgCartToLogpolar(img,polarType,fill,scalefactor,interpMethod)
%                       Hierbei werden bezueglich des Bildmittelpunktes die
%                       einzelnen Pixel-Koordinaten in Betrag und Phase
%                       umgerechnet und als Log-Polar-Bild zurueckgeliefert
%
%
% I/O Spec
%   img             Eingangsbild
%
%   polarType       Intervallschritte der einzelnen neuen Achsen im
%                   Polar-Koordinatensystem
%                   'logpolar':     Log-Polar
%                   '':             nicht Logarithmisch
%               
%   fill            0:          default, 2-D data interpolation interp2
%
%   scalefactor     Dimension des Bildes dargestellt in Polar-Koordinaten
%                   1:          default
%
%   interpMethod    'linear':   default, 2-D data interpolation interp2


%Interpolations-Methode
if nargin<5 || isempty(interpMethod)
    interpMethod='linear'; 
end 
%Wert mit dem nichtvorhandene Werte gefüllt werden
if nargin<4 || isempty(fill)
    fill=0; 
end
%Skalierungsfaktor
if nargin<3 || isempty(scalefactor)
    scalefactor=1;
%     if strcmp(polarType, 'logpolar') || strcmp(polarType, 'polar')
%        polarType='logpolar';
%        disp('polarType wurde auf logpolar gesetzt.');
%     end
end
%Polar oder Log-Polar
if nargin<2 || isempty(polarType)
    polarType='logpolar';
end

%Größe des Ursprungbildes
imgSize=size(img);
%x und y Ausdehnung des Ursprungbildes
width=size(img,2); 
height=size(img,1);

%Groesste Dimension des Ursprungbildes
maxDim=max(imgSize);
maxRadius=sqrt(sum((imgSize(1:2)/2).^2));

%Dimension des Bildes dargestellt in Polar-Koordinaten
newImgDim=scalefactor*maxDim;

%Intervallschritte der einzelnen neuen Achsen im Polar-Koordinatensystem
if strcmp(polarType, 'logpolar')
    radiusRange=logspace(0,log10(maxRadius),newImgDim);
else
    radiusRange=linspace(0,maxRadius,newImgDim);
end
thetaRange=linspace(-pi,pi,newImgDim);
 
[TH,R]=meshgrid(thetaRange,radiusRange);
[x,y]=pol2cart(TH,R);
Ipol=interp2(double(img),x+width/2,y+height/2,interpMethod,fill);

end

