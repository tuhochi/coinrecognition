function [] = buildTrainingsSet(inputType,coinRadius,subfolderEx,colorMode,featureMode,testMode)
%buildTrainingsSet TrainingSet wird eingelesen und Klassifikatoren trainiert.  
%
%   demoCoinRecognition(inputType,coinRadius,subflderEx,colorMode,featureMode,testMode)
%                       Das Trainingsset wird aus dem Ordner
%                       'TrainingsData' eingelsen. Falls es sich um ein
%                       Sammelbild (mehrere Muenzen auf einem Bild)
%                       handelt, werden diese zuerst segmentiert. Aus den
%                       einzelnen Muenzbilder werden Features berechnet und
%                       im TrainingSet abgespeichert. Für die beiden
%                       Klassifikatoren (SVM und Euklidischer Abstand)
%                       werden zwei separate TrainingSets angelegt. Die Art
%                       der Features unterscheiden sich dabei nicht,
%                       sondern nur die Laenge der FeatureVektoren.
%
% I/O Spec
%   inputType    'single': Im Ordner 'TrainingsData' befinden sich nur
%                          Bilder, die je Bild nur eine Muenze beinhalten.
%
%                'collection': Im Ordner 'TrainingsData' befinden sich
%                              Bilder, die auch mehrere Muenzen beinhalten koennen.
%
%   coinRadius   Mittlerer Radius der zu erkennenden Muenzen.
%
%
%   subfolderEx  '_low': Es werden nur Bilder mit niedriger Aufloesung
%                        herangezogen (kurze Berechnungszeit).
% 
%                '_medium': Es werden nur Bilder mit mittlerer Aufloesung
%                           herangezogen (lange Berechnungszeit).
% 
% 
%   colorMode   ein Vektor der die zu verwendeten Farbkanaele angibt
%               0: Grau-Kanal
%               1: Rot-Kanal
%               2: Gruen-Kanal
%               3: Blau-Kanal
% 
% 
%   featureMode 'normal': Nur DFT-Koeffizienten der gewaehlten Farb-Kanaele
%                         werden in dden Feature-Vektor aufgenommen.
%
%               'extended': Zu den DFT-Koeffizienten der gewaehlten
%                           Farb-Kanaele wird die Groesse der segmentierten Muenze in
%                           den Feature-Vektor aufgenommen.
%
%   testMode    Das TrainingSet wird fuer die CrossValidation gesondert
%   abgespeichert: 'PC-PCName-Crossval.mat'
%               0      off
%               1      on  


buildTrainingsSetTime= tic();

if nargin<1
    inputType='collection';
end


if nargin<3
    %Bilder mit niedrigster Auflösung
    subfolderEx='_low';
end

if nargin<4
    %Grauwertbilder
    colorMode=[0 1 2 3];
end
if nargin<5
    %Nur Koeffizienten
    featureMode='extended';
end

if nargin<6
    %testMode
    testMode=0;
end

switch subfolderEx
    case '_low'
        coinRadius=135/4
    case '_medium'
        coinRadius=135/2
    case ''
        coinRadius=135
end

svmFeatureMode(1,:)=colorMode;
svmFeatureMode(2,:)=strcmp(featureMode,'extended');

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
    %if( realfile(class) && strcmp(class,'2euroV'))
        
        %Label zur Klasse finden
        label=find(ismember(labelingStruct(:,1), class)==1);

        %Alle Dateien eines Ordners
        fileListing=dir([ordner '/' class]);
        
        %Groesse aller Muenzen einer Klasse
        allCoinSize=[];
        for j=3:size(fileListing,1);
            
             %File
            readFile=fileListing(j,1).name;
            
            
            if(realfile(readFile) ) % && strcmp(readFile,'2eurokopf.jpg')
            disp(['Ordner: ' class ' Datei: ' readFile]);

                %Pfad des Bildes
                imgPath=[ordner '/' class '/' fileListing(j,1).name];
                %imgPath='coin/euro/2euro/AT_2002.png';
                
                if strcmp(inputType, 'single')
                    %%
                    %SingelBild
                    %
                    %Bild einlesen
                    img=imread(imgPath);
                    
                    coloredFVeuclid=[];
                    coloredFVsvm=[];
                    for k=1:length(colorMode)
                        
                        %Umwandlung in Grauwert oder Farbbild
                        imgGray=getGrayImage(img,colorMode(k));
                        
                        figure
                        disp('Farbbild: buildTrainingSet')
                        imshow(imgGray,[])
                        
                        %Bildgröße
                        [x y]=size(imgGray);
                        if mod(x,2)==0
                            imgGray = imresize(imgGray,size(imgGray)+1,'bilinear');
                        end
                        
                        %Erstellen des FeatureVektors
                        [featureVeuclid featureVsvm]=buildFeatureVector(imgGray, maxDim, svmDim);
                        coloredFVeuclid=[coloredFVeuclid featureVeuclid];
                        coloredFVsvm=[coloredFVsvm featureVsvm];
                    end
                    
                    TrainingSetEuclid=[TrainingSetEuclid; coloredFVeuclid];
                    TrainingSetSVM=[TrainingSetSVM; coloredFVsvm];
                    LabelSet=[LabelSet; label];
                    
                    %Groesse der Muenze
                    mCoinSize=size(imgCoin,1);
                    allCoinSize=[allCoinSize; mCoinSize];

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
                    
                    coloredFVeuclid=[];
                    coloredFVsvm=[];
                    for k=1:length(colorMode)
                        
                        %Umwandlung in Grauwert oder Farbbild
                        imgCoin=getGrayImage(coins{1,l},colorMode(k));
                        
                        %Ausgabe der Polarbilder
                        if strcmp(imgPath,'coin/TrainingsData_low/2euroV/2eurozahl.jpg') && l==1;
                            figure
                            title('Münze dargestellt in Polar-Koordinaten')
                            disp('Polarbild der Münze des entsprechenden Farbkanals')
                            imshow(imgCoin,[])
                         end
                        
                        %Bildgröße
                        [x y]=size(imgCoin);
                        if mod(x,2)==0
                            imgCoin = imresize(imgCoin,size(imgCoin)+1,'bilinear');
                        end
                        
                        %Erstellen des FeatureVektors
                        [featureVeuclid featureVsvm kCoeff]=buildFeatureVector(imgCoin, maxDim, svmDim);
                        
                        coloredFVeuclid=[coloredFVeuclid featureVeuclid];
                        coloredFVsvm=[coloredFVsvm featureVsvm];

                    end
                    
                    %Groesse der Muenze
                    coinSize=[coinSize; size(imgCoin,1)];
                    
                    TrainingSetEuclid=[TrainingSetEuclid; coloredFVeuclid];
                    TrainingSetSVM=[TrainingSetSVM; coloredFVsvm];
                    LabelSet=[LabelSet; label];
                end
               
                
                %Mittlere Groesse der Muenze
                mCoinSize=mean(coinSize);
                allCoinSize=[allCoinSize; mCoinSize];
                
                end
               %% 
            end    
        end
        
        %Groesse Aufnehmen
        cSize(label,1)=(mean(allCoinSize));
    end
end

%Normieren der Groesse
sortCSize=sort(cSize);
mMaxCoinSize=mean(sortCSize(end-1:end));
%maxCoinSize=max(cSize);

cSize=cSize./mMaxCoinSize;

%cSiZe=floor(cSize*100)/100;

for i=1:size(cSize)
    labelingStruct(i,3)={cSize(i)};
end

%% Mitteln der normierten Coin Vorder/Rueck-Seiten

% struct to vector
v=[];
for i=1:size(labelingStruct,1)
    v=[v;labelingStruct{i,3}];
end
% normieren
eps=0.009;% ab diesen relativen Radius diff-Wert werden zwei Muenzen als gleich erkannt
for i=1:size(labelingStruct,1)
    v(abs(v-v(i))<eps)=mean(v(abs(v-v(i))<eps));
end
% nun in struct ersetzen
for i=1:size(labelingStruct,1)
    labelingStruct{i,3}=v(i);
end

%%
%ExtraFeature: Groesse
if ~strcmp(featureMode,'normal')
    for i=1:size(labelingStruct)
        if i==1
            TrainingSetSVM(find(LabelSet==i),end+1)=labelingStruct{i,3};
            TrainingSetEuclid(find(LabelSet==i),end+1)=labelingStruct{i,3};
        else
            TrainingSetSVM(find(LabelSet==i),end)=labelingStruct{i,3};
            TrainingSetEuclid(find(LabelSet==i),end)=labelingStruct{i,3};
        end
    end
end


if testMode==0 % normaler Modus
    %Speichern der Labelings
    save LabelStruct labelingStruct;
    %Speichern des TrainingsSets
    f=['TrainingSet-' getenv('COMPUTERNAME') datestr(now,'-yyyy-mm-dd_HH-MM-SS') ];
    save(f,'TrainingSetEuclid', 'TrainingSetSVM', 'LabelSet', 'svmFeatureMode');

    %SVM Training
    %svmConstruction(typeSVM, samples, labels)
    svmConstruction(2, TrainingSetSVM', LabelSet');
    
else % crossval Modus
    
    %Speichern der Labelings
    save (['PC-' getenv('COMPUTERNAME') '-Crossval-labelingStruct'] ,'labelingStruct');
    %Speichern des TrainingsSets
    save(['PC-' getenv('COMPUTERNAME') '-Crossval-TrainingSet'],'TrainingSetEuclid', 'TrainingSetSVM', 'LabelSet', 'svmFeatureMode');
    % SVM wird nicht erstellt, erst in

toc(buildTrainingsSetTime)
   
end