function []=demoCoinRecognition(demoMode)
%demoCoinRecognition Startet ein Demo-Lauf zum Testen der Muenzerkennung.  
%
%   demoCoinRecognition(demoMode) displays the grayscale image I.
%
% I/O Spec
%   demoMode     0: TrainingSet wird eingelsen und Klassifikator werden
%                   mit diesem trainiert. Anschliessend wird eine
%                   Klassifikation durchgefuehrt.
%
%                1: Klassifikation mit bereits trainierten Klassifikatoren
%                   wird durchgefuehrt.


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% DEMO COINRECOGNITION
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% Training der Klassifikatoren

if demoMode==0
    %Erstellen des TrainingSets und erstellen der Klassifikatoren
    buildTrainingsSet('collection',1,'_low',[1 2 3],'nomal');
end

%% Klassifikation von Testbildern

% Testbild1
imgPath='coin/TestData_low/test1.jpg';
% Extrahieren der Coins
coins=getCoinsFromImage(imgPath,135/4);
%Klassifizierung
[coins labels result1 result2] = classifyCoin(coins,imgPath);


% Testbild2
imgPath='coin/TestData_low/test2.jpg';
% Extrahieren der Coins
coins=getCoinsFromImage(imgPath,135/4);
%Klassifizierung
[coins labels result1 result2] = classifyCoin(coins,imgPath);



% Testbild3
imgPath='coin/TestData_low/test3.jpg';
% Extrahieren der Coins
coins=getCoinsFromImage(imgPath,135/4);
%Klassifizierung
[coins labels result1 result2] = classifyCoin(coins,imgPath);



%Klassifizierungsrate mittels CrossValidation
[meanPrecision Precision]=crossval();
end

