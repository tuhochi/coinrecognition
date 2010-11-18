clear all;
tic
disp('start ');

%Name der Image-Datei
imgName ='coin/shoot/IMG_6833.jpg';
minR = 20;
maxR = 100;

%Laden des Images
image = imread(imgName);

%GrauwertBild
gwImage=rgb2gray(image);

%imshow(gwImage)

%Hough-Array
hough = zeros(size(gwImage,1)+2*maxR, size(gwImage,2)+2*maxR, maxR-minR+1);

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
kanten = edge(gwImage,'canny',[0.15 0.2]);

%Indizes finden für erkannte Kantenpunkte
[kY kX]=find(kanten);
%Indizes finden für alle Kreispunkte und Radiuswert r
[mY mX r] = find(radiusGrid);

%Für jeden gefunden Kantenpunkt werden Kreise mit minR<=r<=maxR betrachtet
%und Hough-Array im entsprechenden Eintrag um 1 erhöht
for i=1:length(kX)
    i;
    index = sub2ind(size(hough), mY+kY(i)-1, mX+kX(i)-1, r-minR+1);
    hough(index)=hough(index)+1;
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
    ausschnitt(ausschnitt<umfang*0.33)=0;
    
    %Indizes der möglichen Kreismittelpunkte im Hough-Raum mit Akkumulator-
    %wert "a"
    [y x a]=find(ausschnitt);
    
    %Hinzufügen von Kreisobjekten [x y radius ???] ?????
    kreis=[kreis; [x-maxR, y-maxR, radius*ones(length(x),1), a/umfang]];
end

%Sortieren der Kreisobjekte
kreis=sortrows(kreis,-4);
i=1;

%Entfernen von ähnlichen Kreisen
while i<size(kreis,1)
    j=i+1;
    while j<=size(kreis,1)
        
        %Wenn der Abstand von Mx, My, Mr kleiner als 36 Pixel ist, dann
        %werden diese Kreise entfernt
        if sum(abs(kreis(i,1:3)-kreis(j,1:3)))<= 60
            kreis(j,:)=[];
        else
            j=j+1;
        end
    end
    i=i+1;
end

kreis=sortrows(kreis,-3);


%Originalbild
figure
imshow(image)
hold on;

%Zeichnen der Kreise
for i=1:size(kreis,1)
    x = kreis(i,1)-kreis(i,3);
    y = kreis(i,2)-kreis(i,3);
    d = 2*kreis(i,3);
    rectangle('Position',[x y d d], 'EdgeColor', 'green', 'Curvature', [1 1]);
end

text(kreis(:,1),kreis(:,2)-10,num2str(   kreis(:,3)     ))
%text(kreis(:,1),kreis(:,2),num2str(   kreis(:,3)./max(kreis(:,3))     ));
%text(kreis(:,1),kreis(:,2)+10,num2str(   kreis(:,3)./max(kreis(:,3))*25.75     ))

 
rgb= coindetection(image,kreis);
 %imshow(image(225-54:225+54,452-54:452+54,:))
figure
bar(rgb(:,[1 4 2 5 3 6]))
colormap(hsv(3))

figure;
colormap(hsv(3));
relrgb=(rgb(:,[1 2 3])-rgb(:,[4 5 6]))./rgb(:,[1 2 3]);
bar( relrgb   );

% relative Werte zwischen rot und blau sind aussagekräftig für 1 und 2 Euro
% Münzen
% IMG_6833 ab  keine
%relrb=relrgb(:,1)./-abs(relrgb(:,3)).*abs(mean(relrgb,2)).*10;



%% wenn die groesste muenze eine 2 euro muenze ist, dann ist der minimale Radius der 2 Euro Muenzen:

disp('----------------------------------------')
%relrb=abs((relrgb(:,1))-(relrgb(:,3)))*6.6;

% fure 1/2 euro innen aussenkreis Entscheidung
relrb=abs((relrgb(:,1))-(relrgb(:,3))).*abs((relrgb(:,1))-(relrgb(:,2))).*300;

% fure Cent 10/20/50 Cent Unterscheidung
avrgb=(rgb(:,[1 2 3])+rgb(:,[4 5 6]))./2;
t=(avrgb./[avrgb(:,2) avrgb(:,2) avrgb(:,2) ]);
t=(t(:,1).^t(:,2))-0.15;

minr12euro=kreis(1,3);


for i=1:size(rgb,1)
    r=kreis(i,3);% aktueller Muenzen radius
    disp(['Muenze Nummer:',num2str(i),' r=',num2str(r)]);
    
    if relrb(i)>1 & r>= minr12euro
    %disp('...ist eine 1 oder 2 Euro Muenze')
    
    if minr12euro==kreis(1,3)
         minr12euro=r*0.85;
    end
   
        if(relrgb(i,1)>relrgb(i,3))
            disp('1 Euro Muenze')
        else
            disp('2 Euro Muenze')            
        end

    else
        if(t(i)<1)
            disp('10/20/50 Cent Muenze')
        else
           disp('1/2/5 Cent Muenze')
        end

    end
end
    









toc

