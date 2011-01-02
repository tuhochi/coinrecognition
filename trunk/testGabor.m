%Bild-Pfad
imgPath='coin/euro/20cent/020__1999.jpg'

%Bild einlesen
img=imread(imgPath);
%Grauwertbild
imgGray=rgb2gray(img);
imgRotGray=imrotate(imgGray,45,'crop');
%Münze zentrieren
imgGray=cropCircle(imgGray,1,0);
imgRotGray=cropCircle(imgRotGray,1,0);

imshow(imgGray);
figure;
imshow(imgRotGray);

%Bildgröße
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
figure
imshow(imgPolar./255);
figure
imshow(imgRotPolar./255);
    






