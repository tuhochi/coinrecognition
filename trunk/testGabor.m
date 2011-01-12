%Bild-Pfad
imgPath='coin/euro/2euro/2007.jpg'% gute Belichtung
imgPath='coin/euro/2euro/AT_2002_4.jpg'% dunkel Belichtet
imgPath='coin/euro/2euro/AT_2002_5.jpg'% verrostet

imgPath='coin/euro/2euro/1999.jpg'

imgPath='coin/euro/20cent/020__1999.jpg'

%imgPath='coin/testcoin.png'% Muenze vom Paper

%Bild einlesen
img=imread(imgPath);
%Grauwertbild
imgGray=rgb2gray(img);
imgRotGray=imrotate(imgGray,45,'crop');
%M�nze zentrieren
imgGray=cropCircle(imgGray,1,0);
imgRotGray=cropCircle(imgRotGray,1,0);

imshow(imgGray);
figure;
imshow(imgRotGray);

%Bildgr��e
[x y]=size(imgGray);
if mod(x,2)==0
    imgGray = imresize(imgGray,size(imgGray)+1,'nearest');
end
[x y]=size(imgGray);
x=1:x;
y=1:y;

%%
%Rotiertes Bild
[x1 y1]=size(imgRotGray);
if mod(x1,2)==0
    imgRotGray = imresize(imgRotGray,size(imgRotGray)+1,'nearest');
end
[x1 y1]=size(imgRotGray);
x1=1:x1;
y1=1:y1;
%%

imgPolar=imgCartToLogpolar(imgGray);
imgRotPolar=imgCartToLogpolar(imgRotGray);

% Polartransformiete Bilder muessen noch zugeschnitten werden (y-Achse)
d=round((size(imgPolar,1)-(size(imgPolar,1)/sqrt(2)))/4  *1.2);% Abstand auf der Y Achse (unten und oben)// +20%
imgPolar=imgPolar(d:end-d,:);
imgRotPolar=imgRotPolar(d:end-d,:);


figure
imshow(imgPolar./255);
figure
imshow(imgRotPolar./255);

%%
%DFT-Koeffizienten
coeffCount=15;
coeff=calcCoeff(imgPolar,coeffCount);
reImg=reconstructImg(coeff,size(imgPolar,2));
figure
imshow(reImg./255);

%% So koennte es gehn? Damit ich nur einen Vektor bekommen hab ich einfach die 2 Dimension aufsummiert.
%% Das Ergebnis schaut nicht schlecht aus aber nicht wie im Paper!

% neue Skallierung auf 50x50
% imgPolarS=imresize(imgPolar,[50,50],'bilinear');
% imgRotPolarS=imresize(imgRotPolar,[50,50],'bilinear');
% 
% figure
% title('Fourier-Koeffizienten')
% s=sum(abs(log(fft(imgPolarS(:,:)))),2);
% plot(s(2:26));% ab 27 wiederholen sich die Informationen, wie im Paper ab ca Wert 33, deshalb hier abgeschnitten
% hold on
% s=sum(abs(log(fft(imgRotPolarS(:,:)))),2);
% plot(s(2:26));


%k-Kreise berechnen
maxR = size(imgPolar,1);
K=10; %Anzahl der Kreise
f=[];
for i=1:K
    k(i,:)=int16([(i-1)/K*maxR+1 i/K*maxR]);
    %Koeffizienten pro Kreis
    %kCoeff=[kCoeff; abs(fft(imgPolarS(k(i,1):k(i,2),:)))];
    kCoeff=coeff(k(i,1):k(i,2),:);
    %Mittelwert und Standardabweichung
    m=mean(kCoeff);
    v=var(kCoeff);
    %Summe
    s=sum(kCoeff);
    f=[f m v];
end








%plot(abs(fftshift(fft2(imgRotPolar(:,:),50,50)))');
%plot(abs(fftshift(fft2(imgPolar(541:550,:),50,50))));
    
%r=abs(fft2(imgRotPolar(541:550,:),50,50));
% plot(r(:,1))






