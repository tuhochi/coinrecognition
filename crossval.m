function [meanPrecision Precision] = crossval(outputMode,exSize)
%Krossvalidierung mittels Poly-SVM und Euklid Klassifikator
%
%   svmConstruction(typeSVM, samples, labels ,testMode)
%                       Es wir zuerst eine Poly-SVM erstellet, weiters eine
%                       Einteilung mittels cvpartition erstellt.
%                       und die Parameter werden 
%
%   outputMode  gesonderte Ausgabe von Zwischenergebnissen
%               0      off
%               1      on 
%
%   exSize          Skallierungsgroesse der einzelnen Muenzen
%                   Es handelt sich um einen zusaetzlichen Parameter fuer
%                   experimentelle Zwecke
%               0      off
%               >0      resize is on
addpath('tools/osu-svm');

if nargin<1
    outputMode=1;
end

if nargin<2
    exSize=0;
end

%% spezifisches TrainingsSet 

colorMode=[1 2 3];
buildTrainingsSet('collection',1,'_low',colorMode,'normal',1,outputMode,exSize);
%laden der Labelings
load ('Crossval-labelingStruct' ,'labelingStruct');
%laden des TrainingsSets
load('Crossval-TrainingSet');
%SVM wird nun erstellt


%Aufteilung der Daten in Training und TestSet
c = cvpartition(LabelSet,'kfold',316);
%% Nun die jeweiligen Training- und TestSets
Precision=[];
for i=1:c.NumTestSets

    % Trainingset Daten ermitteln
    crossTrainTrainingSetSVM=TrainingSetSVM(c.training(i),:);
    crossTrainTrainingSetEuclid=TrainingSetEuclid(c.training(i),:);
    crossTrainLabelSet=LabelSet(c.training(i),:);
    
    % Testset Daten ermitteln
    crossTestSetSVM=TrainingSetSVM(c.test(i),:); 
    crossTestSetEuclid=TrainingSetEuclid(c.test(i),:);
    crossTestLabelSet=LabelSet(c.test(i),:);
    
    %SVM erstellen
    disp(['Poly SVM (' num2str(i) '/' num2str(c.NumTestSets) ') wird erstellt'])
    [AlphaY, SVs, Bias, Parameters, nSV, nLabel] = PolySVC(crossTrainTrainingSetSVM', crossTrainLabelSet');    

    %% START TEST
    
    %SVM Klassifikation
    [SVMLabel DecisionValue]=SVMClass(crossTestSetSVM', AlphaY, SVs, Bias, Parameters, nSV, nLabel);
    
    %Auswerten der SVM Klassifikation
    precisionSVM=mean(SVMLabel==crossTestLabelSet');
    werte=[];
    for j=1:size(SVMLabel,2)
        werte=[werte labelingStruct{SVMLabel(j),2}==labelingStruct{crossTestLabelSet(j),2}];
    end
    precisionSVMValue=mean(werte);
    
    %Euclidische Klassifikation
    euclidLabel=[];
    for k=1:size(crossTestSetEuclid,1)
            %Distanz berechnen
            dist=getFeatureDistance(crossTestSetEuclid(k,:),crossTrainTrainingSetEuclid);
            [value,index]=min(dist);
            euclidLabel=[euclidLabel crossTrainLabelSet(index)];
    end

    %Auswerten des Euclid Klassifikation
    precisionEuclid=mean(euclidLabel==crossTestLabelSet');
    werte=[];
    for j=1:size(euclidLabel,2)
        werte=[werte labelingStruct{euclidLabel(j),2}==labelingStruct{crossTestLabelSet(j),2}];
    end
    precisionEuclidValue=mean(werte);
    
    %% Klassifikationsrate 
    Precision=[Precision ; precisionSVMValue precisionSVM precisionEuclidValue precisionEuclid];

end
    Precision
meanPrecision=mean(Precision,1);
%% Ergebnisse speichern

end