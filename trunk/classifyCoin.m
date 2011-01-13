function [ coins labels result1 result2 ] = classifyCoin(coins,imgPath)
%CLASSIFYCOIN Summary of this function goes here
%   Detailed explanation goes here

%if nargin<3
%    colorMode=[0 1 2 3];
%end

if nargin<4
    featureMode='expanded';
end

addpath('tools/osu-svm');

%Anzahl der Coins
numberOfCoins=size(coins,2);

%Laden des SVM Klassifikators
load SVMClassifier

%Laden des Trainingssets f�r Euclidische Distanz
load TrainingSet-HALE-2011-01-13_14-27-28.mat

colorMode=svmFeatureMode(1,:);
featureMode=svmFeatureMode(2,1);

%Laden der Labeling-Struktur
load LabelStruct

%Euclidische Dimension
maxDim=50;
%SVM Dimension
svmDim=15;

%Groesse der Muenzen bestimmen
coinSize=[];
for i=1:numberOfCoins
    
    %Grauwertbild
    imgGray=getGrayImage(coins{1,i});
    
    %Bildgr��e
    [x y]=size(imgGray);
    if mod(x,2)==0
        imgGray = imresize(imgGray,size(imgGray)+1,'bilinear');
    end
    
    %Groesse der Muenze
    coinSize=[coinSize; size(imgGray,1)];
    
end

%%
%NORMIERUNG DER MUENZEN
%Groesste Muenze
maxCoinSize=max(coinSize);
coinSize=coinSize./maxCoinSize;


%FeatureVektor berechnen und klassifizieren
labels=[];
for i=1:numberOfCoins
    
    coloredFVeuclid=[];
    coloredFVsvm=[];
    for k=1:length(colorMode)
        
        %Grauwertbild bzw Farbwertbild
        imgGray=getGrayImage(coins{1,i},colorMode(k));

        %Bildgr��e
        [x y]=size(imgGray);
        if mod(x,2)==0
            imgGray = imresize(imgGray,size(imgGray)+1,'bilinear');
        end

        %Merkmalsvektor berechnen
        [featureVeuclid featureVsvm kCoeff]=buildFeatureVector(imgGray, maxDim, svmDim);
        coloredFVeuclid=[coloredFVeuclid featureVeuclid];
        coloredFVsvm=[coloredFVsvm featureVsvm];
    end
    
    %Groesse der Muenze
    cSize=coinSize(i);
    
    %ExtraFeature: Groesse
    if ~strcmp(featureMode,'normal')
        coloredFVeuclid=[coloredFVeuclid cSize];
        coloredFVsvm=[coloredFVsvm cSize];
    end
    
    %Euclidische Distanz Klassifikation
    dist=getFeatureDistance(coloredFVeuclid,TrainingSetEuclid);
    [value,index]=min(dist);
    euclidLabel=LabelSet(index);
    
    %SVM Klassifikation
    [svmLabel DecisionValue]=SVMClass(coloredFVsvm', AlphaY, SVs, Bias, Parameters, nSV, nLabel);
    
    %LabelCollection
    labels=[labels; euclidLabel svmLabel];
    
    %Label bei Cell adden
    coins(3,i)={[euclidLabel svmLabel]};
end

%Rechner
result1=calculator(labels(:,1));
disp(['Euclidische Klassifizierung:' result1]);
result2=calculator(labels(:,2));
disp(['SVM Klassifizierung:' result2]);

%Ergebnis anzeigen
figure
img=imread(imgPath);
imshow(img);
hold on
for i=1:size(coins,2)
    circleData=coins{2,i};
    rectangle('Position',[circleData(1) circleData(2) circleData(3) circleData(3)], 'EdgeColor', 'red', 'Curvature', [1 1],'LineWidth',2);
    text(circleData(4)+10,circleData(5)+13,[labelingStruct(coins{3,i}(1))],'Color','black','BackgroundColor','yellow')
    text(circleData(4)+10,circleData(5)-13,[labelingStruct(coins{3,i}(2))],'Color','black','BackgroundColor','magenta')
end

text(15,15,result2,'Color','black','BackgroundColor','white')
hold off

end

