function [coins] = getCoinsFromImage(image,radius,debug)
% Es wird mittels der hough-Transformation die einzelnen Coins gesucht und
% als Struct "coins" returnt
% diagonal ist der ungefaehr gesuchte radias

if(nargin==1) % wenn keine diagonale angegeben ist
    minR = 90
    maxR = 180    
else
    minR = round(radius*(1-0.39))
    maxR = round(radius*(1+0.39))
end

mergeDistance=mean([minR maxR])*2;

% grauwert-Bild laden
image=getGrayImage(image);


%Hough-Array
hough = zeros(size(image,1)+2*maxR, size(image,2)+2*maxR, maxR-minR+1);

%Für jeden Kreispunkt Px,Py liegt der mögliche Mittelpunkt innerhalb von
%[Px-maxR:Px+maxR, Py-maxR:Py+maxR]
%Daraus folgt das aufgespannte Gitter muss die größe [0:2*maxR, 0:2*maxR]
%haben
[GridX GridY]=meshgrid(0:(2*maxR), 0:(2*maxR));

%Berechnen der Radien für jeden Punkt innerhalb des Beobachtungsfensters
radiusGrid = round(sqrt((GridX-maxR).^2 + (GridY-maxR).^2));
%Entfernen der möglichen Radien, die außerhalb des gültigen Bereiches
%liegen
radiusGrid(radiusGrid<minR | radiusGrid>maxR) = 0;

%Kanten der Münzen ermitteln
kanten = edge(image,'canny',[0.15 0.2]);
%imshow(kanten)

%Indizes finden für erkannte Kantenpunkte
[kY kX]=find(kanten);
%Indizes finden für alle Kreispunkte und Radiuswert r
[mY mX r] = find(radiusGrid);

%Für jeden gefunden Kantenpunkt werden Kreise mit minR<=r<=maxR betrachtet
%und Hough-Array im entsprechenden Eintrag um 1 erhöht
percent5=floor(length(kX)/20);
pI=1;
for i=1:length(kX)
    i;
    index = sub2ind(size(hough), mY+kY(i)-1, mX+kX(i)-1, r-minR+1);
    hough(index)=hough(index)+1;
    
    if i>percent5*pI
        disp(['Hough-Transformation ' num2str(pI*5) '% completed']);
        pI=pI+1;
    end
end

%zwei PI
zweiPi = 0.9*pi*2;

%Kreis-Objekt mit [x y r **]
kreis=zeros(0,4);

%Für alle Radien wird der Umfang berechnet und der entsprechende Ausschnitt
%des Hough-Arrays wird betrachtet
for radius = minR:maxR
    umfang = zweiPi*radius;
    ausschnitt=hough( : , : , radius-minR+1);

    %Ausschnitt wird gelöscht wenn nicht genügend vom Kreis vorhanden ist
    ausschnitt(ausschnitt<umfang*0.27)=0;
    
    %Indizes der möglichen Kreismittelpunkte im Hough-Raum mit Akkumulator-
    %wert "a"
    [y x a]=find(ausschnitt);
    
    %Hinzufügen von Kreisobjekten [x y radius ???] ?????
    kreis=[kreis; [x-maxR, y-maxR, radius*ones(length(x),1), a*umfang]];
end

%Sortieren der Kreisobjekte
kreis=sortrows(kreis,-4);
i=1;

%Entfernen von ähnlichen Kreisen
while i<size(kreis,1)
    j=i+1;
    while j<=size(kreis,1)
        
        %Wenn der Abstand von Mx, My, Mr kleiner als mergeDistance Pixel ist, dann
        %werden diese Kreise entfernt
        if sum(abs(kreis(i,1:3)-kreis(j,1:3)))<= mergeDistance
            kreis(j,:)=[];
        else
            j=j+1;
        end
    end
    i=i+1;
end

kreis=sortrows(kreis,-3);


if(nargin>2)
%Originalbild
figure
imshow(image)
hold on;
end



%Zeichnen der Kreise
for i=1:size(kreis,1)
    
    if(nargin>2)
        x = kreis(i,1)-kreis(i,3);
        y = kreis(i,2)-kreis(i,3);
        d = 2*kreis(i,3);
        rectangle('Position',[x y d d], 'EdgeColor', 'green', 'Curvature', [1 1]);
    end
    
    % bild extrahieren
    r=kreis(i,3);
    y=kreis(i,1);
    x=kreis(i,2);
    coin=image(x-r:x+r,y-r:y+r,:);
    coin=cropCircle(coin,1);
    
    coins(i)={coin};
    
end

end

