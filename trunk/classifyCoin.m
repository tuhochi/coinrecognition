function [ coins labels result1 result2 ] = classifyCoin(coins,imgPath)
%CLASSIFYCOIN Summary of this function goes here
%   Detailed explanation goes here

addpath('tools/osu-svm');

%Anzahl der Coins
numberOfCoins=size(coins,2);

%Laden des SVM Klassifikators
load SVMClassifier

%Laden des Trainingssets f�r Euclidische Distanz
load TrainingSet-2011-01-11_19-40-24

%Laden der Labeling-Struktur
load LabelStruct

%Euclidische Dimension
maxDim=50;
%SVM Dimension
svmDim=15;

labels=[];
for i=1:numberOfCoins
    
    %Grauwertbild
    imgGray=coins{1,i};
    
    %Merkmalsvektor berechnen
    [featureVeuclid featureVsvm kCoeff]=buildFeatureVector(imgGray, maxDim, svmDim);
    
    %Euclidische Distanz Klassifikation
    dist=getFeatureDistance(featureVeuclid,TrainingSetEuclid);
    [value,index]=min(dist);
    euclidLabel=LabelSet(index);
    
    %SVM Klassifikation
    [svmLabel DecisionValue]=SVMClass(featureVsvm', AlphaY, SVs, Bias, Parameters, nSV, nLabel);
    
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
