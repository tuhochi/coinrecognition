clear all;

%Name der Image-Datei
imgName ='coin/shoot/IMG_6838.jpg';
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
        if sum(abs(kreis(i,1:3)-kreis(j,1:3)))<= 80
            kreis(j,:)=[];
        else
            j=j+1;
        end
    end
    i=i+1;
end

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

text(kreis(:,1),kreis(:,2),num2str(   kreis(:,3)./max(kreis(:,3))     ));
 text(kreis(:,1),kreis(:,2)+10,num2str(   kreis(:,3)./max(kreis(:,3))*25.75     ))
 text(kreis(:,1),kreis(:,2)-10,num2str(   kreis(:,3)     ))
 
 %imshow(image(225-54:225+54,452-54:452+54,:))
 
 
% 50Cent
%r=49;  % rel=-0.13
%coin=image(124-r:124+r,480-r:480+r,:);
% r_gross =  123.0543
% g_gross =  107.2787
% b_gross =   67.0601
% 
% r_klein =  139.0016
% g_klein =  125.0536
% b_klein =   84.7873


%1Euro
% r=50; % rel= 0.2411
% coin=image(316-r:316+r,131-r:131+r,:);
% r_gross =  141.6383
% g_gross =  126.2125
% b_gross =   92.2179
% 
% r_klein =  107.6117
% g_klein =  103.9666
% b_klein = 96.4292

%2Euro 
r=54;  %rel= -0.59
coin=image(225-r:225+r,452-r:452+r,:);
% r_gross =   95.7114
% g_gross =   93.6355
% b_gross =   85.9891
% 
% r_klein =  151.3284
% g_klein =  141.7866
% b_klein =  113.0519
  
[u v]= meshgrid(0:2*r,0:2*r);
p=zeros(1,1,3);

matrix=(round(sqrt(  (r-u).^2+ (r-v).^2))<r*0.95)
p(1:size(matrix,2),1:size(matrix,2),1)=matrix;
p(1:size(matrix,2),1:size(matrix,2),2)=matrix;
p(1:size(matrix,2),1:size(matrix,2),3)=matrix;
lll=times(double(coin),double(p));

matrix=(round(sqrt(  (r-u).^2+ (r-v).^2))<r*0.8)
p(1:size(matrix,2),1:size(matrix,2),1)=matrix;
p(1:size(matrix,2),1:size(matrix,2),2)=matrix;
p(1:size(matrix,2),1:size(matrix,2),3)=matrix;
ll=times(double(coin),double(p));

ringgross=lll-ll;
r_gross=mean(ringgross(find(ringgross(:,:,1)>0)))
g_gross=mean(ringgross(size(ringgross,1)*size(ringgross,1)+find(ringgross(:,:,2)>0)))
b_gross=mean(ringgross(size(ringgross,1)*size(ringgross,1)*2+find(ringgross(:,:,3)>0)))

matrix=(round(sqrt(  (r-u).^2+ (r-v).^2))<r*0.5);
p(1:size(matrix,2),1:size(matrix,2),1)=matrix;
p(1:size(matrix,2),1:size(matrix,2),2)=matrix;
p(1:size(matrix,2),1:size(matrix,2),3)=matrix;

ringklein=times(double(coin),double(p));
r_klein=mean(ringklein(find(ringklein(:,:,1)>0)))
g_klein=mean(ringklein(size(ringklein,1)*size(ringklein,1)+find(ringklein(:,:,2)>0)))
b_klein=mean(ringklein(size(ringklein,1)*size(ringklein,1)*2+find(ringklein(:,:,3)>0)))


m_gross=mean([r_gross,g_gross,b_gross])
m_klein=mean([r_klein,g_klein,b_klein])




if((r_gross-r_klein)/r_gross)
    disp('2Euro');
else
    disp('1Euro');
end


imshow( ringgross./256);







