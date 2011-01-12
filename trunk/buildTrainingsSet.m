function [] = buildTrainingsSet(inputType,coinRadius,subfolderEx,featureMode)

if nargin<1
    inputType='collection';
end

if nargin<2
coinRadius=135/4;
end

if nargin<3
    subfolderEx='_low';
else
    subfolderEx='';
end

if nargin<4
    featureMode='normal';
else


ordner=['coin/TrainingsData' subfolderEx];

addpath('tools/osu-svm');

%LabelingStructur
labelingStruct={'2euroV', 2;
                '1euroV', 1;
                '50centV', 0.5;
                '20centV', 0.2;
                '10centV', 0.1;
                '5centV', 0.05;
                '2centV', 0.02;
                '1centV', 0.01;
                '2euroR', 2;
                '1euroR', 1;
                '50centR', 0.5;
                '20centR', 0.2;
                '10centR', 0.1;
                '5centR', 0.05;
                '2centR', 0.02;
                '1centR', 0.01;};
save LabelStruct labelingStruct;
            
%Euclidische Dimension
maxDim=50;
%SVM Dimension
svmDim=15;

%TrainingsDaten einlesen

ordnerListing=dir(ordner);
ordnerSize=size(ordnerListing,1);

TrainingSetEuclid=[];
TrainingSetSVM=[];
LabelSet=[];
for i=3:ordnerSize
    
    %Klasse
    class=ordnerListing(i,1).name;
    if( realfile(class))
        
        %Label zur Klasse finden
        label=find(ismember(labelingStruct(:,1), class)==1);

        %Alle Dateien eines Ordners
        fileListing=dir([ordner '/' class]);

        for j=3:size(fileListing,1);
            
             %File
            readFile=fileListing(j,1).name;
            disp(['Ordner: ' class ' Datei: ' readFile]);
            if(realfile(readFile)) 

                %Pfad des Bildes
                imgPath=[ordner '/' class '/' fileListing(j,1).name];

                if strcmp(inputType, 'single')
                    %%
                    %SingelBild
                    %
                    %Bild einlesen
                    img=imread(imgPath);
                    %Grauwertbild
                    imgGray=rgb2gray(img);

                    %Bildgröße
                    [x y]=size(imgGray);
                    if mod(x,2)==0
                        imgGray = imresize(imgGray,size(imgGray)+1,'nearest');
                    end

                    [featureVeuclid featureVsvm]=buildFeatureVector(imgGray, maxDim, svmDim);

                    TrainingSetEuclid=[TrainingSetEuclid; featureVeuclid];
                    TrainingSetSVM=[TrainingSetSVM; featureVsvm];
                    LabelSet=[LabelSet; label];

                else
                %%
                %CollectionBild
                coins=getCoinsFromImage(imgPath,coinRadius);
                countOfCoins=size(coins,2);
                disp(['Anzahl der gefundenen Münzen: ' num2str(countOfCoins)]);
                disp('Berechnung der Koeffizienten');
                
                %Groesse der Muenze
                coinSize=[]; 
                for l=1:countOfCoins
                    l;
                    imgCoin=getGrayImage(coins{1,l});

                    %Bildgröße
                    [x y]=size(imgCoin);
                    if mod(x,2)==0
                        imgCoin = imresize(imgCoin,size(imgCoin)+1,'nearest');
                    end
                    
                    %Groesse der Muenze
                    coinSize=size(imgCoin,1);
                    
                    [featureVeuclid featureVsvm kCoeff]=buildFeatureVector(imgCoin, maxDim, svmDim);
                    
                    TrainingSetEuclid=[TrainingSetEuclid; featureVeuclid];
                    TrainingSetSVM=[TrainingSetSVM; featureVsvm];
                    LabelSet=[LabelSet; label];
                end
                
                %Mittlere Groesse der Muenze
                mCoinSize=mean(coinSize);

                end
               %% 
            end    
        end
    end
end

%Speichern des TrainingsSets
f=['TrainingSet-' datestr(now,'yyyy-mm-dd_HH-MM-SS')];
save(f,'TrainingSetEuclid', 'TrainingSetSVM', 'LabelSet');

%SVM Training
%svmConstruction(typeSVM, samples, labels)
svmConstruction(2, TrainingSetSVM', LabelSet');
   
end